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
    
    var loadedQuiz: BookQuiz
    var shuffledQuiz = BookQuiz(events: [])
    var roundQuiz = BookQuiz(events: [])
  
    let numberOfBooks = 4
    let numberOfRounds = 6
    var currentRound = 0
    var questionsAsked = 0
    var questionsCorrect = 0
    
    let maxTime = 5 //60 seconds
    var timerCounter: Int = 0
    var timer = NSTimer()

    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile("BookQuiz", ofType: "plist")
            self.loadedQuiz = BookQuiz(events:QuizUnarchiver.bookQuizFromArray(array))
        } catch let error {
            //TODO: be more specific?
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        //shuffledQuiz = shuffle(loadedQuiz)
        roundQuiz = setQuestions(loadedQuiz)
        displayChoices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //setup
    // TODO: Countdown timer
    
    //basic logic
    // TODO: function to check if answer is right, award points
    // TODO: show feedback right or wrong
    // TODO: six rounds of play then show score
    
    // advanced
    // TODO: Shake device to check answer

    
    // bonus
    // TODO: EXTRA CREDIT: at end of round, can click event and get webview with more info
    
    // MARK: Helper Functions

    // DONE: functions to randomly populate events for each round, no event appears twice in a round

    func shuffle(original: BookQuiz) -> BookQuiz {
        return BookQuiz(events: GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(original.events) as! [Book])
    }
    
    func setQuestions(original: BookQuiz) -> BookQuiz {
        let shuffledQuiz = BookQuiz(events: GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(original.events) as! [Book])
        roundQuiz.events += shuffledQuiz.events[0...numberOfBooks-1]
        return roundQuiz
    }
    
    func displayChoices(){
        
        timerCounter = maxTime
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        Q1Label.text = "\(roundQuiz.events[0].desc) \nby \(roundQuiz.events[0].author)"
        Q2Label.text = "\(roundQuiz.events[1].desc) \nby \(roundQuiz.events[1].author)"
        Q3Label.text = "\(roundQuiz.events[2].desc) \nby \(roundQuiz.events[2].author)"
        Q4Label.text = "\(roundQuiz.events[3].desc) \nby \(roundQuiz.events[3].author)"
    }
    
    @IBAction func arrowClick(sender: UIButton) {
        switch sender {
        case Q1DownButton:
            print("q1Down pressed")
            swapLabels(Q1Label, dest: Q2Label)
        case Q3DownButton:
            print("q3down pressed")
        default:
            print("oops")
        }
    }

    func swapLabels(origin: UILabel, dest: UILabel){
        let temp = origin.text
        origin.text = dest.text
        dest.text = temp
    }
    
    // Decrements the timer counter and displays to countdownLabel
    // Changes countdown color to red when less than 5 sec remain
    // Stops the timer if it reaches zero, increments questionsAsked, and enables nextQuestion
    func updateCounter(){
        timerCounter -= 1
        TimerLabel.text = String(timerCounter)
        
        if timerCounter == 0 {
            stopTimer()
          // checkAnswers()
        }
    }
    
    // Stops the timer, resets timerCounter to full time
    func stopTimer(){
        timer.invalidate()
        timerCounter = maxTime
    }
    
//    func checkAnswers(){
//        numberAsked += 1
//        
//    }
}

