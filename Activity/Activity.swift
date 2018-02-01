//
//  Activity.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//
//

import Foundation
import CoreData

public class Activity: NSManagedObject {
    @NSManaged fileprivate(set) var id: Int64
    @NSManaged fileprivate(set) var message: String?
    @NSManaged fileprivate(set) var event: String?
    @NSManaged fileprivate(set) var task: Task?
}
