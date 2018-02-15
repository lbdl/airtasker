//
//  DataMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

protocol JSONMapper {
    associatedtype value 
    associatedtype raw
    
    var persistanceManager: PersistenceController {get set}
    //var rawValue: raw? {set get}
    var mappedValue: value? {get}
    var decoder: JSONDecoder {get set}
    
    ///
    /// The actual mapping/parsing function responsible
    /// for initially parsing raw data to JSON and then
    /// persisting the data received.
    func map(rawValue: raw)
    
    func persist(rawJson: value)
    
    init(storeManager: PersistenceController)
}

//extension JSONMapper {
//    func map(rawValue: raw, rawJson: Any? = nil) {
//        map(rawValue: rawValue, rawJson: rawJson)
//    }
//}




