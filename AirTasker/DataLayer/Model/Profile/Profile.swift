//
//  Profile.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//
//

import Foundation
import CoreData

public class Profile: NSManagedObject {
    
    @NSManaged fileprivate(set) var id: Int64
    @NSManaged fileprivate(set) var avatar_url: String
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var desc: String
    @NSManaged fileprivate(set) var rating: Double
    @NSManaged fileprivate(set) var activities: Set<Activity>?
    @NSManaged var localle: Localle?
    @NSManaged var location: Location
    
    static func insert(into manager: PersistenceControllerProtocol, raw: ProfileRaw) -> Profile {
        let profile: Profile = fetchProfile(forID: raw.id, fromManager: manager, withJSON: raw)
        profile.avatar_url = raw.avatarURL
        profile.name = raw.firstName
        profile.desc = raw.desc
        profile.rating = raw.rating
        return profile
    }
    
    fileprivate static func fetchProfile(forID profileID: Int64, fromManager manager: PersistenceControllerProtocol, withJSON raw: ProfileRaw) -> Profile {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), profileID)
        let profile = fetchOrCreate(fromManager: manager, matching: predicate) {
            // freshly minted profile object so configure essentials
            $0.location = Location.fetchLocation(forID: raw.locationID, fromManager: manager)
            $0.id = raw.id
            $0.avatar_url = raw.avatarURL
            $0.name = raw.firstName
            $0.desc = raw.desc
            $0.rating = raw.rating
        }
        return profile
    }

}

extension Profile: Managed {
    static var defaulSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(rating), ascending: true)]
    }
    
    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Profile"
    
}


