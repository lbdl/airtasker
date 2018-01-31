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
    func saveContext()
    func insertObject<A>(Object: A) -> A where A: Managed
}


class PersistenceManager: NSObject, PersistenceController {
    
    private let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    required init(store: NSPersistentContainer) {
        container = store
        context = container.viewContext
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insertObject<A>(Object: A) -> A where A : Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: context) as? A else {
            fatalError("Could not insert \(Object)")
        }
        return obj
    }
}
