//
//  ViewController.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 5/26/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile("BookQuiz", ofType: "plist")
            print("array: \(array)\n")
            
            let quiz = QuizUnarchiver.bookQuizFromArray(array)
            print("quiz: \(quiz)\n")
            
           // let inventory = try InventoryUnarchiver.vendingInventoryFromDictionary(dictionary)
           // self.vendingMachine = VendingMachine(inventory: inventory)
        } catch let error {
            //TODO: be more specific?
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // TODO: functions to randomly populate events for each round, no event appears twice in a round
    
    // TODO: functions to move events up and down
    
    // TODO: function to check if answer is right, award points
    
    // TODO: Countdown timer
    
    // TODO: Shake device to check answer
    
    // TODO: six rounds of play then show score
    
    // TODO: EXTRA CREDIT: at end of round, can click event and get webview with more info

}

