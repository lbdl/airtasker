//
//  Task.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//
//

import Foundation
import CoreData

public class Task: NSManagedObject {
    @NSManaged fileprivate(set) var id: Int64
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var desc: String
    @NSManaged fileprivate(set) var state: String
    @NSManaged fileprivate(set) var profile: Profile?
    @NSManaged fileprivate(set) var worker: Worker?
    @NSManaged fileprivate(set) var activities: Set<Activity>?
    
    static func insert(into manager: PersistenceController, raw: TaskRaw) -> Task {
        let task: Task = manager.insertObject()
        task.id = raw.id
        task.name = raw.name
        task.desc = raw.desc
        task.state = raw.eventState
        //task.profile = Profile.fetchProfile(forID: raw.profileID, fromManager: manager)
        return task
    }
    
    static func fetchTask(forID taskID: Int64, fromManager manager: PersistenceController, withJSON raw: TaskRaw) -> Task {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), taskID)
        let task = fetchOrCreate(fromManager: manager, matching: predicate) {
            // freshly baked object so we need to set the attributes
            $0.id = 0
        }
        return task
    }
}

extension Task: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }
    
    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Task"
}
