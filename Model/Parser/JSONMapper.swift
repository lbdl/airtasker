//
//  DataMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

protocol JSONDecodingProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: JSONDecodingProtocol {
}

protocol JSONMapper: class {
    associatedtype value 
    associatedtype raw
    
    var mappedValue: value? {get}
    var decoder: JSONDecodingProtocol {get set}
    
    /// Takes a Data object and then uses a JSONDecoder to
    /// de-serialise the object to a JSON object
    /// - parameters:
    ///     - rawValue: a Data object that will be decoded
    func map(rawValue: raw)
    
    /// Persist the object to CoreData backing storage
    /// via a persistance controller. Intended to be used by a
    /// managing class rather than internally
    /// - parameters:
    ///     - rawJson: a decoded (from Data) JSON object of value type
    func persist(rawJson: value)
    
    /// Default initialiaser
    /// - parameters:
    ///     - storeManager: responsible for wrapping a coredata context and
    ///                    handling persistance
    init(storeManager: PersistenceControllerProtocol, decoder: JSONDecodingProtocol)
}





