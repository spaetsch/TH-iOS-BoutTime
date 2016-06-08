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
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var showScoreButton: UIButton!
    
    var loadedQuiz: BookQuiz                // set of all possible questions, converted from plist
    var roundQuiz = BookQuiz(events: [])    // random selection of four unique books for a given round
    
    let numberOfBooks = 4
    let numberOfRounds = 3 // 6
    
    var questionsAsked = 0
    var questionsCorrect = 0
    
    let maxTime = 15 //60 seconds
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
    }

    override func viewWillAppear(animated: Bool) {
        
        questionsAsked = 0
        questionsCorrect = 0
        enableChoices(true)
        showScoreButton.hidden = true
        
        setQuestions(loadedQuiz)
        displayRound()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showScoreSegue" {
            if let destination = segue.destinationViewController as? ScoreViewController {
                destination.questionsAsked = self.questionsAsked
                destination.questionsCorrect = self.questionsCorrect
            }
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            timerCounter = 0  // run the timer out, triggers reset and evaluation of answer
        }
    }
    
    
    // when arrow button is clicked, handles determining which labels should be swapped
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
    
    
    // TODO: EXTRA CREDIT: at end of round, can click event and get webview with more info
    
    // MARK: Helper Functions

    // shuffles the loaded quiz and stores the first four elements in roundQuiz to create question set for a given round
    func setQuestions(original: BookQuiz) {
        let shuffledQuiz = BookQuiz(events: GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(original.events) as! [Book])
        roundQuiz.events += shuffledQuiz.events[0...numberOfBooks-1]
    }
    
    // sets the label text for each choice to .desc from events array
    func displayRound(){
        createTimer()
        
        Q1Label.text = "\(roundQuiz.events[0].desc)"
        Q2Label.text = "\(roundQuiz.events[1].desc)"
        Q3Label.text = "\(roundQuiz.events[2].desc)"
        Q4Label.text = "\(roundQuiz.events[3].desc)"
    }
    
    // given a origin and destination label, swaps their text fields
    func swapLabels(origin: UILabel, dest: UILabel){
        let temp = origin.text
        origin.text = dest.text
        dest.text = temp
    }
    
    // resets timer to max
    func createTimer(){
        timerCounter = maxTime
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(manageCounter), userInfo: nil, repeats: true)
        timerLabel.text = String(timerCounter)
    }

    // next round button is clicked, checks if the game should continue or display final score
    // if continuing game, resets questions and displays new set
    @IBAction func clickNext() {
            roundQuiz = BookQuiz(events: []) // blank quiz
            setQuestions(loadedQuiz)
            displayRound()
            enableChoices(true)
    }
    
    // Decrements the timer counter and displays to timer label
    // When timer reaches zero, invalidates timer and evaluates round
    func manageCounter(){
        timerCounter -= 1
        timerLabel.text = String(timerCounter)
        
        if timerCounter < 1 {
            enableChoices(false)
            checkAnswers()
            timer.invalidate()
        }
    }
    
    // sorts an array of Books in ascending order by .year
    func sortBooks(books: BookQuiz) -> [Book]{
        return books.events.sort({$0.year < $1.year})
    }
    
    // checks order of user choices against correct ascending order
    func checkAnswers(){
        questionsAsked += 1
        
        let answerKey = sortBooks(roundQuiz)

        if (Q1Label.text == answerKey[0].desc && Q2Label.text == answerKey[1].desc
            && Q3Label.text == answerKey[2].desc && Q4Label.text == answerKey[3].desc){
            questionsCorrect += 1
            nextButton.setImage(UIImage(named: "next_round_success"), forState: UIControlState.Normal)
        }
        nextButton.setImage(UIImage(named: "next_round_fail"), forState: UIControlState.Normal)

        if questionsAsked == numberOfRounds {
            nextButton.hidden = true
            timerLabel.hidden = true
            showScoreButton.hidden = false            
        }
    }
    
    // toggles between timer visible and arrow buttons enabled vs. showing nextButton and arrow buttons disabled
    func enableChoices(show: Bool){
        if show {
            timerLabel.hidden = false
            Q1DownButton.enabled = true
            Q2DownButton.enabled = true
            Q2UpButton.enabled = true
            Q3DownButton.enabled = true
            Q3UpButton.enabled = true
            Q4UpButton.enabled = true
            nextButton.hidden = true
        } else {
            timerLabel.hidden = true
            Q1DownButton.enabled = false
            Q2DownButton.enabled = false
            Q2UpButton.enabled = false
            Q3DownButton.enabled = false
            Q3UpButton.enabled = false
            Q4UpButton.enabled = false
            nextButton.hidden = false
        }
    }
}

