//
//  TaskMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 14/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

class TaskMapper: JSONMapper {
    
    internal var decoder: JSONDecoder
    internal var mappedValue: value?
    internal var persistanceManager: PersistenceController
    
    typealias value = Mapped<[TaskRaw]>
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
            let tmp = try decoder.decode([TaskRaw].self, from: rawValue)
            mappedValue = .Value(tmp)
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }
    
    internal func persist(rawJson: value) {
        if let tmp = rawJson.associatedValue() as? [TaskRaw] {
            persistanceManager.updateContext(block: {
                _ = tmp.map({ [weak self]task in
                    _ = Task.insert(into: (self?.persistanceManager)!, raw: task)
                })
            })
        }
    }
    
}

struct TaskRaw: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case desc = "description"
        case eventState = "state"
        case profileID = "poster_id"
        case workerID = "worker_id"
    }
    
    let id: Int64
    let profileID: Int64
    let desc: String
    let name: String
    let eventState: String
    let workerID: Int64?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        profileID = try container.decode(Int64.self, forKey: .profileID)
        name = try container.decode(String.self, forKey: .name)
        eventState = try container.decode(String.self, forKey: .eventState)
        desc = try container.decode(String.self, forKey: .desc)
        workerID = try container.decode(Int64?.self, forKey: .workerID)
    }
}
