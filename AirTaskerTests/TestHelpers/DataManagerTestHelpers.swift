//
//  DataManagerTestHelpers.swift
//  AirTaskerTests
//
//  Created by Timothy Storey on 24/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

@testable import AirTasker

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var testData: Data?
    var testError: Error?
    var testResponse: URLResponse?
    private (set) var lastURL: URL?
    
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        testResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        completionHandler(testData, testResponse, testError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}

class MockLocationsParser: JSONMappingProtocol {
    var persistanceManager: PersistenceControllerProtocol
    typealias MappedValue = Mapped<[LocationRaw]>
    var decoder: JSONDecodingProtocol
    var data: Data?
    var mappedValue: MappedValue?
    var receivedData: Data?
    var didCallMap: Bool?
    var didCallPersist: Bool?
    
    func parse(rawValue: Data) {
        receivedData = rawValue
        didCallMap = true
        let tmp = try! decoder.decode([LocationRaw].self, from: rawValue)
        mappedValue = .Value([LocationRaw(), LocationRaw()])
    }
    
    func persist(rawJson: Mapped<[LocationRaw]>) {
        didCallPersist = true
    }
    
    init() {
        decoder = MockLocationJSONDecoder()
        persistanceManager = MockPersistenceManager(managedContext: MockManagedContext())
    }
}

class MockLocalleParser: JSONMappingProtocol {
    var persistanceManager: PersistenceControllerProtocol
    typealias MappedValue = Mapped<LocalleRaw>
    var decoder: JSONDecodingProtocol
    var data: Data?
    var mappedValue: MappedValue?
    var receivedData: Data?
    
    func parse(rawValue: Data) {
        receivedData = rawValue
    }
    
    func persist(rawJson: Mapped<LocalleRaw>) {
    }
    
    init() {
        decoder = MockLocalleJSONDecoder()
        persistanceManager = MockPersistenceManager(managedContext: MockManagedContext())
    }
}

class MockLocationJSONDecoder: JSONDecodingProtocol {
    
    var didCallDecode: Bool?
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        didCallDecode = true
        let tmp = [LocationRaw(), LocationRaw()]
        return tmp as! T
    }
}

class MockLocalleJSONDecoder: JSONDecodingProtocol {
    
    var didCallDecode: Bool?
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        didCallDecode = true
        return "Localle" as! T
    }
}




