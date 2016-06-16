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
    
    @IBOutlet weak var q1BookButton: UIButton!
    @IBOutlet weak var q2BookButton: UIButton!
    @IBOutlet weak var q3BookButton: UIButton!
    @IBOutlet weak var q4BookButton: UIButton!

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
    var roundQuiz = BookQuiz(questions: [])    // random selection of four unique books for a given round

    // game constants
    let numberOfBooks = 4
    let numberOfRounds = 6 // 6
    let maxTime = 60 //60 seconds

    let soundSuccess = "/audio/CorrectDing"
    let soundFail = "/audio/IncorrectBuzz"
    var currSoundID: SystemSoundID = 0

    let URL404 = "https://en.wikipedia.org/wiki/HTTP_404"

    // game counters
    var questionsAsked = 0
    var questionsCorrect = 0
    var timerCounter: Int = 0
    var timer = NSTimer()
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile("BookQuiz", ofType: "plist")
            self.loadedQuiz = BookQuiz(questions:QuizUnarchiver.bookQuizFromArray(array))
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
        case Q2DownButton:
            swapButtonTitles(q2BookButton, dest: q3BookButton)
        case Q2UpButton:
            swapButtonTitles(q2BookButton, dest: q1BookButton)
        case Q3DownButton:
            swapButtonTitles(q3BookButton, dest: q4BookButton)
        case Q3UpButton:
            swapButtonTitles(q3BookButton, dest: q2BookButton)
        case Q4UpButton:
            swapButtonTitles(q4BookButton, dest: q3BookButton)
        default:
            print("oops")
        }
    }

    // resets questions, timer, buttons
    @IBAction func setupNextRound() {
        roundQuiz = BookQuiz(questions: []) // blank quiz
        enableChoices(true)
        setQuestions(loadedQuiz)
        createTimer()
        displayRound()
    }

    // MARK: Helper Functions -- Managing the quiz questions

    // shuffles the loaded quiz and stores the first four elements in roundQuiz to create question set for a given round
    func setQuestions(original: BookQuiz) {
        let shuffledQuiz = BookQuiz(questions: GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(original.questions) as! [Book])
        roundQuiz.questions += shuffledQuiz.questions[0...numberOfBooks-1]
    }
    
    func createAttrBookString(title: String, author: String) -> NSMutableAttributedString{
        let byline = "\nby \(author)"
        
        let boldFontAtt = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16.0)]
        let fontAtt = [NSFontAttributeName : UIFont.systemFontOfSize(14.0)]
        let textColorAtt = [NSForegroundColorAttributeName : UIColor(red: 0.063, green: 0.365, blue: 0.486, alpha: 1.00)]
        
        let boldTitle = NSAttributedString(string: title, attributes: boldFontAtt)
        let normalAuthor = NSAttributedString(string: byline, attributes: fontAtt)
    
        let attLabelText = NSMutableAttributedString(attributedString: boldTitle)
        attLabelText.appendAttributedString(normalAuthor)
        
        attLabelText.addAttributes(textColorAtt, range: NSRange(location: 0, length: attLabelText.length))
        return attLabelText
    }
    
    
    // sets the label text for each choice to .desc from questions array
    func displayRound(){

        let attLabelText1 = createAttrBookString(roundQuiz.questions[0].title, author: roundQuiz.questions[0].author)
        let attLabelText2 = createAttrBookString(roundQuiz.questions[1].title, author: roundQuiz.questions[1].author)
        let attLabelText3 = createAttrBookString(roundQuiz.questions[2].title, author: roundQuiz.questions[2].author)
        let attLabelText4 = createAttrBookString(roundQuiz.questions[3].title, author: roundQuiz.questions[3].author)

        q1BookButton.setAttributedTitle(attLabelText1, forState: .Normal)
        q2BookButton.setAttributedTitle(attLabelText2, forState: .Normal)
        q3BookButton.setAttributedTitle(attLabelText3, forState: .Normal)
        q4BookButton.setAttributedTitle(attLabelText4, forState: .Normal)
    }
    
    // sorts an array of Books in ascending order by .year
    func sortBooks(books: BookQuiz) -> [Book]{
        return books.questions.sort({$0.year < $1.year})
    }
    
    // checks order of user choices against correct ascending order
    func checkAnswers(){
        
        questionsAsked += 1
        
        let sortedQuiz = sortBooks(roundQuiz)
        
        if let answer1 = q1BookButton.titleLabel?.text,
        let answer2 = q2BookButton.titleLabel?.text,
        let answer3 = q3BookButton.titleLabel?.text,
        let answer4 = q4BookButton.titleLabel?.text {
            
            if answer1 == "\(sortedQuiz[0].title)\nby \(sortedQuiz[0].author)"
                && answer2 == "\(sortedQuiz[1].title)\nby \(sortedQuiz[1].author)"
                && answer3 == "\(sortedQuiz[2].title)\nby \(sortedQuiz[2].author)"
                && answer4 == "\(sortedQuiz[3].title)\nby \(sortedQuiz[3].author)" {
                
                questionsCorrect += 1
                nextButton.setImage(UIImage(named: "next_round_success"), forState: .Normal)
                showScoreButton.setImage(UIImage(named: "show_score_success"), forState: .Normal)
                loadSound(soundSuccess, soundID: &currSoundID, type: "wav")    //Loads and plays "correct answer" sound
                AudioServicesPlaySystemSound(currSoundID)
                
            } else {
                nextButton.setImage(UIImage(named: "next_round_fail"), forState: .Normal)
                showScoreButton.setImage(UIImage(named: "show_score_fail"), forState: .Normal)
                loadSound(soundFail, soundID: &currSoundID, type: "wav")    //Loads and plays "correct answer" sound
                AudioServicesPlaySystemSound(currSoundID)
            }
        }

        // if game has reached final around, hide next round button and review show final score button
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
       if let labelText = senderButton.titleLabel?.text {
            for item in roundQuiz.questions {
                if labelText == "\(item.title)\nby \(item.author)" {
                    return item.URL
                }
            }
        }
        return URL404
    }
    
    // given a origin and destination label, swaps their text fields
    
    func swapButtonTitles(origin: UIButton, dest: UIButton){
        let first = origin.attributedTitleForState(.Normal)
        let second = dest.attributedTitleForState(.Normal)
        origin.setAttributedTitle(second, forState: .Normal)
        dest.setAttributedTitle(first, forState: .Normal)
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
            q3BookButton.enabled = false
            q4BookButton.enabled = false

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
            q3BookButton.enabled = true
            q4BookButton.enabled = true
            
            timerLabel.hidden = true
            nextButton.hidden = false
            shakeTapLabel.text = "Tap books for more info"
        }
    }
    
    
    // Loads sound file at given path of given file type
    func loadSound(path:String, soundID: UnsafeMutablePointer<SystemSoundID>, type:String){
        let pathToSoundFile = NSBundle.mainBundle().pathForResource(path, ofType: type)
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, soundID)
    }
}

