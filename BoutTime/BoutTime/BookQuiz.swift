//
//  QuizLibrary.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 5/26/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import Foundation

class Quiz {
    var events: [Book]
    
    init(events: [Book]){
        self.events = events
    }
}


// Error Types - from vending

enum QuizError: ErrorType {
    case InvalidResource
    case ConversionError
    case InvalidKey
}


// Helper Classes

class PlistConverter {
    class func dictionaryFromFile(resource: String, ofType type: String) throws -> [String : AnyObject] {
        
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw QuizError.InvalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path),
            let castDictionary =  dictionary as? [String : AnyObject] else {
                throw QuizError.ConversionError
        }
        return castDictionary
    }
}

//class InventoryUnarchiver {
//    class func vendingInventoryFromDictionary(dictionary: [String : AnyObject]) throws -> [VendingSelection : ItemType]{
//        var inventory: [VendingSelection : ItemType] = [:]
//        
//        for (key, value) in dictionary {
//            if let itemDict = value as? [String : Double],
//                let price = itemDict["price"],
//                let quantity = itemDict["quantity"] {
//                
//                let item = VendingItem(price: price, quantity: quantity)
//                
//                guard let key = VendingSelection(rawValue: key) else {
//                    throw InventoryError.InvalidKey
//                }
//                inventory.updateValue(item, forKey: key)
//            }
//        }
//        return inventory
//    }
//}