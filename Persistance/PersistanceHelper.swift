//
//  PersistanceHelper.swift
//  AirTasker
//
//  Created by Timothy Storey on 27/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData

class PersistanceHelper: NSObject {
    
    static func createProductionContainer (completion: @escaping(NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "AirTasks")
        container.loadPersistentStores { (_, error) in
            guard error == nil else {
                fatalError("Failed to load store: \(error!)")
            }
            DispatchQueue.main.async {
                completion(container)
            }
        }
    }
    
    // for Unit tests
    static func createInMemoryContainer (completion: @escaping(NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "PersistentTodoList")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
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
