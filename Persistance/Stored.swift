//
//  Stored.swift
//  AirTasker
//
//  Created by Timothy Storey on 27/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation
import CoreData

protocol Stored: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}


extension Stored {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}


extension Stored where Self: NSManagedObject {
    static var entityName: String { return entity().name!  }
}
