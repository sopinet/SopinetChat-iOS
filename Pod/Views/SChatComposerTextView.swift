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
    
    var placeHolder: String = NSBundle.sChatLocalizedStringForKey("schat_new_message")
    
    var placeHolderTextColor: UIColor = UIColor.lightGrayColor()
    
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
        
        self.sChatAddTextViewNotificationObservers()
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
    
    func setComposerText(text: String)
    {
        self.text = text
        self.setNeedsDisplay()
    }
    
    func setComposerFont(font: UIFont)
    {
        self.font = font
        self.setNeedsDisplay()
    }
    
    func setComposerTextAlignment(textAlignment: NSTextAlignment)
    {
        self.textAlignment = textAlignment
        self.setNeedsDisplay()
    }
    
    // MARK: Setters
    
    func setComposerPlaceHolder(placeHolder: String)
    {
        if placeHolder == self.placeHolder {
            return
        }
        
        self.placeHolder = placeHolder
        self.setNeedsDisplay()
    }
    
    func setComposerPlaceHolderTextColor(placeHolderTextColor: UIColor)
    {
        if placeHolderTextColor == self.placeHolderTextColor {
            return
        }
        
        self.placeHolderTextColor = placeHolderTextColor
        self.setNeedsDisplay()
    }
    
    // MARK: Drawing
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        
        if self.text.characters.count == 0
        {
            self.placeHolderTextColor.set()
            
            self.placeHolder.drawInRect(CGRectInset(rect, 7.0, 4.0),
                                         withAttributes: self.sChatPlaceHolderTextAttributes() as! [String : AnyObject])
        }
    }
    
    // MARK: Utils
    
    func sChatPlaceHolderTextAttributes() -> NSDictionary
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        paragraphStyle.alignment = self.textAlignment
        
        return [NSFontAttributeName : self.font!,
                NSForegroundColorAttributeName: self.placeHolderTextColor,
                NSParagraphStyleAttributeName: paragraphStyle]
    }
    
    // MARK: Notifications
    
    func sChatAddTextViewNotificationObservers()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sChatDidReceiveTextViewNotification(_:)), name: UITextViewTextDidChangeNotification, object: self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sChatDidReceiveTextViewNotification(_:)), name: UITextViewTextDidBeginEditingNotification, object: self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.sChatDidReceiveTextViewNotification(_:)), name: UITextViewTextDidEndEditingNotification, object: self)
    }
    
    func sChatRemoveTextViewNotificationObservers()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidBeginEditingNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidEndEditingNotification, object: nil)
    }
    
    func sChatDidReceiveTextViewNotification(notification: NSNotification)
    {
        self.setNeedsDisplay()
    }

}
