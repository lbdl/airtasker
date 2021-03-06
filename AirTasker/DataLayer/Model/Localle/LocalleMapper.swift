//
//  LocalleMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 14/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation
import CoreData

class LocalleMapper: JSONMappingProtocol {
    
    internal var decoder: JSONDecodingProtocol
    internal var mappedValue: MappedValue?
    internal var persistanceManager: PersistenceControllerProtocol
    
    typealias MappedValue = Mapped<LocalleRaw>
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
            let tmp = try decoder.decode(LocalleRaw.self, from: rawValue)
            mappedValue = .Value(tmp)
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }
    
    internal func persist(rawJson: Mapped<LocalleRaw>) {
        if let obj = rawJson.associatedValue() as? LocalleRaw {
            persistanceManager.updateContext(block: {
                _ = Localle.insert(into: self.persistanceManager, raw: obj)
            })
        }
    }
}

struct LocalleRaw: Decodable {
    
    enum RootKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case workerCount = "worker_count"
        case workerIDs = "worker_ids"
        case activities = "recent_activity"
        case profiles
        case tasks
    }
    
    let id: Int64
    let displayName: String
    let workerCount: Int64
    let workerIDs: [Int64]
    let activities: [ActivityRaw]
    let profiles: [ProfileRaw]
    let tasks: [TaskRaw]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        id = try! container.decode(Int64.self, forKey: .id)
        displayName = try! container.decode(String.self, forKey: .displayName)
        workerCount = try! container.decode(Int64.self, forKey: .workerCount)
        workerIDs = try! container.decode([Int64].self, forKey: .workerIDs)
        activities = try! container.decode([ActivityRaw].self, forKey: .activities)
        profiles = try! container.decode([ProfileRaw].self, forKey: .profiles)
        tasks = try! container.decode([TaskRaw].self, forKey: .tasks)
    }
    
    // internal init for tests
    internal init() {
        id = 0
        displayName = "Test"
        workerCount = 0
        workerIDs = [0]
        activities = []
        profiles = []
        tasks = []
    }
}
