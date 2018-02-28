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
            
        }

    }
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
