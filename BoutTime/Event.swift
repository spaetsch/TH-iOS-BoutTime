//
//  Book.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 5/26/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import Foundation

protocol EventType {
    var desc: String { get }
    var year: Int { get }
}

struct Book: EventType {
    var desc: String
    var author: String
    var year: Int
}