//
//  Location.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//
//

import Foundation
import CoreData

final class Location: NSManagedObject {
    @NSManaged fileprivate(set) var id: Int64
    @NSManaged fileprivate(set) var lat: Double
    @NSManaged fileprivate(set) var long: Double
    @NSManaged fileprivate(set) var name: String
    
    static func insert(into manager: PersistenceManager, raw: LocationRaw) -> Location {
        let location: Location = manager.insertObject()
        location.id = raw.id
        location.lat = raw.lat
        location.long = raw.long
        location.name = raw.name
        return location
    }

}

extension Location: Managed {
    static var defaulSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }    
}
