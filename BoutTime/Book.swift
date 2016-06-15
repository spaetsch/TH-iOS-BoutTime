//
//  Book.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 5/26/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import Foundation

class Book {
    var title: String
    var author: String
    var year: Int
    var URL: String
    
    init(title: String, author: String, year: Int, URL: String){
        self.title = title
        self.author = author
        self.year = year
        self.URL = URL
    }
}