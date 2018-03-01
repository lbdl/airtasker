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

let locationsRaw = [
    LocationRaw(),
    LocationRaw()
]

let locallesRaw = LocalleRaw()

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
        
        var testLocationJsonData: Data?
        var testLocalleData: Data?
        var testAvatarData: Data?
        
        context("GIVEN a data manager") {
            
            beforeEach {
                testLocationJsonData = """
                                            [
                                            {
                                            "id": 1,
                                            "display_name": "Foo",
                                            "latitude": 10.5,
                                            "longitude": 10.6
                                            },
                                            {
                                            "id": 2,
                                            "display_name": "Bar",
                                            "latitude": 10.7,
                                            "longitude": 10.8
                                            }
                                            ]
                                            """.data(using: .utf8)
                
                testLocalleData = """
                                    {
                                    "name": "TestLocalle",
                                    "id": 0,
                                    "foo": "bar",
                                    "situation": "snafu"
                                    }
                                    """.data(using: .utf8)
                
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
            afterEach {
                mockTask = nil
                mockSession = nil
                mockLocalleParser = nil
                mockLocationParser = nil
                mockManager = nil
                mockLocationMapper = nil
                mockLocalleMapper = nil
            }
            
            describe("WHEN we fetch location objects") {
                it("call the correct endpoint") {
                    mockSession?.testData = testLocationJsonData
                    sut?.fetchLocations()
                    let actual = mockSession?.lastURL
                    expect(actual?.scheme).to(equal("https"))
                    expect(actual?.host).to(equal("s3-ap-southeast-2.amazonaws.com"))
                    expect(actual?.path).to(equal("/ios-code-test/v2/locations.json"))
                    expect(actual?.lastPathComponent).to(equal("locations.json"))
                }
                it("call resume() on its data task") {
                    mockSession?.testData = testLocationJsonData
                    mockSession?.nextDataTask = mockTask!
                    sut?.fetchLocations()
                    expect(mockTask?.resumeWasCalled).to(beTrue())
                }
                
                describe("AND the call succeeds") {
                    it("call its location parser's parse method") {
                        waitUntil { done in
                            mockSession?.testData = testLocationJsonData
                            sut?.fetchLocations()
                            expect(mockLocationParser?.receivedData).to(equal(testLocationJsonData))
                            expect(mockLocationParser?.didCallMap).to(beTrue())
                            done()
                        }
                    }
                    it("call its location parsers decoders decode method") {
                        waitUntil { done in
                            mockSession?.testData = testLocationJsonData
                            sut?.fetchLocations()
                            let decoder = mockLocationParser?.decoder as! MockLocationJSONDecoder
                            expect(decoder.didCallDecode).to(beTrue())
                            done()
                        }
                    }
                    it("call its location parsers persist method") {
                        waitUntil { done in
                            mockSession?.testData = testLocationJsonData
                            sut?.fetchLocations()
                            expect(mockLocationParser?.didCallPersist).to(beTrue())
                            done()
                        }
                    }
                }
            }
            describe("WHEN we fetch localle 2") {
                it("uses the correct endpoint") {
                    mockSession?.testData = testLocalleData
                    sut?.fetchLocationData(for: 2)
                    let actual = mockSession?.lastURL
                    expect(actual?.scheme).to(equal("https"))
                    expect(actual?.host).to(equal("s3-ap-southeast-2.amazonaws.com"))
                    expect(actual?.path).to(equal("/ios-code-test/v2/location/2.json"))
                    expect(actual?.lastPathComponent).to(equal("2.json"))
                }
                it("calls resume on the data task") {
                    mockSession?.testData = testLocalleData
                    mockSession?.nextDataTask = mockTask!
                    sut?.fetchLocationData(for: 2)
                    expect(mockTask?.resumeWasCalled).to(beTrue())
                }
                describe("AND the call succeeds") {
                    it("calls its parsers parse method") {
                        waitUntil { done in
                            mockSession?.testData = testLocalleData
                            sut?.fetchLocationData(for: 2)
                            expect(mockLocalleParser?.receivedData).to(equal(testLocalleData))
                            expect(mockLocalleParser?.didCallMap).to(beTrue())
                            done()
                        }
                    }
                    it("call its location parsers decoders decode method") {
                        waitUntil { done in
                            mockSession?.testData = testLocalleData
                            sut?.fetchLocationData(for: 2)
                            let decoder = mockLocalleParser?.decoder as! MockLocalleJSONDecoder
                            expect(decoder.didCallDecode).to(beTrue())
                            done()
                        }
                    }
                    it("call its location parsers persist method") {
                        waitUntil { done in
                            mockSession?.testData = testLocalleData
                            sut?.fetchLocationData(for: 2)
                            expect(mockLocalleParser?.didCallPersist).to(beTrue())
                            done()
                        }
                    }
                }
            }
            
            describe("WHEN we fetch avatar 3") {
                it("uses the correct endpoint") {
                    mockSession?.testData = TestSuiteHelpers.readLocalData(testCase: .avatar)
                    _ = sut?.fetchAvatarData(for: 3)
                    let actual = mockSession?.lastURL
                    expect(actual?.scheme).to(equal("https"))
                    expect(actual?.host).to(equal("s3-ap-southeast-2.amazonaws.com"))
                    expect(actual?.path).to(equal("/ios-code-test/v2/img/3.json"))
                    expect(actual?.lastPathComponent).to(equal("3.json"))
                    
                }
                it("calls resume on the data task") {
                    mockSession?.testData = TestSuiteHelpers.readLocalData(testCase: .avatar)
                    mockSession?.nextDataTask = mockTask!
                    _ = sut?.fetchAvatarData(for: 3)
                    expect(mockTask?.resumeWasCalled).to(beTrue())
                    
                }
                describe("AND the call succeeds") {
                    it("returns an image") {
                        waitUntil { done in
                            mockSession?.testData = TestSuiteHelpers.readLocalData(testCase: .avatar)
                            let actual = sut?.fetchAvatarData(for: 3)
                            expect(actual).toNot(beNil())
                            done()
                        }
                    }
                }
            }
            
            
        }
        
    }
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
