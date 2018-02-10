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

private func beProfile(test: @escaping ([ProfileRaw]) -> Void = { _ in }) -> Predicate<Mapped<[ProfileRaw]>> {
    return Predicate.define("be profile") { expression, message in
        if let actual = try expression.evaluate(),
            case let .Value(locations) = actual {
            test(locations)
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
    
    func  flushDB() {
        let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
        let objs = try! persistentContainer!.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            persistentContainer!.viewContext.delete(obj)
        }
        try! persistentContainer!.viewContext.save()
    }
    
    override func spec() {
        
        beforeSuite {
            self.rawData = TestSuiteHelpers.readLocalData(testCase: .profile)
        }
        afterSuite {
            self.rawData = nil
        }
        afterEach {
            self.flushDB()
        }
        
        context("GIVEN good profile JSON") {
            describe("WHEN we parse"){
                it("Creates a collection of Profiles") {
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
            }
        }
    }
    // work around so that xcode9.2 actually see's the tests
    // thanks apple for allowing us to test things
    public func testDummy() {}
}
