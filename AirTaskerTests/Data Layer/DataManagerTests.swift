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

struct Foo: Decodable {
    let foo: String
}

class DataManagerTests: QuickSpec {
    override func spec() {
        var sut: DataManager?
        var mockManager: PersistenceControllerProtocol?
        var mockSession: MockURLSession?
        var mockContext: ManagedContextProtocol?
        var mockTask: MockURLSessionDataTask?
        var mockLocationParser: MockLocationsParser?
        var mockLocalleParser: MockLocalleParser?
        var mockLocationMapper: AnyMapper<Mapped<[LocationRaw]>>?
        var mockLocalleMapper: AnyMapper<Mapped<LocalleRaw>>?
        
        context("GIVEN a data manager") {
            
            beforeEach {
                mockContext = MockManagedContext()
                mockManager = MockPersistenceManager(managedContext: mockContext!)
                mockSession = MockURLSession()
                mockTask = MockURLSessionDataTask()
                mockLocationParser = MockLocationsParser()
                mockLocalleParser = MockLocalleParser()
                mockLocationMapper = AnyMapper(mockLocationParser!)
                mockLocalleMapper = AnyMapper(mockLocalleParser!)
                sut = DataManager(storeManager: mockManager!, urlSession: mockSession!, locationParser: mockLocationMapper!, localleParser: mockLocalleMapper!)
            }
            describe("WHEN we initisalise the manager") {
                it("creates a concrete instance") {
                    expect(sut).toNot(beNil())
                }
            }
            describe("WHEN we fetch location objects") {
                it("calls the corect endpoint") {
                    let expected = "{\"foo\": \"bar\"}".data(using: .utf8)
                    mockSession?.testData = expected
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
                    let expected = "{\"foo\": \"bar\"}".data(using: .utf8)
                    mockSession?.testData = expected
                    mockSession?.nextDataTask = mockTask!
                    sut?.fetchLocations()
                    expect(mockTask?.resumeWasCalled).to(beTrue())
                }
            }
            
            describe("WHEN we fetch a location object successfully") {
                it("calls its location parser's map method") {
                    waitUntil { done in
                        let expected = "{\"foo\": \"bar\"}".data(using: .utf8)
                        mockSession?.testData = expected
                        sut?.fetchLocations()
                        expect(mockLocationParser?.receivedData).to(equal(expected))
                        expect(mockLocationParser?.didCallMap).to(beTrue())
                        done()
                    }
                }
                it("calls its location parsers decoders decode method") {
                    waitUntil { done in
                        let expected = "{\"foo\": \"bar\"}".data(using: .utf8)
                        mockSession?.testData = expected
                        sut?.fetchLocations()
                        let decoder = mockLocationParser?.decoder as! MockLocationJSONDecoder
                        expect(decoder.didCallDecode).to(beTrue())
                        done()
                    }
                }
                it("calls its location parsers decoders decode and sets the parsers MappedValue to <[LocationRaw]>") {
                    waitUntil { done in
//                        let expected = "{\"foo\": \"bar\"}".data(using: .utf8)
//                        mockSession?.testData = expected
//                        sut?.fetchLocations()
//                        let decoder = mockLocationParser?.decoder as! MockLocationJSONDecoder
//                        expect(decoder.didCallDecode).to(beTrue())
                        done()
                    }
                }
            }
        }
        
    }
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
