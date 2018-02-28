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
        var localleData: Data?
        var localleMapper: LocalleMapper?
        var locationMapper: LocationMapper?
        var manager: PersistenceControllerProtocol?
        var persistentContainer: ManagedContextProtocol?
        var fetchPredicate: NSPredicate?
        var localleRequest: NSFetchRequest<Localle>?
        
        beforeEach {
            locationData = TestSuiteHelpers.readLocalData(testCase: .locations)!
            localleData = TestSuiteHelpers.readLocalData(testCase: .localle)!
            fetchPredicate = NSPredicate(format: "displayName == %@ && id == %d", "Chatswood NSW 2067, Australia", 3)
            localleRequest = NSFetchRequest<Localle>(entityName: Localle.entityName)
            localleRequest?.predicate = fetchPredicate!
            
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                locationMapper = LocationMapper(storeManager: manager!)
                localleMapper = LocalleMapper(storeManager: manager!)
            })
        }
        
        afterEach {
            flushDB()
        }
        
        func flushDB() {
            let fetchRequest = NSFetchRequest<Location>(entityName: Location.entityName)
            let localleReq = NSFetchRequest<Localle>(entityName: Localle.entityName)
            let profileReq = NSFetchRequest<Profile>(entityName: Profile.entityName)
            let activitiesReq = NSFetchRequest<Activity>(entityName: Activity.entityName)
            
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
        }
        
        context("GIVEN a manager and json") {
            describe("WHEN we persist the localle object") {
                it("creates a localle object in the store") {
                    waitUntil { done in
                        locationMapper?.parse(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.parse(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.fetch(localleRequest!)
                        let actual = localles?.first
                        expect(actual).to(beAKindOf(Localle.self))
                        done()
                    }
                }
                it("the localle has a set of profiles") {
                    waitUntil { done in
                        locationMapper?.parse(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.parse(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.fetch(localleRequest!)
                        let actual = localles?.first
                        expect(actual?.users).to(beAKindOf(Set<Profile>.self))
                        expect(actual?.users.count).to(equal(2))
                        done()
                    }
                }
                it("the profile with id: 4 has name: Joey") {
                    waitUntil { done in
                        locationMapper?.parse(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.parse(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.fetch(localleRequest!)
                        let localle = localles?.first
                        let users = localle?.users
                        let joey = users?.first(where: {$0.id == 4})
                        expect(joey).toNot(beNil())
                        expect(joey?.name).to(equal("Joey"))
                        done()
                    }
                }
                it("the profile with id: 4 has a single activity associated with it") {
                    waitUntil { done in
                        locationMapper?.parse(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.parse(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.fetch(localleRequest!)
                        let localle = localles?.first
                        let users = localle?.users
                        let joey = users?.first(where: {$0.id == 4})
                        let activities = joey?.activities
                        expect(activities?.count).to(equal(1))
                        done()
                    }
                }
                it("the profile with id: 3 has 4 activities associated with it") {
                    waitUntil { done in
                        locationMapper?.parse(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.parse(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.fetch(localleRequest!)
                        let localle = localles?.first
                        let users = localle?.users
                        let actual = users?.first(where: {$0.id == 3})
                        let activities = actual?.activities
                        expect(activities?.count).to(equal(4))
                        done()
                    }
                }
                it("the profile with id: 4 activtity has an associated task") {
                    waitUntil { done in
                        locationMapper?.parse(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.parse(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.fetch(localleRequest!)
                        let localle = localles?.first
                        let users = localle?.users
                        let actual = users?.first(where: {$0.id == 4})
                        let activities = actual?.activities
                        let activity = activities?.first(where: {$0.id == 2})
                        expect(activity?.task!).to(beAKindOf(Task.self))
                        done()
                    }
                }
                it("the activity associatied with profile id:4 has an associated task with correct properties") {
                    waitUntil { done in
                        locationMapper?.parse(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.parse(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.fetch(localleRequest!)
                        let localle = localles?.first
                        let users = localle?.users
                        let actual = users?.first(where: {$0.id == 4})
                        let activities = actual?.activities
                        let activity = activities?.first(where: {$0.id == 2})
                        let task = activity?.task
                        expect(task?.desc).to(equal("A good clean including: \nBathrooms - clean toilets, bath, shower screens and vanities, wash tiled walls and mop floors. Clean window frames. x3"))
                        expect(task?.name).to(equal("Clean a 4 bedroom large house"))
                        expect(task?.activities?.count).to(equal(2))
                        expect(task?.state).to(equal("assigned"))
                        expect(task?.worker?.id).to(equal(1))
                        expect(task?.worker?.profile).to(beNil())
                        done()
                    }
                }
                it("activity id: 3 associatied with profile id:3 has an associated with worker associated profile") {
                    waitUntil { done in
                        locationMapper?.parse(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.parse(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.fetch(localleRequest!)
                        let localle = localles?.first
                        let users = localle?.users
                        let actual = users?.first(where: {$0.id == 3})
                        let activities = actual?.activities
                        let activity = activities?.first(where: {$0.id == 3})
                        let task = activity?.task
                        expect(task?.desc).to(equal("Hi, I have two baskets of ironing and folding and putting away that I would love some extra help with if someone has time. Need this to be done at my house."))
                        expect(task?.name).to(equal("2 x Baskets of Ironing"))
                        expect(task?.activities?.count).to(equal(3))
                        expect(task?.state).to(equal("assigned"))
                        expect(task?.worker?.id).to(equal(3))
                        expect(task?.worker?.profile?.name).to(equal("Phoebe"))
                        done()
                    }
                }
                describe("WHEN we parse another localle") {
                    it("persists 2 localles") {
                        waitUntil {done in
                            locationMapper?.parse(rawValue: locationData!)
                            localleMapper?.parse(rawValue: localleData!)
                            locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                            localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                            
                            // map a second localle
                            localleData = TestSuiteHelpers.readLocalData(testCase: .localle2)
                            localleMapper?.parse(rawValue: localleData!)
                            localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                            let locallesReq = NSFetchRequest<Localle>(entityName: Localle.entityName)
                            let localles = try! persistentContainer?.fetch(locallesReq)
                            expect(localles?.count).to(equal(2))
                            done()
                        }
                    }
                    it("localle:5 contains profile:5 with location:2") {
                        waitUntil {done in
                            locationMapper?.parse(rawValue: locationData!)
                            localleMapper?.parse(rawValue: localleData!)
                            locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                            localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                            
                            // map a second localle
                            localleData = TestSuiteHelpers.readLocalData(testCase: .localle2)
                            localleMapper?.parse(rawValue: localleData!)
                            localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                            let locallesReq = NSFetchRequest<Localle>(entityName: Localle.entityName)
                            locallesReq.predicate = NSPredicate(format: "id == %d", 5)
                            let localles = try! persistentContainer?.fetch(locallesReq)
                            let localle = localles?.first
                            let actual = localle?.users.first(where: {$0.id == 5})
                            expect(actual?.location.name).to(equal("Parramatta NSW, Australia"))
                            expect(actual?.location.id).to(equal(2))
                            done()
                        }
                    }
                    it("persists a total of 8 activities") {
                        waitUntil {done in
                            //persist first localle
                            locationMapper?.parse(rawValue: locationData!)
                            localleMapper?.parse(rawValue: localleData!)
                            locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                            localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                            
                            // persist a second localle
                            localleData = TestSuiteHelpers.readLocalData(testCase: .localle2)
                            localleMapper?.parse(rawValue: localleData!)
                            localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                            let activitiesReq = NSFetchRequest<Activity>(entityName: Activity.entityName)
                            let activities = try! persistentContainer?.fetch(activitiesReq)
                            expect(activities?.count).to(equal(8))
                            done()
                        }
                    }
                }
            }
        }
    }
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
