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

class Book: EventType {
    var desc: String
    var year: Int
    var URL: String
    
    init(desc: String, year: Int, URL: String){
        self.desc = desc
        self.year = year
        self.URL = URL
    }
}