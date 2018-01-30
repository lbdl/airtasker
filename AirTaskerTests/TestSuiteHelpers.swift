//
//  TestSuiteHelpers.swift
//  AirTaskerTests
//
//  Created by Timothy Storey on 26/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit
import CoreData
@testable import AirTasker



class TestSuiteHelpers: NSObject {
    
    static func readLocalData(badData bad: Bool) -> Data? {
        let testBundle = Bundle(for: self)
        var url: URL?
        if bad {
            url = testBundle.url(forResource: "badLocations", withExtension: "json")
        }else {
            url = testBundle.url(forResource: "locations", withExtension: "json")
        }
        guard let data = NSData(contentsOf: url!) as Data? else {return nil}
        return data
    }
}
