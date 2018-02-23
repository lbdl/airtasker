//
//  TestSuiteHelpers.swift
//  AirTaskerTests
//
//  Created by Timothy Storey on 26/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData
@testable import AirTasker

class MockManagedObject: NSManagedObject {
    static var entityName = "MockManagedObject"
}

class MockPersistenceManager: PersistenceControllerProtocol {
    let context: ManagedContextProtocol
    
    func updateContext(block: @escaping () -> ()) {
        print("MockPersistenceManager: called update context")
    }
    
    func insertObject<A>() -> A where A : Managed {
        return MockManagedObject() as! A
    }
    
    init(managedContext: ManagedContextProtocol) {
        context = managedContext
    }
}

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var data: Data?
    var error: Error?
    var response: URLResponse?
    
    private (set) var lastURL: URL?
    
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(data, response, error)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}


class TestSuiteHelpers: NSObject {
    
    enum TestType {
        case locations
        case profile
        case task
        case activity
        case localle
        case localle2
        case badLocation
        case badProfile
        case badTask
        case badActivity
        case badLocalle
    }
    
    static func readLocalData(testCase: TestType) -> Data? {
        let testBundle = Bundle(for: self)
        var url: URL?
        
        switch testCase {
        case .badLocation:
            url = testBundle.url(forResource: "badLocations", withExtension: "json")
        case .badProfile:
            url = testBundle.url(forResource: "badProfiles", withExtension: "json")
        case .locations:
            url = testBundle.url(forResource: "locations", withExtension: "json")
        case .profile:
            url = testBundle.url(forResource: "profiles", withExtension: "json")
        case .task:
            url = testBundle.url(forResource: "tasks", withExtension: "json")
        case .localle:
            url = testBundle.url(forResource: "localle3", withExtension: "json")
        case .localle2:
            url = testBundle.url(forResource: "localle5", withExtension: "json")
        case .badTask:
            url = testBundle.url(forResource: "badTasks", withExtension: "json")
        case .activity:
            url = testBundle.url(forResource: "activities", withExtension: "json")
        case .badActivity:
            url = testBundle.url(forResource: "badActivities", withExtension: "json")
        default:
            break
        }
        guard let data = NSData(contentsOf: url!) as Data? else {return nil}
        return data
    }
    
    // for testing without persisting data
    static func createInMemoryContainer (completion: @escaping(ManagedContextProtocol) -> ()) {
        let container = NSPersistentContainer(name: "AirTasks")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        description.configuration = "Default"
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            guard error == nil else {
                fatalError("Failed to load in memory store \(error!)")
            }
        }
        DispatchQueue.main.async {
            completion(container.viewContext)
        }
    }
}
