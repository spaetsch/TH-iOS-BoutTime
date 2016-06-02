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
    
    var loadedQuiz: BookQuiz                // set of all possible questions, converted from plist
    var roundQuiz = BookQuiz(events: [])    // random selection of four unique books for a given round
  
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
        roundQuiz = setQuestions(loadedQuiz)
        displayChoices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //basic logic
    // TODO: function to check if answer is right, award points
    // TODO: show feedback right or wrong
    // TODO: six rounds of play then show score
    
    // advanced
    // TODO: Shake device to check answer
    
    // TODO: EXTRA CREDIT: at end of round, can click event and get webview with more info
    
    // MARK: Helper Functions

    //functions to randomly populate events for each round, no event appears twice in a round
    func setQuestions(original: BookQuiz) -> BookQuiz {
        let shuffledQuiz = BookQuiz(events: GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(original.events) as! [Book])
        roundQuiz.events += shuffledQuiz.events[0...numberOfBooks-1]
        return roundQuiz
    }
    
    func displayChoices(){
        timerCounter = maxTime
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        Q1Label.text = "\(roundQuiz.events[0].desc)"
        Q2Label.text = "\(roundQuiz.events[1].desc)"
        Q3Label.text = "\(roundQuiz.events[2].desc)"
        Q4Label.text = "\(roundQuiz.events[3].desc)"
    }
    
    @IBAction func arrowClick(sender: UIButton) {
        switch sender {
        case Q1DownButton:
            swapLabels(Q1Label, dest: Q2Label)
        case Q2DownButton:
            swapLabels(Q2Label, dest: Q3Label)
        case Q2UpButton:
            swapLabels(Q2Label, dest: Q1Label)
        case Q3DownButton:
            swapLabels(Q3Label, dest: Q4Label)
        case Q3UpButton:
            swapLabels(Q3Label, dest: Q2Label)
        case Q4UpButton:
            swapLabels(Q4Label, dest: Q3Label)
        default:
            print("oops")
        }
    }

    func swapLabels(origin: UILabel, dest: UILabel){
        let temp = origin.text
        origin.text = dest.text
        dest.text = temp
    }
    
    // Decrements the timer counter and displays to timer label
    func updateCounter(){
        timerCounter -= 1
        TimerLabel.text = String(timerCounter)
        
        if timerCounter == 0 {
        stopTimer()
           //checkAnswers()
        }
    }
    
    // Stops the timer, resets timerCounter to full time
    func stopTimer(){
        timer.invalidate()
        timerCounter = maxTime
    }
    
    // sortBooks() - sort roundQuiz into answer key
    // checkAnswer() - compare label title text to answers
    //need to go back and change event to one element
//    
//    func sortBooks(booklist: BookQuiz) -> BookQuiz{
//        return sortQuiz
//    }
//    check if
//    func checkAnswers(){
//        
//    }
}

