//
//  Location+CoreDataProperties.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var id: Int64
    @NSManaged public var long: String?
    @NSManaged public var name: String?
    @NSManaged public var lat: String?
    @NSManaged public var localle: Localle?

}
