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
    @NSManaged fileprivate(set) var localle: Localle
    @NSManaged fileprivate(set) var profiles: Set<Profile>?
    
    static func insert(into manager: PersistenceControllerProtocol, raw: LocationRaw) -> Location {
        let location: Location = manager.insertObject()
        location.id = raw.id
        location.lat = raw.lat
        location.long = raw.long
        location.name = raw.name
        return location
    }
    
    static func fetchLocation(forID locationID: Int64, fromManager manager: PersistenceControllerProtocol) -> Location {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(id), locationID)
        let location = fetchOrCreate(fromManager: manager, matching: predicate) {
            $0.id = locationID
        }
        return location
    }

}

extension Location: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(id), ascending: true)]
    }
    
    // overidden to stop odd test failures using in memory store DB
    // which doesn't seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, individual sets of
    // tests run fine. Sigh...
    static var entityName = "Location"
}
