//
//  DataLayerTestHelpers.swift
//  AirTaskerTests
//
//  Created by Timothy Storey on 23/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

import CoreData

@testable import AirTasker

class MockManagedObject: NSManagedObject {
    static var entityName = "MockManagedObject"
}

class MockPersistenceManager: PersistenceController {
    var context: NSManagedObjectContext
    
    func updateContext(block: @escaping () -> ()) {
        //
    }
    
    func insertObject<A>() -> A where A : Managed {
        return MockManagedObject() as! A
    }
    
    init(managedContext: NSManagedObjectContext) {
        context = managedContext
    }
}
