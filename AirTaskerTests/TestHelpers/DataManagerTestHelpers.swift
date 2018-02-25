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

//class MockLocationParser: JSONMapper {
//    func persist(rawJson: Bool) {
//        //
//    }
//    
//    
//    typealias value = Bool
//    typealias raw = Data
//    
//    var mappedValue: value?
//    var didCallSet: Bool = false
//    var didCallMap: Bool = false
//    var didCallPersist: Bool = false
//    var didCallManager: Bool = false
//    
//    
//    func map(rawValue: Data) {
//        
//    }
//    
//    
//    var decoder: JSONDecoder
//    var manager: PersistenceControllerProtocol?
//    
//    required init(storeManager: PersistenceControllerProtocol) {
//        manager = storeManager
//        decoder = JSONDecoder()
//    }
//    
//    var rawValue: raw? {
//        didSet {
//            map(rawValue: rawValue!)
//        }
//    }
//}

//class MockLocalleParser: JSONMapper {
//    func persist(rawJson: Bool) {
//        //
//    }
//
//    typealias value = Bool
//    typealias raw = Data
//
//    var mappedValue: value?
//    var didCallSet: Bool = false
//    var didCallMap: Bool = false
//    var didCallPersist: Bool = false
//    var didCallManager: Bool = false
//
//    func map(rawValue: Data) {
//
//    }
//
//    var decoder: JSONDecoder
//    var manager: PersistenceControllerProtocol?
//
//    required init(storeManager: PersistenceControllerProtocol) {
//        manager = storeManager
//        decoder = JSONDecoder()
//    }
//
//    var rawValue: raw? {
//        didSet {
//            map(rawValue: rawValue!)
//        }
//    }
//}

