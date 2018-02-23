//
//  DataManagerTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 23/02/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import AirTasker

class DataManagerTests: QuickSpec {
    override func spec() {
        var sut: DataManager?
        var manager: PersistenceManager?
        var persistentContainer: NSPersistentContainer?
        
        context("GIVEN a data manager") {
            
            beforeEach {
//                TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
//                    persistentContainer = container
//                    manager = PersistenceManager(store: persistentContainer!)
//                    locationMapper = LocationMapper(storeManager: manager!)
//                    localleMapper = LocalleMapper(storeManager: manager!)
//                })
            }
            describe("WHEN we initisalise the manager") {
                it("creates a concrete instance") {
                }
            }
        }
        
    }
}
