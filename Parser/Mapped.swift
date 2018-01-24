//
//  Mapped.swift
//  AirTasker
//
//  Created by Timothy Storey on 23/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import Foundation

enum Mapped<A> {
    case Error(NSError)
    case Right(A)
}
