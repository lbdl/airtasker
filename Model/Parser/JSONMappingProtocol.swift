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
protocol JSONMappingProtocol {
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
    //init(storeManager: PersistenceControllerProtocol, decoder: JSONDecodingProtocol)
}

//MARK: - Protocol type erasure code
// fixes the error "protocol ‘JSONMappingProtocol’ can only be used as a generic constraint because it has Self or associated type requirements"
private class _AnyMapperBase<MappedValue>: JSONMappingProtocol {
    
    // JSONMapper protocol properties.
    var mappedValue: MappedValue? {
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

    // Ensure that init() cannot be called and must be overridden in the implementer.
    init() {
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

private final class _AnyMapperBox<ConcreteMapper: JSONMappingProtocol>: _AnyMapperBase<ConcreteMapper.MappedValue> {
    // Store the concrete type
    var concrete: ConcreteMapper

    // Override all properties
    override var mappedValue: MappedValue? {
        get {
            return concrete.mappedValue
        }
    }
    
    override var decoder: JSONDecodingProtocol {
        get {
            return concrete.decoder
        }
        set {
            concrete.decoder = decoder
        }
    }

    // Define init()
    init(_ concrete: ConcreteMapper) {
        self.concrete = concrete
    }

    // Override all methods
    override func map(rawValue: Data) {
        concrete.map(rawValue: rawValue)
    }
    override func persist(rawJson: MappedValue) {
        concrete.persist(rawJson: rawJson)
    }
}





