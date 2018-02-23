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

class MockPersistenceManager: PersistenceControllerProtocol {
    let context: ManagedContextProtocol
    
    func updateContext(block: @escaping () -> ()) {
        print("MockPersistenceManager: called update context")
    }
    
    func insertObject<A>() -> A where A : Managed {
        return MockManagedObject() as! A
    }
    
    init(managedContext: ManagedContextProtocol) {
        context = managedContext
    }
}

