//
//  ProfileMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 01/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

class ProfileMapper: JSONMapper {
    
    internal var decoder: JSONDecoder
    internal var mappedValue: value?
    internal var persistanceManager: PersistenceController
    
    typealias value = Mapped<[ProfileRaw]>
    typealias raw = Data
    
    required init(storeManager: PersistenceController) {
        persistanceManager = storeManager
        decoder = JSONDecoder()
    }
    
    
    var rawValue: raw? {
        didSet {
            map(rawValue: rawValue!)
        }
    }
    
    internal func map(rawValue: Data) {
        do {
            let tmp = try decoder.decode([ProfileRaw].self, from: rawValue)
            mappedValue = .Value(tmp)
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }
    
    internal func persist(rawJson: value) {
        if let obj = rawJson.associatedValue() as? [ProfileRaw] {
            _ = obj.map({ [weak self] profile in
                _ = Profile.insert(into: (self?.persistanceManager)!, raw: profile)
            })
        }
    }
    
}

struct ProfileRaw: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case avatarURL = "avatar_mini_url"
        case desc = "description"
        case rating
        case locationID = "location_id"
    }
    
    let id: Int64
    let rating: Double
    let firstName: String
    let desc: String
    let locationID: Int64
    let avatarURL: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        rating = try container.decode(Double.self, forKey: .rating)
        firstName = try container.decode(String.self, forKey: .firstName)
        desc = try container.decode(String.self, forKey: .desc)
        locationID = try container.decode(Int64.self, forKey: .locationID)
        avatarURL = try container.decode(String.self, forKey: .avatarURL)
    }
}



