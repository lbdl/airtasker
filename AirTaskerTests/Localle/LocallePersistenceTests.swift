//
//  LocallePersistenceTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 19/02/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import AirTasker

class LocallePersistenceTests: QuickSpec {
    override func spec() {
        
        var locationData: Data?
        var locationMapper: LocationMapper?
        
        var rawData: Data?
        var sut: LocalleMapper?
        var manager: PersistenceManager?
        var persistentContainer: NSPersistentContainer?
        
        func  flushDB() {
            let locationReq = NSFetchRequest<Localle>(entityName: Localle.entityName)
            let profileReq = NSFetchRequest<Profile>(entityName: Profile.entityName)
            let activitiesReq = NSFetchRequest<Activity>(entityName: Activity.entityName)
            let tasksReq = NSFetchRequest<Task>(entityName: Task.entityName)
            let localleReq = NSFetchRequest<Localle>(entityName: Localle.entityName)
            let localles = try! persistentContainer!.viewContext.fetch(localleReq)
            for case let obj as NSManagedObject in localles {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
            let activities = try! persistentContainer!.viewContext.fetch(activitiesReq)
            for case let obj as NSManagedObject in activities {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
            let tasks = try! persistentContainer!.viewContext.fetch(tasksReq)
            for case let obj as NSManagedObject in tasks {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
            let profiles = try! persistentContainer!.viewContext.fetch(profileReq)
            for case let obj as NSManagedObject in profiles {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
            let locations = try! persistentContainer!.viewContext.fetch(locationReq)
            for case let obj as NSManagedObject in locations {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
            
        }
        
        beforeEach {
            rawData = TestSuiteHelpers.readLocalData(testCase: .localle)
            locationData = TestSuiteHelpers.readLocalData(testCase: .locations)
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                sut = LocalleMapper(storeManager: manager!)
                locationMapper = LocationMapper(storeManager: manager!)
                locationMapper?.map(rawValue: locationData!)
                locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
            })
        }
        
        afterEach {
            flushDB()
        }
        
        context("GIVEN a manager AND good JSON") {
            describe("Localle") {
                it ("is persisted") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Localle>(entityName: Localle.entityName)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        let actual = results?.first
                        expect(actual).to(beAKindOf(Localle.self))
                        done()
                    }
                }
                it("has the correct location") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Localle>(entityName: Localle.entityName)
                        request.predicate = NSPredicate(format: "id == %d", 3)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        let actual = results?.first
                        expect(actual?.id).to(equal(actual?.location.id))
                        expect(actual?.location.name).to(equal("Chatswood NSW 2067, Australia"))
                        expect(actual?.location.localle).to(equal(actual))
                        expect(actual?.location.lat).to(equal(-33.79608))
                        expect(actual?.location.long).to(equal(151.1831))
                        done()
                    }
                }
                it("has a collection of profile objects"){
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Localle>(entityName: Localle.entityName)
                        request.predicate = NSPredicate(format: "id == %d", 3)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        let actual = results?.first
                        expect(actual?.users).to(beAKindOf(Set<Profile>.self))
                        expect(actual?.users.count).to(beGreaterThan(0))
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
