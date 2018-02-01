//
//  LocationPersistenceTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 31/01/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import AirTasker

class LocationPersistenceTests: QuickSpec {
    override func spec() {
        var rawData: Data?
        var sut: LocationMapper?
        var manager: PersistenceManager?
        var persistentContainer: NSPersistentContainer?
        
        func  flushDB() {
            let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
            let objs = try! persistentContainer!.viewContext.fetch(fetchRequest)
            for case let obj as NSManagedObject in objs {
                persistentContainer!.viewContext.delete(obj)
            }
            try! persistentContainer!.viewContext.save()
        }
        
        context("GIVEN a manager AND good JSON") {
            describe("Locations are persisted to storage") {
                rawData = TestSuiteHelpers.readLocalData(badData: false)
                waitUntil { done in
                    TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                        persistentContainer = container
                        manager = PersistenceManager(store: persistentContainer!)
                        sut = LocationMapper(storeManager: manager!)
                        sut?.map(rawValue: rawData!)
                        let request = NSFetchRequest<Location>(entityName: Location.entityName)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        expect(results).toNot(beNil())
                        flushDB()
                        done()
                    })
                }
            }
        }
    }
    
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
