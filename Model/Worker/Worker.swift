//
//  Worker+CoreDataProperties.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//
//

import Foundation
import CoreData

public class Worker: NSManagedObject {
    @NSManaged fileprivate(set) var id: Int64
    @NSManaged var tasks: Set<Task>?
    @NSManaged var profile: Profile?
    
    static func insert(into manager: PersistenceController, workerId: Int64) -> Worker {
        let worker: Worker = fetchWorker(forID: workerId, fromManager: manager)
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), workerId)
        worker.profile = Profile.findOrFetch(fromManager: manager, matching: predicate)
        return worker
    }
    
    fileprivate static func fetchWorker(forID profileID: Int64, fromManager manager: PersistenceController) -> Worker {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), profileID)
        let worker = fetchOrCreate(fromManager: manager, matching: predicate) {
            // freshly baked object so we need to set the attributes
            $0.id = profileID
            $0.profile = Profile.findOrFetch(fromManager: manager, matching: predicate)
        }
        return worker
    }
}

extension Worker: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }
    
    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Worker"
    
}
