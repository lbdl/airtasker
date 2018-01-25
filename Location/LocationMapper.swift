//
//  LocationMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

struct LocationMapper: JSONMapper {
    
    typealias value = Mapped<LocationRaw>
    typealias raw = Data
    
    var rawValue: raw
    var mappedValue: value
    
    func map(rawValue: Data) -> Mapped<LocationRaw> {
        return mappedValue
    }
}

struct LocationRaw: Decodable {
    var id: Int64
    var lat: String
    var long: String
    var name: String
}
