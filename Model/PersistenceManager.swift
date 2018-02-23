//
//  PersistenceManager.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData

protocol PersistenceController {
    var context: NSManagedObjectContext {get}
    func updateContext(block: @escaping () -> ())
    func insertObject<A>() -> A where A: Managed
}

protocol ManagedObjectContext {
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T]
    func save() throws
    func rollback()
}


class PersistenceManager: NSObject, PersistenceController {
    
    private let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    required init(store: NSPersistentContainer) {
        container = store
        context = container.viewContext
    }
    
    public func updateContext(block: @escaping () -> ()) {
        block()
        _ = self.saveOrRestore()
    }
    
    internal func saveOrRestore () -> Bool {
        do {
            try context.save()
            return true
        } catch let error as NSError{
            print(error)
            context.rollback()
            return false
        }
    }
    
    public func insertObject<A>() -> A where A : Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: context) as? A else {
            fatalError("Could not insert object")
        }
        return obj
    }
}
