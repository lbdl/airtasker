//
//  LocationTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble

class LocationTests: QuickSpec {
    override func spec() {
        
        var rawData: Data?

        func readLocalData() -> Data? {
            let testBundle = Bundle(for: type(of: self))
            let url = testBundle.url(forResource: "locations", withExtension: "json")
            guard let data = NSData(contentsOf: url!) as Data? else {return nil}
            return data
        }
        
        beforeSuite {
            rawData = readLocalData()
        }
        
        context("GIVEN location JSON") {
            describe("WHEN we parse") {
                it("Creates an object") {
                    expect(rawData).notTo(beNil())
                }
            }
        }
        
        
    }
    public func testDummy() {}
}
