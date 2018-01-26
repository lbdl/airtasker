//
//  TestSuiteHelpers.swift
//  AirTaskerTests
//
//  Created by Timothy Storey on 26/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData

class TestSuiteHelpers: NSObject {
    
    static func readLocalData() -> Data? {
        let testBundle = Bundle(for: self)
        let url = testBundle.url(forResource: "locations", withExtension: "json")
        guard let data = NSData(contentsOf: url!) as Data? else {return nil}
        return data
    }
    
    static func managedObjectModel() -> NSManagedObjectModel {
        let testBundle = Bundle(for: self)
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [testBundle] )!
        return managedObjectModel
    }
    
    
    static func buildDummyDataStack() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "PersistentTodoList", managedObjectModel: managedObjectModel())
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }
}
