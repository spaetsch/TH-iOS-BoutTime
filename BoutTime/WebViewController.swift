//
//  WebViewController.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 6/8/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var webViewURL = "https://en.wikipedia.org/wiki/HTTP_404"
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let requestURL = NSURL(string: webViewURL)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
//    @IBAction func dismissWebView(sender: AnyObject) {
//        dismissViewControllerAnimated(true, completion: nil)
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
