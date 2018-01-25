//
//  DataMapper.swift
//  AirTasker
//
//  Created by Timothy Storey on 25/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

protocol JSONMapper {
    associatedtype value 
    associatedtype raw
    var rawValue: raw {set}
    var mappedValue: value {get}
    func map(rawValue: raw) -> value
}
