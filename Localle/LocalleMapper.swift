//
//  LocalleMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 14/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation
import CoreData

class LocalleMapper: JSONMapper {
    
    internal var decoder: JSONDecoder
    internal var mappedValue: value?
    internal var persistanceManager: PersistenceController
    
    typealias value = Mapped<LocalleRaw>
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
            let tmp = try decoder.decode(LocalleRaw.self, from: rawValue)
            mappedValue = .Value(tmp)
        } catch let error {
            let tmp = error as! DecodingError
            mappedValue = .MappingError(tmp)
        }
    }
    
    internal func persist(rawJson: Mapped<LocalleRaw>) {
        if let obj = rawJson.associatedValue() as? LocalleRaw {
            _ = Localle.insert(into: persistanceManager, raw: obj)
        }
    }
}

struct LocalleRaw: Decodable {
    
    enum RootKeys: String, CodingKey {
        case id
        case displayName = "displayName"
        case workerCount = "worker_count"
        case workerIDs = "worker_ids"
        case activities = "recent_activities"
        case profiles
        case tasks
    }
    
    let id: Int64
    let location: LocationRaw?
    let displayName: String
    let workerCount: Int64
    let workerIDs: [Int64]
    let activities: [ActivityRaw]?
    let profiles: [ProfileRaw]?
    let tasks: [TaskRaw]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        id = try! container.decode(Int64.self, forKey: .id)
        displayName = try! container.decode(String.self, forKey: .displayName)
        workerCount = try! container.decode(Int64.self, forKey: .workerCount)
        workerIDs = try! container.decode([Int64].self, forKey: .workerIDs)
        activities = nil
        profiles = nil
        tasks = nil
        location = nil
    }
}
