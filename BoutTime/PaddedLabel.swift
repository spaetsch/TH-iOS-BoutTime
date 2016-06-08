//
//  PaddedLabel.swift
//  BoutTime
//
//  Created by Sarah Paetsch on 6/8/16.
//  Copyright © 2016 Sarah Paetsch. All rights reserved.
//  Adapted from: http://stackoverflow.com/questions/32239457/how-do-you-add-inset-to-uilabel-ios-swift
//

import UIKit

class PaddedLabel: UILabel {

    let topInset = CGFloat(0), bottomInset = CGFloat(0), leftInset = CGFloat(20.0), rightInset = CGFloat(20.0)
    
    override func drawTextInRect(rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
