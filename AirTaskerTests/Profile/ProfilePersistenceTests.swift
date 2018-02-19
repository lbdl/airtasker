//
//  ProfilePersistenceTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 13/02/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import AirTasker

class ProfilePersistenceTests: QuickSpec {
    override func spec() {
        var rawData: Data?
        var sut: ProfileMapper?
        var manager: PersistenceManager?
        var persistentContainer: NSPersistentContainer?
        
        func  flushDB() {
            let profileRequest = NSFetchRequest<Profile>(entityName: "Profile")
            let localleRequest = NSFetchRequest<Localle>(entityName: "Localle")
            let profiles = try! persistentContainer!.viewContext.fetch(profileRequest)
            let localles = try! persistentContainer!.viewContext.fetch(localleRequest)
            for case let obj as NSManagedObject in profiles {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
            for case let obj as NSManagedObject in localles {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
        }
        
        beforeSuite {
            rawData = TestSuiteHelpers.readLocalData(testCase: .profile)
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                sut = ProfileMapper(storeManager: manager!)
            })
        }
        
        afterEach {
            flushDB()
        }
        
        context("GIVEN a manager AND good JSON") {
            describe("Profiles are persisted to storage") {
                it ("persists locations") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Profile>(entityName: Profile.entityName)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        expect(results?.count).toNot(equal(0))
                        done()
                    }
                }
                it ("persists 5 profiles only") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Profile>(entityName: Profile.entityName)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        expect(results?.count).to(equal(5))
                        done()
                    }
                }
                it ("persists a profile for id: 3 with correct details") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        sut?.persist(rawJson: (sut?.mappedValue)!)
                        let request = NSFetchRequest<Profile>(entityName: Profile.entityName)
                        request.predicate = NSPredicate(format: "id == %d", 3)
                        let results = try! persistentContainer?.viewContext.fetch(request)
                        let actual = results?.first
                        expect(actual?.id).to(equal(3))
                        expect(actual?.name).to(equal("Phoebe"))
                        expect(actual?.desc).to(equal("smelly cat, smelly cat what are they feeding you"))
                        expect(actual?.rating).to(equal(3))
                        expect(actual?.avatar_url).to(equal("/img/3.jpg"))
                        expect(actual?.localle.id).to(equal(5))
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
