//
//  DataManager.swift
//  AirTasker
//
//  Created by Timothy Storey on 22/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import Foundation

protocol DataController {
    var persistenceManager: PersistenceControllerProtocol{ get }
    func fetchLocations()
    func fetchLocationData(for locationId: String)
    func fetchAvatarData(for profileId: String) -> UIImage?
}

// we are only going to use shared sessions
// in this impelmetation
enum SessionType {
    case backgroundSession
    case sharedSession
    case emphemeralSession
}

/// The data manager is intended to be passed between view controllers as a data handler
/// for remote data access and local data persistence.
/// It is only implemented for default sessions athough it is intended to be extended
/// for background tasks.
///
/// This implementation also makes no considerations of authentication etc although
/// the data manager should handle all of this as per the servers requirements internally
/// and in an opaque manner as far as the consumers of the manager are concerned
///
/// A view controller should not need to know anything about it other
/// than to call the methods it needs as defined in the DataController protocol.
///
/// Data fetched is stored in CoreData. The views should be updated via a fetched results controller.
/// - return
///     - An instance of DataManager
/// - parameters
///     - storeManager: an object conforming to the PerssistenceController protocol that handles persisting data
///     - networkManager: an object conforming to the URLSessionProtocol that fetches data
///     - configuration: a enumeration defining the tyle of sessiopersistenceManagern, in this case default
class DataManager: NSObject, DataController {
    let persistenceManager: PersistenceControllerProtocol
    let dataSession: URLSessionProtocol
    
    required init(storeManager: PersistenceControllerProtocol, urlSession: URLSessionProtocol, configuration: SessionType = .sharedSession) {
        persistenceManager = storeManager
        dataSession = urlSession
    }
    
    func fetchLocations() {
        //
    }
    
    func fetchLocationData(for locationId: String) {
        //
    }
    
    func fetchAvatarData(for profileId: String) -> UIImage? {
        return UIImage()
    }
    
}
