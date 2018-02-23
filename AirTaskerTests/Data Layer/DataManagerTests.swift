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
        var mockManager: PersistenceControllerProtocol?
        var mockSessionManager: MockURLSession?
        var mockContext: ManagedContextProtocol?
        
        context("GIVEN a data manager") {
            
            beforeEach {
                mockContext = MockManagedContext()
                mockManager = MockPersistenceManager(managedContext: mockContext!)
                mockSessionManager = MockURLSession()
                sut = DataManager(storeManager: mockManager!, urlSession: mockSessionManager!)
            }
            describe("WHEN we initisalise the manager") {
                it("creates a concrete instance") {
                    expect(sut).toNot(beNil())
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
