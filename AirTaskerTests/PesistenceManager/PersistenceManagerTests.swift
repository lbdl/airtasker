//
//  PersistenceManagerTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 31/01/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble

@testable import AirTasker

class PersistenceManagerTests: QuickSpec {
    
    
    override func spec() {
        context("GIVEN a persistence manager instance") {
            describe("WHEN we add objects") {
                var sut: PersistenceManager!
                it("creates them via the object") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            sut = PersistenceManager(store: container)
                            let testLoc = Location.insert(into: sut, raw: LocationRaw())
                            expect(testLoc).toNot(beNil())
                            done()
                        })
                    }
                }
                it("creates them via the manager") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            sut = PersistenceManager(store: container)
                            let testLoc = Location.insert(into: sut, raw: LocationRaw())
                            expect(testLoc).toNot(beNil())
                            done()
                        })
                    }
                }
            }
        }
    }
    
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
