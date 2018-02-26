//
//  Localle.swift
//  AirTasker
//
//  Created by Timothy Storey on 12/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import CoreData

final class Localle: NSManagedObject {
    @NSManaged fileprivate(set) var id: Int64
    @NSManaged fileprivate(set) var users: Set<Profile>
    @NSManaged fileprivate(set) var location: Location
    @NSManaged fileprivate(set) var displayName: String?
    
    static func insert(into manager: PersistenceControllerProtocol, raw: LocalleRaw) -> Localle {
        let localle = fetchLocalle(forID: raw.id, fromManager: manager, raw: raw)
        localle.displayName = raw.displayName
        localle.location = Location.fetchLocation(forID: raw.id, fromManager: manager)
        let usersArray: [Profile] = raw.profiles.map({ profileRaw in
            let user = Profile.insert(into: manager, raw: profileRaw)
            user.localle = localle
            return user
        })
        let usersSet = Set(usersArray)
        localle.users = usersSet
        _ = makeTasks(raw: raw.tasks, manager: manager)
        _ = makeActivities(raw: raw.activities, manager: manager)
        return localle
    }
    
    fileprivate static func fetchLocalle(forID localleID: Int64, fromManager manager: PersistenceControllerProtocol, raw: LocalleRaw) -> Localle {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), localleID)
        let localle = fetchOrCreate(fromManager: manager, matching: predicate) {
            //fresh object configure fields from json
            $0.id = localleID
            $0.displayName = raw.displayName
            $0.location = Location.fetchLocation(forID: raw.id, fromManager: manager)
            $0.users = Set(makeUsers(raw: raw.profiles, manager: manager))
        }
        return localle
    }
    
    fileprivate static func makeActivities(raw: [ActivityRaw], manager: PersistenceControllerProtocol) -> [Activity]{
        let objArray: [Activity] = raw.map({ activityRaw in
            let activity = Activity.insert(into: manager, raw: activityRaw)
            let profilePredicate = NSPredicate(format: "%K == %d", #keyPath(id), activityRaw.profileID)
            activity.profile = Profile.findOrFetch(fromManager: manager, matching: profilePredicate)
            let taskPredicate = NSPredicate(format: "%K == %d", #keyPath(id), activityRaw.id)
            activity.task = Task.findOrFetch(fromManager: manager, matching: taskPredicate)
            return activity
        })
        return objArray
    }
    
    fileprivate static func makeTasks(raw: [TaskRaw], manager: PersistenceControllerProtocol) -> [Task] {
        let objArray: [Task] = raw.map({ taskRaw in
            let task = Task.insert(into: manager, raw: taskRaw)
            if let workerId = taskRaw.workerID {
                task.worker = Worker.insert(into: manager, workerId: workerId)
            }
            return task
        })
        return objArray
    }
    
    fileprivate static func makeUsers(raw: [ProfileRaw], manager: PersistenceControllerProtocol) -> [Profile] {
        let objArray: [Profile] = raw.map({ profileRaw in
            let profile = Profile.insert(into: manager, raw: profileRaw)
            //let profile = Profile.fetchProfile(forID: profileRaw.id, fromManager: manager, withJSON: profileRaw)
            let locallePredicate = NSPredicate(format: "%K == %d", #keyPath(id), profileRaw.locationID)
            profile.localle = Localle.findOrFetch(fromManager: manager, matching: locallePredicate)
            return profile
        })
        return objArray
    }
    
    
    
}

extension Localle: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }
    
    // Overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entire test suite, individual sets of
    // tests run fine. I'm sure somewhere there's a fix. perhaps.
    // sigh...
    static var entityName = "Localle"
}
