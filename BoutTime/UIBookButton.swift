//
//  UIBookButton.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 6/14/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//

import UIKit

class UIBookButton: UIButton {
    
    var bookTitle: String
    var bookAuthor: String
    
    
    required init?(coder aDecoder: NSCoder) {
        self.bookAuthor = ""
        self.bookTitle = ""

        super.init(coder: aDecoder)
        
        
        self.setTitle("\(bookTitle)\nby \(bookAuthor)", forState: .Normal)
        //self.setAttributedTitle(title: NSAttributedString?, forState: <#T##UIControlState#>)

        
        
        self.layer.cornerRadius = 10.0;
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        
    }
    
    
//    var bookTitleLabel: UILabel
//    
//    init(bookTitleLabel: UILabel){
//        self.bookTitleLabel = bookTitleLabel
//    }
    
 
    
    // bookLabel.text is always bold 16 pt
    // authorLabel.text always normal 14pt
    // need to pad and center

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


