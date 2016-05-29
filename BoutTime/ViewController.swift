//
//  ViewController.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 5/26/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    @IBOutlet weak var Q1Label: UILabel!
    @IBOutlet weak var Q2Label: UILabel!
    @IBOutlet weak var Q3Label: UILabel!
    @IBOutlet weak var Q4Label: UILabel!
    
    @IBOutlet weak var Q1DownButton: UIButton!
    @IBOutlet weak var Q2UpButton: UIButton!
    @IBOutlet weak var Q2DownButton: UIButton!
    @IBOutlet weak var Q3UpButton: UIButton!
    @IBOutlet weak var Q3DownButton: UIButton!
    @IBOutlet weak var Q4UpButton: UIButton!
    
    @IBOutlet weak var TimerLabel: UILabel!
    
    var currentQuiz: BookQuiz
    var shuffledQuiz = BookQuiz(events: [])
    
    let numberOfChoices = 4
    
    let numberOfRounds = 6
    var currentRound = 0
    var numberCorrect = 0
    let maxTime = 60

    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile("BookQuiz", ofType: "plist")
            self.currentQuiz = BookQuiz(events:QuizUnarchiver.bookQuizFromArray(array))
        } catch let error {
            //TODO: be more specific?
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        shuffledQuiz = shuffleQuiz(currentQuiz)
        displayChoices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //setup
    // TODO: functions to move events up and down

    
    //basic logic
    // TODO: function to check if answer is right, award points
    // TODO: show feedback right or wrong
    // TODO: six rounds of play then show score
    
    // advanced
    // TODO: Shake device to check answer
    // TODO: Countdown timer
    
    // bonus
    // TODO: EXTRA CREDIT: at end of round, can click event and get webview with more info
    
    // MARK: Helper Functions

    // DONE: functions to randomly populate events for each round, no event appears twice in a round

    func shuffleQuiz(original: BookQuiz) -> BookQuiz {
        return BookQuiz(events: GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(original.events) as! [Book])
    }
    
    func displayChoices(){
        Q1Label.text = "\(shuffledQuiz.events[currentRound].desc) \nby \(shuffledQuiz.events[currentRound].author)"
        Q2Label.text = "\(shuffledQuiz.events[currentRound+1].desc) \nby \(shuffledQuiz.events[currentRound+1].author)"
        Q3Label.text = "\(shuffledQuiz.events[currentRound+2].desc) \nby \(shuffledQuiz.events[currentRound+2].author)"
        Q4Label.text = "\(shuffledQuiz.events[currentRound+3].desc) \nby \(shuffledQuiz.events[currentRound+3].author)"
    }
    

}

