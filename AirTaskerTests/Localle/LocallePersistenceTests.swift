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
        var manager: PersistenceManager?
        var persistentContainer: NSPersistentContainer?
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
            let profiles = try! persistentContainer!.viewContext.fetch(profileReq)
            for case let obj as NSManagedObject in profiles {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
            let activities = try! persistentContainer!.viewContext.fetch(activitiesReq)
            for case let obj as NSManagedObject in activities {
                persistentContainer!.viewContext.delete(obj)
                try! persistentContainer!.viewContext.save()
            }
        }
        
        context("GIVEN a manager and json") {
            describe("WHEN we persist the localle object") {
                it("creates a localle object in the store") {
                    waitUntil { done in
                        locationMapper?.map(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.map(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.viewContext.fetch(localleRequest!)
                        let actual = localles?.first
                        expect(actual).to(beAKindOf(Localle.self))
                        done()
                    }
                }
                it("the localle has a set of profiles") {
                    waitUntil { done in
                        locationMapper?.map(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.map(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.viewContext.fetch(localleRequest!)
                        let actual = localles?.first
                        expect(actual?.users).to(beAKindOf(Set<Profile>.self))
                        expect(actual?.users.count).to(equal(2))
                        done()
                    }
                }
                it("the profile with id: 4 has name: Joey") {
                    waitUntil { done in
                        locationMapper?.map(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.map(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.viewContext.fetch(localleRequest!)
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
                        locationMapper?.map(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.map(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.viewContext.fetch(localleRequest!)
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
                        locationMapper?.map(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.map(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.viewContext.fetch(localleRequest!)
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
                        locationMapper?.map(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.map(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.viewContext.fetch(localleRequest!)
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
                        locationMapper?.map(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.map(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.viewContext.fetch(localleRequest!)
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
                it("activity id: 3 associatied with profile id:3 has an associated task with associated worker with associated profile") {
                    waitUntil { done in
                        locationMapper?.map(rawValue: locationData!)
                        locationMapper?.persist(rawJson: (locationMapper?.mappedValue)!)
                        localleMapper?.map(rawValue: localleData!)
                        localleMapper?.persist(rawJson: (localleMapper?.mappedValue)!)
                        let localles = try! persistentContainer?.viewContext.fetch(localleRequest!)
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
            }
        }
    }
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
