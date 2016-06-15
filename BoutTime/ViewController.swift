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
    
   // @IBOutlet weak var Q1Label: UILabel!
    
    @IBOutlet weak var q1BookButton: UIButton!
    @IBOutlet weak var q2BookButton: UIButton!
    
   // @IBOutlet weak var Q2Label: UILabel!
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
    
    @IBOutlet weak var shakeTapLabel: UILabel!
    
    @IBOutlet weak var showScoreButton: UIButton!
    
    var loadedQuiz: BookQuiz                // set of all possible questions, converted from plist
    var roundQuiz = BookQuiz(events: [])    // random selection of four unique books for a given round
    
    // game constants
    let numberOfBooks = 4
    let numberOfRounds = 3 // 6
    let maxTime = 15 //60 seconds

    let URL404 = "https://en.wikipedia.org/wiki/HTTP_404"

    // game counters
    var questionsAsked = 0
    var questionsCorrect = 0
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
        setupGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // before segueing to another view, pass along the required variable values
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showScoreSegue" {
            if let destination = segue.destinationViewController as? ScoreViewController {
                destination.questionsAsked = self.questionsAsked
                destination.questionsCorrect = self.questionsCorrect
            }
        }
        if segue.identifier == "showWebViewSegue" {
            if let destination = segue.destinationViewController as? WebViewController {
                destination.webViewURL = setURL(sender as! UIButton)
            }
        }
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    // respond to shaking device by ending the round
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            timerCounter = 0  // run the timer out, triggers reset and evaluation of answer
        }
    }
    
    // when unwinding back to main view, check if game needs to be reset
    @IBAction func unwindHandler(unwindSegue: UIStoryboardSegue){
        if unwindSegue.identifier == "unwindFromScore" {
            setupGame()
        }
    }
    
    // when arrow button is clicked, handles determining which labels should be swapped
    @IBAction func arrowClick(sender: UIButton) {
        switch sender {
        case Q1DownButton:
            swapButtonTitles(q1BookButton, dest: q2BookButton)
        /*case Q2DownButton:
            swapLabels(Q2Label, dest: Q3Label)*/
        case Q2UpButton:
            swapButtonTitles(q2BookButton, dest: q1BookButton)
        /* case Q3DownButton:
            swapLabels(Q3Label, dest: Q4Label)
        case Q3UpButton:
            swapLabels(Q3Label, dest: Q2Label)
        case Q4UpButton:
            swapLabels(Q4Label, dest: Q3Label)*/
        default:
            print("oops")
        }
    }

    // resets questions, timer, buttons
    @IBAction func setupNextRound() {
        roundQuiz = BookQuiz(events: []) // blank quiz
        enableChoices(true)
        setQuestions(loadedQuiz)
        createTimer()
        displayRound()
    }

    // MARK: Helper Functions -- Managing the quiz questions

    // shuffles the loaded quiz and stores the first four elements in roundQuiz to create question set for a given round
    func setQuestions(original: BookQuiz) {
        let shuffledQuiz = BookQuiz(events: GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(original.events) as! [Book])
        roundQuiz.events += shuffledQuiz.events[0...numberOfBooks-1]
    }
    
    // sets the label text for each choice to .desc from events array
    func displayRound(){
        
        let title1 = "Testy Title"
        let byline = "\nby Test Author"
        
        let fontAtt = [NSFontAttributeName : UIFont.systemFontOfSize(14.0)]
        let boldFontAtt = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16.0)]
        
        let boldTitle = NSAttributedString(string: title1, attributes: boldFontAtt)
        let normalAuthor = NSAttributedString(string: byline, attributes: fontAtt)
        
        let attLabelText = NSMutableAttributedString(attributedString: boldTitle)
        attLabelText.appendAttributedString(normalAuthor)
        
        //let att = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16)]
        
        //let boldtitle1 = NSMutableAttributedString(string:title1, attributes:att)
        
        //UIFont.boldSystemFontOfSize(18.0)
        //UIFont.systemFontOfSize(19.0)
        //self.setAttributedTitle(title: NSAttributedString?, forState: <#T##UIControlState#>)

        q1BookButton.setAttributedTitle(attLabelText, forState: .Normal)
        //q1BookButton.setTitle("\(title1)\nby \(author1)", forState: .Normal)
       // q2BookButton.setTitle(roundQuiz.events[1].desc, forState: .Normal)
        

        Q3Label.text = "\(roundQuiz.events[2].desc)"
        Q4Label.text = "\(roundQuiz.events[3].desc)"
    }
    
    // sorts an array of Books in ascending order by .year
    func sortBooks(books: BookQuiz) -> [Book]{
        return books.events.sort({$0.year < $1.year})
    }
    
    // checks order of user choices against correct ascending order
    func checkAnswers(){
        questionsAsked += 1
        
        let answerKey = sortBooks(roundQuiz)
        
        if (q1BookButton.titleLabel?.text == answerKey[0].desc && q2BookButton.titleLabel?.text == answerKey[1].desc
            && Q3Label.text == answerKey[2].desc && Q4Label.text == answerKey[3].desc){
            questionsCorrect += 1
            if (questionsAsked < numberOfRounds){
                nextButton.setImage(UIImage(named: "next_round_success"), forState: UIControlState.Normal)
            } else {
                showScoreButton.setImage(UIImage(named: "show_score_success"), forState: .Normal)
            }
        }
        if (questionsAsked < numberOfRounds){
            nextButton.setImage(UIImage(named: "next_round_fail"), forState: UIControlState.Normal)
        } else {
            showScoreButton.setImage(UIImage(named: "show_score_fail"), forState: .Normal)
        }
        
        if questionsAsked == numberOfRounds {
            nextButton.hidden = true
            timerLabel.hidden = true
            showScoreButton.hidden = false
        }
    }
    
    // MARK: Helper Functions -- Managing the counter

    // resets timer to max
    func createTimer(){
        timerCounter = maxTime
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(manageCounter), userInfo: nil, repeats: true)
        timerLabel.text = String(timerCounter)
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
    
    // MARK: Helper Functions -- Other

    // in addition to setting up new round, resets the game counters
    func setupGame(){
        questionsAsked = 0
        questionsCorrect = 0
        showScoreButton.hidden = true
        setupNextRound()
    }
    
    // grabs the associated URL for info on a button
    func setURL(senderButton: UIButton) -> String {
        if let label = senderButton.titleLabel {
            for item in roundQuiz.events {
                if item.desc == label.text {
                    return item.URL
                }
            }
        }
        return URL404
    }
    
    // given a origin and destination label, swaps their text fields
    func swapLabels(origin: UILabel, dest: UILabel){
        let temp = origin.text
        origin.text = dest.text
        dest.text = temp
    }
    
    func swapButtonTitles(origin: UIButton, dest: UIButton){
        let first = origin.titleLabel?.text
        let second = dest.titleLabel?.text
        origin.setTitle(second, forState: .Normal)
        dest.setTitle(first, forState: .Normal)
        
    }
    
    // toggles between timer visible and arrow buttons enabled vs. showing nextButton and arrow buttons disabled
    func enableChoices(show: Bool){
        if show {
            Q1DownButton.enabled = true
            Q2DownButton.enabled = true
            Q2UpButton.enabled = true
            Q3DownButton.enabled = true
            Q3UpButton.enabled = true
            Q4UpButton.enabled = true
            
            q1BookButton.enabled = false
            q2BookButton.enabled = false
            
            timerLabel.hidden = false
            nextButton.hidden = true
            shakeTapLabel.text = "Shake to complete"
            
        } else {
            Q1DownButton.enabled = false
            Q2DownButton.enabled = false
            Q2UpButton.enabled = false
            Q3DownButton.enabled = false
            Q3UpButton.enabled = false
            Q4UpButton.enabled = false
            
            q1BookButton.enabled = true
            q2BookButton.enabled = true
            
            timerLabel.hidden = true
            nextButton.hidden = false
            shakeTapLabel.text = "Tap events for more info"
        }
    }
}

