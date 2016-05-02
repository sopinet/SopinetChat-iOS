//
//  SChatComposerTextView.swift
//  Pods
//
//  Created by David Moreno Lora on 2/5/16.
//
//

import UIKit
import Foundation

class SChatComposerTextView: UITextView {
    
    var placeHolder: String?
    
    var placeHolderTextColor: UIColor?
    
    // MARK: Initialization
    
    func sChatConfigureTextView()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let cornerRadius: CGFloat = 6.0
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.cornerRadius = cornerRadius
        
        self.scrollIndicatorInsets = UIEdgeInsetsMake(cornerRadius, 0.0, cornerRadius, 0.0)
        
        self.textContainerInset = UIEdgeInsetsMake(4.0, 2.0, 4.0, 2.0)
        self.contentInset = UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)
        
        self.scrollEnabled = true
        self.scrollsToTop = false
        self.userInteractionEnabled = true
        
        self.font = UIFont.systemFontOfSize(16.0)
        self.textColor = UIColor.blackColor()
        self.textAlignment = .Natural
        
        self.contentMode = .Redraw
        self.dataDetectorTypes = .None
        self.keyboardAppearance = .Default
        self.keyboardType = .Default
        self.returnKeyType = .Default
        
        self.text = ""
        
        self.placeHolder = ""
        self.placeHolderTextColor = UIColor.lightGrayColor()
        
        // TODO: We have to add notification observers right here
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.sChatConfigureTextView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.sChatConfigureTextView()
    }
    
    // MARK: Composer TextView
    
    override func hasText() -> Bool {
        return self.text.sChatStringByTrimingWhitespace().characters.count > 0
    }

}
