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
    
    override func spec() {
        
        var rawData: Data?
        var sut: LocalleMapper?
        var manager: PersistenceManager?
        var persistentContainer: NSPersistentContainer?

        beforeEach {
            rawData = TestSuiteHelpers.readLocalData(testCase: .localle)
            TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                persistentContainer = container
                manager = PersistenceManager(store: persistentContainer!)
                sut = LocalleMapper(storeManager: manager!)
            })
        }
        
        afterSuite {
            rawData = nil
        }
        
        afterEach {
        }
        
        context("GIVEN good Localle json") {
            describe("WHEN we parse"){
                it("IT Creates a LocalleRaw object") {
                    waitUntil { done in
                        
                        sut?.map(rawValue: rawData!)
                        expect(sut?.mappedValue).to(beLocalle { localle in
                            expect(localle).to(beAKindOf(LocalleRaw.self))
                        })
                        done()
                    }
                }
                it("IT has the expected attributes") {
                    waitUntil { done in
                        sut?.map(rawValue: rawData!)
                        expect(sut?.mappedValue).to(beLocalle { localle in
                            expect(localle.id).to(equal(3))
                        })
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
