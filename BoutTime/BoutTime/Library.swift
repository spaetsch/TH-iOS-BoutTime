//
//  QuizLibrary.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 5/26/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import Foundation

class Library {
    var books: [Book]
    
    init(books: [Book]){
        self.books = books
    }
    
    init(){
        self.books = [
            Book(title: "A Wrinkle in Time", author: "Madeleine L'Engle", pubYear: 1962),
            Book(title: "Mists of Avalon", author: "Marion Zimmer Bradley", pubYear: 1979),
            Book(title:"The Children of Men", author: "P.D. James", pubYear: 1992)
        ]
    }
    
}