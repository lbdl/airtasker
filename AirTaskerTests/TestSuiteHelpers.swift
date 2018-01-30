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
    
    static func readLocalData() -> Data? {
        let testBundle = Bundle(for: self)
        let url = testBundle.url(forResource: "locations", withExtension: "json")
        guard let data = NSData(contentsOf: url!) as Data? else {return nil}
        return data
    }
    
}
