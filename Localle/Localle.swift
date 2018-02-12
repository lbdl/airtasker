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
    
    static func fetchLocalle(forID localleID: Int64, fromManager manager: PersistenceManager) -> Localle {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), localleID)
        let localle = fetchOrCreate(fromManager: manager, matching: predicate) {
            $0.id = localleID
        }
        return localle
    }

}

extension Localle: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }
}
