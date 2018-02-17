//
//  TestSuiteHelpers.swift
//  AirTaskerTests
//
//  Created by Timothy Storey on 26/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData
@testable import AirTasker



class TestSuiteHelpers: NSObject {
    
    enum TestType {
        case locations
        case profile
        case task
        case activity
        case localle
        case badLocation
        case badProfile
        case badTask
        case badActivity
        case badLocalle
    }
    
    static func readLocalData(testCase: TestType) -> Data? {
        let testBundle = Bundle(for: self)
        var url: URL?
        
        switch testCase {
        case .badLocation:
            url = testBundle.url(forResource: "badLocations", withExtension: "json")
        case .badProfile:
            url = testBundle.url(forResource: "badProfiles", withExtension: "json")
        case .locations:
            url = testBundle.url(forResource: "locations", withExtension: "json")
        case .profile:
            url = testBundle.url(forResource: "profiles", withExtension: "json")
        case .task:
            url = testBundle.url(forResource: "tasks", withExtension: "json")
        case .localle:
            url = testBundle.url(forResource: "localle5", withExtension: "json")
        case .badTask:
            url = testBundle.url(forResource: "badTasks", withExtension: "json")
        case .activity:
            url = testBundle.url(forResource: "activities", withExtension: "json")
        case .badActivity:
            url = testBundle.url(forResource: "badActivities", withExtension: "json")
        default:
            break
        }
        guard let data = NSData(contentsOf: url!) as Data? else {return nil}
        return data
    }
    
    // for testing without persisting data
    static func createInMemoryContainer (completion: @escaping(NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "AirTasks")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        description.configuration = "Default"
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            guard error == nil else {
                fatalError("Failed to load in memory store \(error!)")
            }
        }
        DispatchQueue.main.async {
            completion(container)
        }
    }
}
