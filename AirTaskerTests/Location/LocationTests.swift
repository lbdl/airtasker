//
//  LocationTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble

@testable import AirTasker

class LocationTests: QuickSpec {
    override func spec() {
        
        var rawData: Data?
        var sut: LocationMapper?

        beforeSuite {
            rawData = TestSuiteHelpers.readLocalData()
            sut = LocationMapper(storeManager: TestSuiteHelpers.buildMockPersistenceController())
        }
        
        context("GIVEN location JSON") {
            beforeEach {
            }
            
            describe("WHEN we parse") {
                
                var locationObject: LocationRaw?
                
                it("Creates an object") {
                    expect(rawData).notTo(beNil())
                }
            }
        }
        
        
    }
    public func testDummy() {}
}
