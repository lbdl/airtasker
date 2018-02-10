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
    var rawValue: raw? {set get}
    var mappedValue: value? {get}
    var decoder: JSONDecoder {get set}
    
    // we could make this throw rather than
    // return a Mapped.MappingError(error)
    func map(rawValue: raw)
    
    init(storeManager: PersistenceController)
}




