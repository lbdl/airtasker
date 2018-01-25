//
//  Localle+CoreDataProperties.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Localle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localle> {
        return NSFetchRequest<Localle>(entityName: "Localle")
    }

    @NSManaged public var id: Int64
    @NSManaged public var location: Location?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for users
extension Localle {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: Profile)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: Profile)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
