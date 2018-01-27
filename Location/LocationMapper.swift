//
//  LocationMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

class LocationMapper: JSONMapper {
    
    init(storeManager: PersistenceController) {
        persistanceManager = storeManager
    }
    
    typealias value = Mapped<LocationRaw>
    typealias raw = Data
    
    var rawValue: raw?
    var mappedValue: value?
    var persistanceManager: PersistenceController
    
    func map(rawValue: Data) {
        mappedValue = .Value(LocationRaw(id: 1, lat: "foo", long: "bar", name: "snafu"))
    }
    
    func store(object: value) {
    }
}

struct LocationRaw: Decodable {
    var id: Int64
    var lat: String
    var long: String
    var name: String
}
