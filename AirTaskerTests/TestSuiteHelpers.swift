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
    
    static func readLocalData(badData bad: Bool) -> Data? {
        let testBundle = Bundle(for: self)
        var url: URL?
        if bad {
            url = testBundle.url(forResource: "badLocations", withExtension: "json")
        }else {
            url = testBundle.url(forResource: "locations", withExtension: "json")
        }
        guard let data = NSData(contentsOf: url!) as Data? else {return nil}
        return data
    }
    
    // for testing without persisting data
    static func createInMemoryContainer (completion: @escaping(NSPersistentContainer) -> ()) {
        let bundle: Bundle = Bundle(for: TestSuiteHelpers.self)
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [bundle])
        let container = NSPersistentContainer(name: "AirTasks")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        description.configuration = "Default"
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            guard error == nil else {
                fatalError("Failed to load in memory store \(error!)")
            }
        }
        DispatchQueue.main.async {
            completion(container)
        }
    }
}
