//
//  Book.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 5/26/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import Foundation

protocol EventType {
    var desc1: String { get }
    var desc2: String { get }
    var year: Int { get }
}

struct Book: EventType {
    var desc1: String
    var desc2: String
    var year: Int
}