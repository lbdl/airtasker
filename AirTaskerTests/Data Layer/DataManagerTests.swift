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
        var manager: PersistenceControllerProtocol?
        
        context("GIVEN a data manager") {
            
            beforeEach {

            }
            describe("WHEN we initisalise the manager") {
                it("creates a concrete instance") {
                }
            }
            describe("WHEN we fetch location objects") {
                
            }
            describe("WHEN we fetch localle objects") {
                
            }
            describe("WHEN we fetch avatar objects") {
                
            }
        }
        
    }
}
