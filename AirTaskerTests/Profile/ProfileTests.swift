//
//  ProfileTests.swift
//  AirTasker
//
//  Created by Timothy Storey on 09/02/2018.
//Copyright © 2018 BITE-Software. All rights reserved.
//

import Quick
import Nimble
import CoreData

@testable import AirTasker

//MARK: - Custom Matchers for associated values in Mapped<A> objects
private func beProfile(test: @escaping ([ProfileRaw]) -> Void = { _ in }) -> Predicate<Mapped<[ProfileRaw]>> {
    return Predicate.define("be profile") { expression, message in
        if let actual = try expression.evaluate(),
            case let .Value(profiles) = actual {
            test(profiles)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

private func beDecodingError(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Mapped<[ProfileRaw]>> {
    return Predicate.define("be decoding error") { expression, message in
        if let actual = try expression.evaluate(),
            case let .MappingError(Error) = actual {
            test(Error)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

class ProfileTests: QuickSpec {
    
    var rawData: Data?
    var sut: ProfileMapper?
    var manager: PersistenceManager?
    var persistentContainer: NSPersistentContainer?
    
    override func spec() {
        
        beforeEach {
            self.rawData = TestSuiteHelpers.readLocalData(testCase: .profile)
        }
        afterSuite {
            self.rawData = nil
        }
        afterEach {
        }
        
        context("GIVEN good profile JSON") {
            describe("WHEN we parse"){
                it("IT Creates a collection of Profiles") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            self.persistentContainer = container
                            self.manager = PersistenceManager(store: self.persistentContainer!)
                            self.sut = ProfileMapper(storeManager: self.manager!)
                            self.sut?.map(rawValue: self.rawData!)
                            expect(self.sut?.mappedValue).to(beProfile { profiles in
                                expect(profiles).to(beAKindOf(Array<ProfileRaw>.self))
                            })
                            done()
                        })
                    }
                }
                it("IT creates a collection with 5 values") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            self.persistentContainer = container
                            self.manager = PersistenceManager(store: self.persistentContainer!)
                            self.sut = ProfileMapper(storeManager: self.manager!)
                            self.sut?.map(rawValue: self.rawData!)
                            expect(self.sut?.mappedValue).to(beProfile { profiles in
                                expect(profiles.count).to(equal(5))
                            })
                            done()
                        })
                    }
                }
                it("IT creates objects with correct properties") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            self.persistentContainer = container
                            self.manager = PersistenceManager(store: self.persistentContainer!)
                            self.sut = ProfileMapper(storeManager: self.manager!)
                            self.sut?.map(rawValue: self.rawData!)
                            expect(self.sut?.mappedValue).to(beProfile { profiles in
                                let actual = profiles.first
                                expect(actual?.avatarURL).to(equal("/img/1.jpg"))
                                expect(actual?.firstName).to(equal("Rachel"))
                                expect(actual?.id).to(equal(1))
                                expect(actual?.locationID).to(equal(5))
                                expect(actual?.rating).to(equal(4))
                            })
                            done()
                        })
                    }
                }
            }
        }
        
        context("GIVEN bad profile JSON") {
            beforeEach {
                self.rawData = TestSuiteHelpers.readLocalData(testCase: .badProfile)
            }
            afterSuite {
                self.rawData = nil
            }
            afterEach {
            }
            
            describe("WHEN we parse") {
                it("Returns an error") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            self.persistentContainer = container
                            self.manager = PersistenceManager(store: self.persistentContainer!)
                            self.sut = ProfileMapper(storeManager: self.manager!)
                            self.sut?.map(rawValue: self.rawData!)
                            expect(self.sut?.mappedValue).to(beDecodingError())
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
