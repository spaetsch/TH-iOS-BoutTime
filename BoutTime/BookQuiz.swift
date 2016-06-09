//
//  QuizLibrary.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 5/26/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import Foundation

class BookQuiz {
    var events: [Book]
    
    init(events: [Book]){
        self.events = events
    }
    
}

// Error Types

enum QuizError: ErrorType {
    case InvalidResource
    case ConversionError
    case InvalidKey
}


// Helper Classes

class PlistConverter {
    class func arrayFromFile(resource: String, ofType type: String) throws -> [[String : String]] {
        
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw QuizError.InvalidResource
        }
        
        guard let array = NSArray(contentsOfFile: path),
            let castArray = array as? [[String : String]] else {
                throw QuizError.ConversionError
        }
        return castArray
    }
}


class QuizUnarchiver {
    class func bookQuizFromArray(array: [[String : String]]) -> [Book]{
        var quiz: [Book] = []

        for book in array {
            if let desc = book["name"],
            let year = book["year"],
            let convertYr = Int(year),
            let URL = book["URL"]{
                let newBook = Book(desc: desc, year: convertYr, URL: URL)
                quiz.append(newBook)
            }
        }
        return quiz
    }
}