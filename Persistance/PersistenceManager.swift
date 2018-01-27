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
}

class PersistenceManager: NSObject, PersistenceController {
    
    private let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    required init(store: NSPersistentContainer) {
        container = store
        context = container.viewContext
    }
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
