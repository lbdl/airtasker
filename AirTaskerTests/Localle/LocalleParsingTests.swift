//
//  LocalleParsingTests.swift
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
private func beLocalle(test: @escaping (LocalleRaw) -> Void = { _ in }) -> Predicate<Mapped<LocalleRaw>> {
    return Predicate.define("be localle") { expression, message in
        if let actual = try expression.evaluate(),
            case let .Value(localle) = actual {
            test(localle)
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

class LocalleParsingTests: QuickSpec {
    
    var rawData: Data?
    var sut: LocalleMapper?
    var manager: PersistenceManager?
    var persistentContainer: NSPersistentContainer?
    
    override func spec() {

        beforeEach {
            self.rawData = TestSuiteHelpers.readLocalData(testCase: .localle)
        }
        
        afterSuite {
            self.rawData = nil
        }
        
        afterEach {
        }
        
        context("GIVEN good Localle json") {
            describe("WHEN we parse"){
                it("IT Creates a LocalleRaw object") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            self.persistentContainer = container
                            self.manager = PersistenceManager(store: self.persistentContainer!)
                            self.sut = LocalleMapper(storeManager: self.manager!)
                            self.sut?.map(rawValue: self.rawData!)
                            expect(self.sut?.mappedValue).to(beLocalle { localle in
                                expect(localle).to(beAKindOf(LocalleRaw.self))
                            })
                            done()
                        })
                    }
                }
//                it("IT creates a collection with 5 values") {
//                    waitUntil { done in
//                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
//                            self.persistentContainer = container
//                            self.manager = PersistenceManager(store: self.persistentContainer!)
//                            self.sut = ProfileMapper(storeManager: self.manager!)
//                            self.sut?.map(rawValue: self.rawData!)
//                            expect(self.sut?.mappedValue).to(beProfile { profiles in
//                                expect(profiles.count).to(equal(5))
//                            })
//                            done()
//                        })
//                    }
//                }
//                it("IT creates objects with correct properties") {
//                    waitUntil { done in
//                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
//                            self.persistentContainer = container
//                            self.manager = PersistenceManager(store: self.persistentContainer!)
//                            self.sut = ProfileMapper(storeManager: self.manager!)
//                            self.sut?.map(rawValue: self.rawData!)
//                            expect(self.sut?.mappedValue).to(beProfile { profiles in
//                                let actual = profiles.first
//                                expect(actual?.avatarURL).to(equal("/img/1.jpg"))
//                                expect(actual?.firstName).to(equal("Rachel"))
//                                expect(actual?.id).to(equal(1))
//                                expect(actual?.locationID).to(equal(5))
//                                expect(actual?.rating).to(equal(4))
//                            })
//                            done()
//                        })
//                    }
//                }
            }
        }
    }
}
