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
    @NSManaged fileprivate(set) var avatar_url: String?
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var desc: String?
    @NSManaged fileprivate(set) var rating: Int16
    @NSManaged fileprivate(set) var tasks: NSSet?
    @NSManaged fileprivate(set) var localle: Localle?
    
//    static func insert(into manager: PersistenceController, raw: ProfileRaw) -> Profile {
//        let profile: Profile = manager.insertObject()
//        return profile
//    }
//
}

extension Profile: Managed {
    static var defaulSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(rating), ascending: true)]
    }
}


