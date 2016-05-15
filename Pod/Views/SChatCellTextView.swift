//
//  SChatCellTextView.swift
//  Pods
//
//  Created by David Moreno Lora on 13/5/16.
//
//

import UIKit

class SChatCellTextView: UITextView
{
    // MARK: Initializers
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        
    }
    
    required public init?(coder: NSCoder)
    {
        super.init(coder: coder)
        
        self.textColor = UIColor.whiteColor()
        self.editable = false
        self.selectable = true
        self.userInteractionEnabled = true
        self.dataDetectorTypes = UIDataDetectorTypes.None
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollEnabled = false
        self.backgroundColor = UIColor.clearColor()
        self.contentInset = UIEdgeInsetsZero
        self.scrollIndicatorInsets = UIEdgeInsetsZero
        self.contentOffset = CGPointZero
        self.textContainerInset = UIEdgeInsetsZero
        self.textContainer.lineFragmentPadding = 0
        self.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                   NSUnderlineStyleAttributeName: [NSUnderlineStyle.StyleSingle.rawValue, NSUnderlineStyle.PatternSolid.rawValue]]
    }
    
    // MARK: Functions
    
    // TODO: Prevent selecting text
    
    // override selectedRange
    
    // ..
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        if gestureRecognizer.isKindOfClass(UITapGestureRecognizer)
        {
            let tap: UITapGestureRecognizer = gestureRecognizer as! UITapGestureRecognizer
            
            if tap.numberOfTapsRequired == 2
            {
                return false
            }
        }
        
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
    {
        if gestureRecognizer.isKindOfClass(UITapGestureRecognizer)
        {
            let tap: UITapGestureRecognizer = gestureRecognizer as! UITapGestureRecognizer
            
            if tap.numberOfTapsRequired == 2
            {
                return false
            }
        }
        
        return true
    }
}
