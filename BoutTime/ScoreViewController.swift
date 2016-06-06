//
//  ScoreViewController.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 6/6/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    var questionsAsked = 0
    var questionsCorrect = 0
    
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        finalScoreLabel.text = "\(questionsCorrect)/\(questionsAsked)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playAgain(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        //reset game?
        //setQuestions(loadedQuiz)
        //displayChoices()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
   // }
   

}
