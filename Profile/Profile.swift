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
    @NSManaged fileprivate(set) var tasks: NSSet?
    @NSManaged fileprivate(set) var localle: Localle
    
    static func insert(into manager: PersistenceController, raw: ProfileRaw) -> Profile {
        let profile: Profile = manager.insertObject()
        profile.id = raw.id
        profile.avatar_url = raw.avatarURL
        profile.name = raw.firstName
        profile.desc = raw.desc
        profile.rating = raw.rating
        profile.localle = Localle.fetchLocalle(forID: raw.locationID, fromManager: manager)
        return profile
    }
    
    static func fetchProfile(forID profileID: Int64, fromManager manager: PersistenceController) -> Profile {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), profileID)
        let profile = fetchOrCreate(fromManager: manager, matching: predicate) {
            // freshly minted profile object so configure essentials
            // core data wont create the Localle object for the localle relationship
            // so we need to add it ourselves
            $0.id = profileID
            $0.localle = Localle.fetchLocalle(forID: 0, fromManager: manager)
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


