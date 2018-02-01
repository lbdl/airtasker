//
//  Task.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//
//

import Foundation
import CoreData

public class Task: NSManagedObject {
    @NSManaged fileprivate(set) var id: Int64
    @NSManaged fileprivate(set) var name: String?
    @NSManaged fileprivate(set) var desc: String?
    @NSManaged fileprivate(set) var state: String?
    @NSManaged fileprivate(set) var profile: Profile?
    @NSManaged fileprivate(set) var worker: Worker?
    @NSManaged fileprivate(set) var events: Activity?
}
