//
//  LocationParsingTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import AirTasker


class LocationParsingTests: QuickSpec {
    
    
    //MARK: - Custom Matchers for associated values
    private func beDecodingError(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Mapped<[LocationRaw]>> {
        return Predicate.define("be decoding error") { expression, message in
            if let actual = try expression.evaluate(),
                case let .MappingError(Error) = actual {
                test(Error)
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
    
    private func beLocation(test: @escaping ([LocationRaw]) -> Void = { _ in }) -> Predicate<Mapped<[LocationRaw]>> {
        return Predicate.define("be location") { expression, message in
            if let actual = try expression.evaluate(),
                case let .Value(locations) = actual {
                test(locations)
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
    
    //MARK: - Specs
    override func spec() {
        
        var rawData: Data?
        var sut: LocationMapper?
        var manager: PersistenceControllerProtocol?
        var persistentContainer: ManagedContextProtocol?
    
        beforeSuite {
            rawData = TestSuiteHelpers.readLocalData(testCase: .locations)
        }
        afterSuite {
            rawData = nil
        }
        afterEach {
        }
        
        context("GIVEN location JSON") {
            
            describe("WHEN we parse") {
                it("Creates a collection of Locations") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = MockPersistenceManager(managedContext: persistentContainer!)
                            sut = LocationMapper(storeManager: manager!)
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).to(self.beLocation { locations in
                                expect(locations).to(beAKindOf(Array<LocationRaw>.self))
                            })
                            done()
                        })
                    }
                }
                it("Value has 5 items") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = MockPersistenceManager(managedContext: persistentContainer!)
                            sut = LocationMapper(storeManager: manager!)
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).to(self.beLocation { locations in
                                expect(locations.count).to(equal(5))
                            })
                            done()
                        })
                    }
                }
                it("Object has expected lat and long strings") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = MockPersistenceManager(managedContext: persistentContainer!)
                            sut = LocationMapper(storeManager: manager!)
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).to(self.beLocation { locations in
                                expect(locations[0].lat).to(equal(-33.95082))
                                expect(locations[0].long).to(equal(151.1388))
                            })
                            done()
                        })
                    }
                }
                it("Object has expected name") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = MockPersistenceManager(managedContext: persistentContainer!)
                            sut = LocationMapper(storeManager: manager!)
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).to(self.beLocation { locations in
                                expect(locations[0].name).to(equal("Rockdale NSW 2216, Australia"))
                            })
                            done()
                        })
                    }
                }
                it("Object has expected id") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = MockPersistenceManager(managedContext: persistentContainer!)
                            sut = LocationMapper(storeManager: manager!)
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).to(self.beLocation { locations in
                                expect(locations[0].id).to(equal(5))
                            })
                            done()
                        })
                    }
                }
            }
        }
        
        context("GIVEN bad location JSON") {
            
            var badData: Data?
            
            beforeEach {
                badData = TestSuiteHelpers.readLocalData(testCase: .badLocation)
            }
            
            afterEach {
            }
            
            describe("WHEN we parse") {
                it("Returns an error") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = MockPersistenceManager(managedContext: persistentContainer!)
                            sut = LocationMapper(storeManager: manager!)
                            sut?.map(rawValue: badData!)
                            expect(sut?.mappedValue).to(self.beDecodingError())
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
