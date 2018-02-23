//
//  ActivityParsingTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 16/02/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import AirTasker

//MARK: - Custom Matchers for associated values in Mapped<A> objects
private func beActivity(test: @escaping ([ActivityRaw]) -> Void = { _ in }) -> Predicate<Mapped<[ActivityRaw]>> {
    return Predicate.define("be activity") { expression, message in
        if let actual = try expression.evaluate(),
            case let .Value(activities) = actual {
            test(activities)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

private func beDecodingError(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Mapped<[ActivityRaw]>> {
    return Predicate.define("be decoding error") { expression, message in
        if let actual = try expression.evaluate(),
            case let .MappingError(Error) = actual {
            test(Error)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}
class ActivityParsingTests: QuickSpec {
    override func spec() {
        
        var rawData: Data?
        var sut: ActivityMapper?
        var manager: PersistenceManager?
        var persistentContainer: ManagedContextProtocol?
        
        beforeEach {
            rawData = TestSuiteHelpers.readLocalData(testCase: .activity)
        }
        afterSuite {
            rawData = nil
        }
        
        afterEach {
        }
        
        context("GIVEN good profile JSON") {
            describe("WHEN we parse"){
                it("IT Creates a collection of Profiles") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = PersistenceManager(store: persistentContainer!)
                            sut = ActivityMapper(storeManager: manager!)
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).to(beActivity { activities in
                                expect(activities).to(beAKindOf(Array<ActivityRaw>.self))
                            })
                            done()
                        })
                    }
                }
                it("IT creates a collection with 3 values") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = PersistenceManager(store: persistentContainer!)
                            sut = ActivityMapper(storeManager: manager!)
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).to(beActivity { activities in
                                expect(activities.count).to(equal(3))
                            })
                            done()
                        })
                    }
                }
                it("IT creates objects with correct properties") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = PersistenceManager(store: persistentContainer!)
                            sut = ActivityMapper(storeManager: manager!)
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).to(beActivity { activities in
                                let actual = activities.first
                                expect(actual?.profileID).to(equal(1))
                                expect(actual?.id).to(equal(5))
                                expect(actual?.internalMessage).to(equal("{profileName} asked a question about {taskName}"))
                                expect(actual?.createdAt).to(equal(""))
                                expect(actual?.event).to(equal("comment"))
                            })
                            done()
                        })
                    }
                }
            }
        }
        
        context("GIVEN bad activity JSON") {
            beforeEach {
                rawData = TestSuiteHelpers.readLocalData(testCase: .badActivity)
            }
            afterSuite {
                rawData = nil
            }
            afterEach {
            }
            
            describe("WHEN we parse") {
                it("Returns an error") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            persistentContainer = container
                            manager = PersistenceManager(store: persistentContainer!)
                            sut = ActivityMapper(storeManager: manager!)
                            sut?.map(rawValue: rawData!)
                            expect(sut?.mappedValue).to(beDecodingError())
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

