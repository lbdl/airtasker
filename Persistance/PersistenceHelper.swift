//
//  PersistenceHelper.swift
//  AirTasker
//
//  Created by Timothy Storey on 27/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData

class PersistenceHelper: NSObject {
    
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
    
    // for testing without persisting data
    static func createInMemoryContainer (completion: @escaping(NSPersistentContainer) -> ()) {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self) as! AnyClass)] )!
        let container = NSPersistentContainer(name: "AirTasks", managedObjectModel: managedObjectModel)
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
