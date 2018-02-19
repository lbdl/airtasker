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
        
        beforeSuite {
            rawData = TestSuiteHelpers.readLocalData(testCase: .locations)
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                sut = LocalleMapper(storeManager: manager!)
            })
        }
        
        afterEach {
            flushDB()
        }
    }
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
