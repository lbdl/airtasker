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
    
    static func insert(into manager: PersistenceController, raw: LocationRaw) -> Location {
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
    
    // overidden to stop odd test failures in inmemory store
    // which doesnt seem to tidy itself up properly
    // nor always load the models. This only happens
    // when running the entoire test suite, indivdual sets of
    // tests run fine. Sigh...
    static var entityName = "Location"
}
