//
//  TaskParsingTests.swift
//  AirTaskerTests
//
//  Created by Timothy Storey on 14/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreData

@testable import AirTasker

//MARK: - Custom Matchers for associated values in Mapped<A> objects
private func beTask(test: @escaping ([TaskRaw]) -> Void = { _ in }) -> Predicate<Mapped<[TaskRaw]>> {
    return Predicate.define("be task") { expression, message in
        if let actual = try expression.evaluate(),
            case let .Value(tasks) = actual {
            test(tasks)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

private func beDecodingError(test: @escaping (Error) -> Void = { _ in }) -> Predicate<Mapped<[TaskRaw]>> {
    return Predicate.define("be decoding error") { expression, message in
        if let actual = try expression.evaluate(),
            case let .MappingError(Error) = actual {
            test(Error)
            return PredicateResult(status: .matches, message: message)
        }
        return PredicateResult(status: .fail, message: message)
    }
}

class TaskParsingTests: QuickSpec {
    
    var rawData: Data?
    var sut: TaskMapper?
    var manager: PersistenceControllerProtocol?
    var persistentContainer: NSManagedObjectContext?
    
    override func spec() {
        
        beforeEach {
            self.rawData = TestSuiteHelpers.readLocalData(testCase: .task)
        }
        afterSuite {
            self.rawData = nil
        }
        afterEach {
        }
        
        context("GIVEN good task JSON") {
            describe("WHEN we parse"){
                it("IT Creates a collection of Tasks") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            self.persistentContainer = container
                            self.manager = MockPersistenceManager(managedContext: self.persistentContainer!)
                            self.sut = TaskMapper(storeManager: self.manager!)
                            self.sut?.map(rawValue: self.rawData!)
                            expect(self.sut?.mappedValue).to(beTask { tasks in
                                expect(tasks).to(beAKindOf(Array<TaskRaw>.self))
                            })
                            done()
                        })
                    }
                }
                it("IT creates a collection with 5 values") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            self.persistentContainer = container
                            self.manager = MockPersistenceManager(managedContext: self.persistentContainer!)
                            self.sut = TaskMapper(storeManager: self.manager!)
                            self.sut?.map(rawValue: self.rawData!)
                            expect(self.sut?.mappedValue).to(beTask { tasks in
                                expect(tasks.count).to(equal(2))
                            })
                            done()
                        })
                    }
                }
                it("IT creates objects with correct properties") {
                    waitUntil { done in
                        TestSuiteHelpers.createInMemoryContainer(completion: { (container) in
                            self.persistentContainer = container
                            self.manager = MockPersistenceManager(managedContext: self.persistentContainer!)
                            self.sut = TaskMapper(storeManager: self.manager!)
                            self.sut?.map(rawValue: self.rawData!)
                            expect(self.sut?.mappedValue).to(beTask { tasks in
                                let actual = tasks.first
                                expect(actual?.desc).to(equal("1. Visit a shop anonymously as an \"undercover customer.\" \n2. Make two short enquiries in the same shop. \n3. Fill in a questionnaire. \n4. Report by phone."))
                                expect(actual?.name).to(equal("Mystery Shopper Rockdale NSW"))
                                expect(actual?.id).to(equal(4))
                                expect(actual?.profileID).to(equal(5))
                                expect(actual?.workerID).to(beNil())
                            })
                            done()
                        })
                    }
                }
            }
        }
        
        context("GIVEN bad task JSON") {
            beforeEach {
                self.rawData = TestSuiteHelpers.readLocalData(testCase: .badTask)
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
                            self.manager = MockPersistenceManager(managedContext: self.persistentContainer!)
                            self.sut = TaskMapper(storeManager: self.manager!)
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
