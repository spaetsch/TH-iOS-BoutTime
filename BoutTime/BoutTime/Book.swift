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
    var pubYear: Int
    
    init(title: String, author: String, pubYear: Int){
        self.title = title
        self.author = author
        self.pubYear = pubYear
    }
    
}