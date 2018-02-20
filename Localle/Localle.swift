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
    
    static func fetchLocalle(forID localleID: Int64, fromManager manager: PersistenceController) -> Localle {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), localleID)
        let localle = fetchOrCreate(fromManager: manager, matching: predicate) {
            $0.id = localleID
        }
        return localle
    }
    
    static func insert(into manager: PersistenceController, raw: LocalleRaw) -> Localle {
        let localle: Localle = manager.insertObject()
        localle.id = raw.id
        localle.displayName = raw.displayName
        localle.location = Location.fetchLocation(forID: raw.id, fromManager: manager)
        let usersArray: [Profile] = raw.profiles.map({ profileRaw in
            let user = Profile.insert(into: manager, raw: profileRaw)
            user.localle = localle
            return user
        })
        let usersSet = Set(usersArray)
        localle.users = usersSet
        _ = makeActivities(raw: raw.activities, manager: manager)
        
        return localle
    }
    
    fileprivate static func makeActivities(raw: [ActivityRaw], manager: PersistenceController) -> [Activity]{
        let objArray: [Activity] = raw.map({ activityRaw in
            let activity = Activity.insert(into: manager, raw: activityRaw)
            let predicate = NSPredicate(format: "%K == %d", #keyPath(id), activityRaw.profileID)
            activity.profile = Profile.findOrFetch(fromManager: manager, matching: predicate)
            return activity
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
