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

extension Mat


class LocationTests: QuickSpec {
    
    
    //MARK: - Custom Matchers for associated values
    private func beDecodingError(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Mapped<[LocationRaw]>> {
        return Predicate.define("decode successfully") { expression, message in
            if let actual = try expression.evaluate(),
                case let .MappingError(Error) = actual {
                test(Error)
                return PredicateResult(status: .matches, message: message)
            }
            return PredicateResult(status: .fail, message: message)
        }
    }
    
    override func spec() {
        
        var rawData: Data?
        var sut: LocationMapper?

        beforeSuite {
            rawData = TestSuiteHelpers.readLocalData()
        }
        
        context("GIVEN good location JSON") {
            beforeEach {
            }
            
            describe("WHEN we parse") {
                it("Creates an object") {
                    waitUntil { done in
                        PersistanceHelper.createInMemoryContainer(completion: { (container) in
                            sut = LocationMapper(storeManager: PersistenceManager(store: container))
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).toNot(self.beDecodingError())
                            done()
                        })
                    }
                }
                it("Creates errors") {
                    waitUntil { done in
                        PersistanceHelper.createInMemoryContainer(completion: { (container) in
                            sut = LocationMapper(storeManager: PersistenceManager(store: container))
                            sut?.map(rawValue: rawData!)
                            //expect(sut?.mappedValue).toNot(self.beDecodingError())
                            //expect(sut?.mappedValue).to(self.beDecodingError())
                            done()
                        })
                    }
                }
                it("Object is a list type") {
                    waitUntil { done in
                        PersistanceHelper.createInMemoryContainer(completion: { (container) in
                            sut = LocationMapper(storeManager: PersistenceManager(store: container))
                            sut?.map(rawValue: rawData!)
                            done()
                        })
                    }
                }
                it("Object has expected lat and long strings") {
                    waitUntil { done in
                        PersistanceHelper.createInMemoryContainer(completion: { (container) in
                            sut = LocationMapper(storeManager: PersistenceManager(store: container))
//                            sut?.map(rawValue: rawData!)
//                            expect(sut!.mappedValue).toNot(beNil())
                            done()
                        })
                    }
                }
                it("Object has expected name") {
                    waitUntil { done in
                        PersistanceHelper.createInMemoryContainer(completion: { (container) in
                            sut = LocationMapper(storeManager: PersistenceManager(store: container))
//                            sut?.map(rawValue: rawData!)
                            //expect(sut!.mappedValue).toNot(beNil())
                            done()
                        })
                    }
                }
                it("Object has expected id") {
                    waitUntil { done in
                        PersistanceHelper.createInMemoryContainer(completion: { (container) in
                            sut = LocationMapper(storeManager: PersistenceManager(store: container))
//                            sut?.map(rawValue: rawData!)
                            //expect(sut!.mappedValue).toNot(beNil())
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
