//
//  TaskPersistenceTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 16/02/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import AirTasker

class TaskPersistenceTests: QuickSpec {
    override func spec() {
        
        var rawData: Data?
        var sut: TaskMapper?
        var manager: PersistenceManager?
        var persistentContainer: ManagedContextProtocol?
        
        func  flushDB() {
            let taskRequest = NSFetchRequest<Task>(entityName: Task.entityName)
            let profileRequest = NSFetchRequest<Profile>(entityName: Profile.entityName)
            let localleRequest = NSFetchRequest<Localle>(entityName: Localle.entityName)
            let tasks = try! persistentContainer!.fetch(taskRequest)
            let profiles = try! persistentContainer!.fetch(profileRequest)
            let localles = try! persistentContainer!.fetch(localleRequest)
            for case let obj as NSManagedObject in tasks {
                persistentContainer!.delete(obj)
                try! persistentContainer!.save()
            }
            for case let obj as NSManagedObject in profiles {
                persistentContainer!.delete(obj)
                try! persistentContainer!.save()
            }
            for case let obj as NSManagedObject in localles {
                persistentContainer!.delete(obj)
                try! persistentContainer!.save()
            }
        }
        
        beforeSuite {
            rawData = TestSuiteHelpers.readLocalData(testCase: .task)!
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                sut = TaskMapper(storeManager: manager!)
            })
        }
        
        afterEach {
            flushDB()
        }
        
        context("GIVEN valid Task json") {
            describe("Tasks are persisted to storage") {
                it ("persists tasks") {
                    waitUntil { done in
                        sut?.parse(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Task>(entityName: Task.entityName)
                        let results = try! persistentContainer?.fetch(request)
                        expect(results?.count).toNot(equal(0))      
                        done()
                    }
                }
                it ("persists 2 tasks only") {
                    waitUntil { done in
                        sut?.parse(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Task>(entityName: Task.entityName)
                        let results = try! persistentContainer?.fetch(request)
                        expect(results?.count).to(equal(2))
                        done()
                    }
                }
                it ("persists a task for id: 5 with correct details") {
                    waitUntil { done in
                        sut?.parse(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Task>(entityName: Task.entityName)
                        request.predicate = NSPredicate(format: "id == %d", 5)
                        let results = try! persistentContainer?.fetch(request)
                        let actual = results?.first
                        expect(actual?.id).to(equal(5))
                        expect(actual?.name).to(equal("Hang mirror"))
                        expect(actual?.desc).to(equal("Looking for someone to hang a mirror on brick wall above a fire place."))
                        expect(actual?.state).to(equal("posted"))
                        expect(actual?.worker).to(beNil())
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
