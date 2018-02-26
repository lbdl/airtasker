//
//  LocationMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

class LocationMapper: JSONMapper {
    
    internal var decoder: JSONDecodingProtocol
    internal var mappedValue: MappedValue?
    internal var persistanceManager: PersistenceControllerProtocol
    
    typealias MappedValue = Mapped<[LocationRaw]>
    typealias raw = Data
    
    required init(storeManager: PersistenceControllerProtocol, decoder: JSONDecodingProtocol=JSONDecoder()) {
        persistanceManager = storeManager
        self.decoder = decoder
    }
    
    
    var rawValue: raw? {
        didSet {
            map(rawValue: rawValue!)
        }
    }
    
    internal func map(rawValue: Data) {
        do {
            let tmp = try decoder.decode([LocationRaw].self, from: rawValue)
            mappedValue = .Value(tmp)
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }
    
    internal func persist(rawJson: MappedValue) {
        if let obj = rawJson.associatedValue() as? [LocationRaw] {
            persistanceManager.updateContext(block: {
                _ = obj.map({ [weak self] location in
                    guard let strongSelf = self else { return }
                    _ = Location.insert(into: strongSelf.persistanceManager, raw: location)
                })
            })
        }
    }
}

struct LocationRaw: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "display_name"
        case lat = "latitude"
        case long = "longitude"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let tmpLat = try Double(container.decode(String.self, forKey: .lat)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.lat], debugDescription: "Expecting string representation of Double"))
        }
        guard let tmpLong = try Double(container.decode(String.self, forKey: .long)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.long], debugDescription: "Expecting string representation of Double"))
        }
        id = try container.decode(Int64.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        lat = tmpLat
        long = tmpLong
    }
   
    // conveniance init for the persistance manager tests
    init() {
        id = 0
        lat = 10
        long = -10
        name = ""
    }
    
    let id: Int64
    let lat: Double
    let long: Double
    let name: String
}
