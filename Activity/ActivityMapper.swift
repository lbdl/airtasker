//
//  ActivityMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 14/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

class ActivityMapper: JSONMapper {

    internal var decoder: JSONDecoder
    internal var mappedValue: value?
    internal var persistanceManager: PersistenceController

    typealias value = Mapped<[ActivityRaw]>
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
            let tmp = try decoder.decode([ActivityRaw].self, from: rawValue)
            mappedValue = .Value(tmp)
            _ = tmp.map({ activity in
                _ = Activity.insert(into: persistanceManager, raw: activity)
            })
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }
    
    internal func persist(rawJson: Mapped<[ActivityRaw]>) {
        //
    }

}

struct ActivityRaw: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "task_id"
        case internalMessage
        case event
        case created = "created_at"
        case profileID = "profile_id"
    }
    
        let id: Int64
        let internalMessage: String
        let event: String
        let createdAt: String
        let profileID: Int64
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        internalMessage = try container.decode(String.self, forKey: .internalMessage)
        event = try container.decode(String.self, forKey: .event)
        createdAt = try container.decode(String.self, forKey: .created)
        profileID = try container.decode(Int64.self, forKey: .profileID)
    }
}


