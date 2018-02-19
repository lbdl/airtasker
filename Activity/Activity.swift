//
//  Activity.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//
//

import Foundation
import CoreData

public class Activity: NSManagedObject {
    
    @NSManaged fileprivate(set) var id: Int64
    @NSManaged fileprivate(set) var internalMessage: String?
    @NSManaged fileprivate(set) var event: String?
    @NSManaged fileprivate(set) var task: Task?
    
    static func insert(into manager: PersistenceController, raw: ActivityRaw) -> Activity {
        let activity: Activity = manager.insertObject()
        activity.id = raw.id
        activity.internalMessage = raw.internalMessage
        activity.event = raw.event
        activity.task = Task.fetchTask(forID: raw.id, fromManager: manager)  
        return activity
    }
}

extension Activity: Managed {
    static var defaulSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }
    
    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Activity"
    
}
