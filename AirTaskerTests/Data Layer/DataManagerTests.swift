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
        var mockSession: MockURLSession?
        var mockContext: ManagedContextProtocol?
        var mockTask: MockURLSessionDataTask?
        
        context("GIVEN a data manager") {
            
            beforeEach {
                mockContext = MockManagedContext()
                mockManager = MockPersistenceManager(managedContext: mockContext!)
                mockSession = MockURLSession()
                mockTask = MockURLSessionDataTask()
                sut = DataManager(storeManager: mockManager!, urlSession: mockSession!)
            }
            describe("WHEN we initisalise the manager") {
                it("creates a concrete instance") {
                    expect(sut).toNot(beNil())
                }
            }
            describe("WHEN we fetch location objects") {
                it("calls the corect endpoint") {
                    sut?.fetchLocations()
                    let actual = mockSession?.lastURL
                    expect(actual?.scheme).to(equal("https"))
                    expect(actual?.host).to(equal("s3-ap-southeast-2.amazonaws.com/ios-code-test/v2"))
                    expect(actual?.path).to(equal("/locations.json"))
                    expect(actual?.lastPathComponent).to(equal("locations.json"))
                }
                
            }
            describe("WHEN we call get location objects") {
                it("calls resume() on its data task") {
                    mockSession?.nextDataTask = mockTask!
                    sut?.fetchLocations()
                    expect(mockTask?.resumeWasCalled).to(beTrue())
                }
            }
            describe("WHEN we fetch a location object successfully") {
                it("has the expeted data") {
                    let expected = "{\"foo\": \"bar\"}".data(using: .utf8)
                    mockSession?.testData = expected
                    sut?.fetchLocations()
                    
                }
            }
        }
        
    }
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
