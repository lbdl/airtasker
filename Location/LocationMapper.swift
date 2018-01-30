//
//  LocationMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

class LocationMapper: JSONMapper {
    typealias value = Mapped<[LocationRaw]>
    typealias raw = Data
    
    init(storeManager: PersistenceController) {
        persistanceManager = storeManager
        decoder = JSONDecoder()
    }
    
    let decoder: JSONDecoder
    
    var mappedValue: value?
    var persistanceManager: PersistenceController
    var rawValue: raw? {
        didSet {
            map(rawValue: rawValue!)
        }
    }
    
    func map(rawValue: Data) {
        do {
            let tmp = try decoder.decode([LocationRaw].self, from: rawValue)
            mappedValue = .Value(tmp)
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }
    
    func store(object: value) {
    }
}

struct LocationRaw: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "display_name"
        case lat = "latitude"
        case long = "longitude"
    }
    
    var id: Int64
    var lat: String
    var long: String
    var name: String
}
