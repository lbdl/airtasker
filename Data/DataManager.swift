//
//  DataManager.swift
//  AirTasker
//
//  Created by Timothy Storey on 22/02/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import Foundation

protocol LocationDataPrototcol {
    func fetchLocations()
}

protocol LocallesDataProtocol {
    func fetchLocationData(for locationId: Int64)
}

protocol AvatarManager {
    func fetchAvatarData(for profileId: String) -> UIImage?
}

// we are only going to use shared sessions
// in this impelmetation
enum SessionType {
    case backgroundSession
    case sharedSession
    case emphemeralSession
}

enum HttpMethods: String {
    case get = "GET"
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
///
/// - Returns:
///     - An instance of DataManager
///
/// - parameters:
///     - storeManager: an object conforming to the PerssistenceController protocol that handles persisting data
///     - networkManager: an object conforming to the URLSessionProtocol that fetches data
///     - configuration: a enumeration defining the tyle of sessiopersistenceManagern, in this case default
class DataManager: NSObject, LocationDataPrototcol {
    
    let persistenceManager: PersistenceControllerProtocol
    let dataSession: URLSessionProtocol
    
    private let scheme: String = "https"
    private let host: String = "s3-ap-southeast-2.amazonaws.com/ios-code-test/v2"
    
    required init(storeManager: PersistenceControllerProtocol, urlSession: URLSessionProtocol, configuration: SessionType = .sharedSession) {
        persistenceManager = storeManager
        dataSession = urlSession
    }
    
    /// Fetches all location stored in the remote DB
    /// - Returns: void
    func fetchLocations() {
        guard let url = makeLocationsURL() else {return}
        guard let request = makeRequest(fromUrl: url) else {return}
        let task =  dataSession.dataTask(with: request) { (data, response, error) in
            
        }
        task.resume()
    }
    
    private func parseLocation(Data rawData: Data) {
        // pass data to persistence manager
    }
    
    /// Fetches specific localle data stored in the remote DB
    /// - Returns: void
    ///
    /// - parameters:
    ///     - locationID: the id of the required localle obtained from the location object
    func fetchLocationData(for locationId: Int64) {
        
    }
    
    func fetchAvatarData(for profileId: String) -> UIImage? {
        return UIImage()
    }
    
    private func makeLocationsURL() -> URL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = scheme;
        urlComponents.host = host;
        urlComponents.path = "/locations.json";
        
        return urlComponents.url
    }
    
    private func makeRequest(fromUrl url: URL, forMethod method: HttpMethods = HttpMethods.get) -> NSURLRequest? {
        let request = NSMutableURLRequest(url: makeLocationsURL()!)
        request.httpMethod = method.rawValue
        return request as NSURLRequest
    }
    
    private func makeLocationURL(forId id: Int64) -> URL? {
        return nil
    }
    
}
