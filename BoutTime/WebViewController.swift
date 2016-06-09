//
//  WebViewController.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 6/8/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var URL = "apple.com"
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("where did i blow up view did load")

        // Do any additional setup after loading the view.
        let requestURL = NSURL(string:URL)
        let request = NSURLRequest(URL: requestURL!)
        print("set constants then try to load request")
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissWebView(sender: AnyObject) {
        print("butt")
        print(URL)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    @IBAction func dismissWebView(sender: AnyObject) {
//        dismissViewControllerAnimated(true, completion: nil)
//
//    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
