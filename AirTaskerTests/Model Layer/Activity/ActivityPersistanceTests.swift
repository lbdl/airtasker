//
//  ActivityPersistanceTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 16/02/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import AirTasker

class ActivityPersistanceTests: QuickSpec {
    override func spec() {
        
        var rawData: Data?
        var sut: ActivityMapper?
        var manager: PersistenceControllerProtocol?
        var persistentContainer: ManagedContextProtocol?
        
        func  flushDB() {
            let activityRequest = NSFetchRequest<Activity>(entityName: Activity.entityName)
            let profileRequest = NSFetchRequest<Profile>(entityName: Profile.entityName)
            let tasks = try! persistentContainer!.fetch(activityRequest)
            let profiles = try! persistentContainer!.fetch(profileRequest)
            for case let obj as NSManagedObject in tasks {
                persistentContainer!.delete(obj)
                try! persistentContainer!.save()
            }
            for case let obj as NSManagedObject in profiles {
                persistentContainer!.delete(obj)
            }
        }
        
        beforeSuite {
            rawData = TestSuiteHelpers.readLocalData(testCase: .activity)!
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                sut = ActivityMapper(storeManager: manager!)
            })
        }
        
        afterEach {
            flushDB()
        }
        
        context("GIVEN good Activity JSON") {
            describe("WHEN we parse and persist the data") {
                it ("persists activity objects") {
                    waitUntil { done in
                        sut?.parse(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Activity>(entityName: Activity.entityName)
                        let results = try! persistentContainer?.fetch(request)
                        expect(results?.count).toNot(equal(0))
                        done()
                    }
                }
                it ("persists 3 activities only") {
                    waitUntil { done in
                        sut?.parse(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Activity>(entityName: Activity.entityName)
                        let results = try! persistentContainer?.fetch(request)
                        expect(results?.count).to(equal(3))
                        done()
                    }
                }
                it ("persists an activity for id: 4 with correct details") {
                    waitUntil { done in
                        sut?.parse(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Activity>(entityName: Activity.entityName)
                        request.predicate = NSPredicate(format: "id == %d", 4)
                        let results = try! persistentContainer?.fetch(request)
                        let actual = results?.first
                        expect(actual?.id).to(equal(4))
                        expect(actual?.event).to(equal("post"))
                        expect(actual?.internalMessage).to(equal("{profileName} posted {taskName}"))
                        done()
                    }
                }
            }
        }
        
        context("GIVEN valid JSON and a populated DB") {
            var manager: PersistenceControllerProtocol?
            var persistentContainer: ManagedContextProtocol?
            let locationData = TestSuiteHelpers.readLocalData(testCase: .locations)!
            let localleData = TestSuiteHelpers.readLocalData(testCase: .localle)!
            var localleMapper: LocalleMapper?
            var locationMapper: LocationMapper?
            
            describe("WHEN we persist an activity") {
                
                beforeEach {
                    TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                        persistentContainer = container
                        manager = PersistenceManager(store: persistentContainer!)
                        localleMapper = LocalleMapper(storeManager: manager!)
                        locationMapper = LocationMapper(storeManager: manager!)
                        
                        locationMapper?.parse(rawValue: locationData)
                        localleMapper?.parse(rawValue: localleData)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue!)!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue!)!)
                        
                    })
                }
                
                afterEach {
                    let fetchRequest = NSFetchRequest<Location>(entityName: Location.entityName)
                    let localleReq = NSFetchRequest<Localle>(entityName: Localle.entityName)
                    let profileReq = NSFetchRequest<Profile>(entityName: Profile.entityName)
                    let activitiesReq = NSFetchRequest<Activity>(entityName: Activity.entityName)
                    let taskReq = NSFetchRequest<Task>(entityName: Task.entityName)
                    
                    let objs = try! persistentContainer!.fetch(fetchRequest)
                    for case let obj as NSManagedObject in objs {
                        persistentContainer!.delete(obj)
                        try! persistentContainer!.save()
                    }
                    let localles = try! persistentContainer!.fetch(localleReq)
                    for case let obj as NSManagedObject in localles {
                        persistentContainer!.delete(obj)
                        try! persistentContainer!.save()
                    }
                    let profiles = try! persistentContainer!.fetch(profileReq)
                    for case let obj as NSManagedObject in profiles {
                        persistentContainer!.delete(obj)
                        try! persistentContainer!.save()
                    }
                    let activities = try! persistentContainer!.fetch(activitiesReq)
                    for case let obj as NSManagedObject in activities {
                        persistentContainer!.delete(obj)
                        try! persistentContainer!.save()
                    }
                    let tasks = try! persistentContainer!.fetch(taskReq)
                    for case let obj as NSManagedObject in tasks {
                        persistentContainer!.delete(obj)
                        try! persistentContainer!.save()
                    }
                }
                
                it("has a completed message property for activity 3"){
                    waitUntil{ done in
                        let request = NSFetchRequest<Activity>(entityName: Activity.entityName)
                        request.predicate = NSPredicate(format: "id == %d && event == %@", 3, "assigned")
                        let results = try! persistentContainer?.fetch(request)
                        let actual = results?.first
                        expect(actual?.message()).toNot(beNil())
                        expect(actual?.message()).to(equal("Phoebe was assigned 2 x Baskets of Ironing"))
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
