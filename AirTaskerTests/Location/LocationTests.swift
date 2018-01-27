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
        }
        
        context("GIVEN location JSON") {
            beforeEach {
            }
            
            describe("WHEN we parse") {
                it("Creates an object") {
                    waitUntil { done in
                        PersistanceHelper.createInMemoryContainer(completion: { (container) in
                            sut = LocationMapper(storeManager: PersistenceManager(store: container))
                            sut?.map(rawValue: rawData!)
                            expect(sut!.mappedValue).toNot(beNil())
                            done()
                        })
                    }
                }
            }
        }
        
        
    }
    public func testDummy() {}
}
