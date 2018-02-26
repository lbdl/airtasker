//
//  DataMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

// MARK: JSONDecoding
protocol JSONDecodingProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: JSONDecodingProtocol {
}

// MARK: JSON parsing
protocol JSONMapper: class {
    associatedtype MappedValue 
    
    var mappedValue: MappedValue? {get}
    var decoder: JSONDecodingProtocol {get set}
    
    /// Takes a Data object and then uses a JSONDecoder to
    /// de-serialise the object to a JSON object
    /// - parameters:
    ///     - rawValue: a Data object that will be decoded
    func map(rawValue: Data)
    
    /// Persist the object to CoreData backing storage
    /// via a persistance controller. Intended to be used by a
    /// managing class rather than internally
    /// - parameters:
    ///     - rawJson: a decoded (from Data) JSON object of value type
    func persist(rawJson: MappedValue)
    
    /// Default initialiaser
    /// - parameters:
    ///     - storeManager: responsible for wrapping a coredata context and
    ///                    handling persistance
    init(storeManager: PersistenceControllerProtocol, decoder: JSONDecodingProtocol)
}

//MARK: - Protocol type erasure code
// "protocol ‘JSONMapper’ can only be used as a generic constraint because it has Self or associated type requirements"
private class _AnyMapperBase<Value>: JSONMapper {
    
    // JSONMapper protocol properties.
    var mappedValue: Value? {
        get {
            fatalError("Must override")
        }
    }

    var decoder: JSONDecodingProtocol {
        get {
            fatalError("Must override")
        }
        set {
            fatalError("Must override")
        }
    }

    // Ensure that init() must be overriden.
    required init(storeManager: PersistenceControllerProtocol, decoder: JSONDecodingProtocol) {
        guard type(of: self) != _AnyMapperBase.self else {
            fatalError("Cannot initialise, must subclass")
        }
    }

    // JSONMapper protocol methods
    func map(rawValue: Data) {
        fatalError("Must override")
    }
    
    func persist(rawJson: MappedValue) {
        fatalError("Must override")
    }
    
}





