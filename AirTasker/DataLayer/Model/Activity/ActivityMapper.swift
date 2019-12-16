//
//  ActivityMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 14/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

class ActivityMapper: JSONMappingProtocol {

    internal var decoder: JSONDecodingProtocol
    internal var mappedValue: MappedValue?
    internal var persistanceManager: PersistenceControllerProtocol

    typealias MappedValue = Mapped<[ActivityRaw]>
    typealias raw = Data

    required init(storeManager: PersistenceControllerProtocol, decoder: JSONDecodingProtocol=JSONDecoder()) {
        persistanceManager = storeManager
        self.decoder = decoder
    }


    var rawValue: raw? {
        didSet {
            parse(rawValue: rawValue!)
        }
    }

    internal func parse(rawValue: Data) {
        do {
            let tmp = try decoder.decode([ActivityRaw].self, from: rawValue)
            mappedValue = .Value(tmp)
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }
    
    internal func persist(rawJson: MappedValue) {
        if let obj = rawJson.associatedValue() as? [ActivityRaw] {
            persistanceManager.updateContext(block: {
                _ = obj.map({ [weak self] activity in
                    guard let strongSelf = self else { return }
                    _ = Activity.insert(into: strongSelf.persistanceManager, raw: activity)
                })
            })
        }
    }

}

struct ActivityRaw: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "task_id"
        case internalMessage = "message"
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


