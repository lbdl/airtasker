//
//  LocationPersistenceTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 31/01/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble

@testable import AirTasker

class LocationPersistenceTests: QuickSpec {
    override func spec() {
        var rawData: Data?
        var sut: LocationMapper?
        
        beforeSuite {
            rawData = TestSuiteHelpers.readLocalData(badData: false)
        }
        afterSuite {
            rawData = nil
        }
        afterEach {
            sut = nil
        }
        
        context("GIVEN a manager AND good JSON") {
            describe("Locations are persisted to storage") {
                
            }
        }
    }
    
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
