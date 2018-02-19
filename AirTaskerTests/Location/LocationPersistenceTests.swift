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
            let fetchRequest = NSFetchRequest<Location>(entityName: Location.entityName)
            let localleReq = NSFetchRequest<Localle>(entityName: Localle.entityName)
            let objs = try! persistentContainer!.viewContext.fetch(fetchRequest)
            for case let obj as NSManagedObject in objs {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
            let localles = try! persistentContainer!.viewContext.fetch(localleReq)
            for case let obj as NSManagedObject in localles {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
            
        }
        
        beforeSuite {
            rawData = TestSuiteHelpers.readLocalData(testCase: .locations)
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                sut = LocationMapper(storeManager: manager!)
            })
        }
        
        afterEach {
            flushDB()
        }
        
        context("GIVEN a manager AND good JSON") {
            describe("Locations are persisted to storage") {
                it ("persists locations") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Location>(entityName: Location.entityName)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        expect(results).toNot(beNil())
                        done()
                    }
                }
                it ("persists 5 locations only") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Location>(entityName: Location.entityName)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        expect(results?.count).to(equal(5))
                        done()
                    }
                }
                it ("persists a location for id: 3 with correct details") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Location>(entityName: Location.entityName)
                        request.predicate = NSPredicate(format: "id == %d", 3)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        let actual = results?.first
                        expect(actual?.id).to(equal(3))
                        expect(actual?.name).to(equal("Chatswood NSW 2067, Australia"))
                        expect(actual?.lat).to(equal(-33.79608))
                        expect(actual?.long).to(equal(151.1831))
                        done()
                    }
                }
                it ("creates a localle object in the DB and the corresponding relationship") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Location>(entityName: Location.entityName)
                        request.predicate = NSPredicate(format: "id == %d", 3)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        let actual = results?.first
                        expect(actual?.localle).to(beAKindOf(Localle.self))
                        done()
                    }
                }
            }
        }
    }
    
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
