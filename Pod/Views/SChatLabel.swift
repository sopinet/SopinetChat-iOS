//
//  SChatLabel.swift
//  Pods
//
//  Created by David Moreno Lora on 15/5/16.
//
//

import UIKit

public class SChatLabel: UILabel
{
    // MARK: Properties
    
    private var _textInsets: UIEdgeInsets? = UIEdgeInsetsZero
    var textInsets: UIEdgeInsets? {
        set {
            if !UIEdgeInsetsEqualToEdgeInsets(_textInsets!, newValue!) {
                _textInsets = newValue!
                self.setNeedsDisplay()
            }
        }
        get {return _textInsets}
    }
    
    // MARK: Initialization
    
    func sChatConfigureLabel()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textInsets = UIEdgeInsetsZero
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        sChatConfigureLabel()
    }
    
    required public init?(coder: NSCoder)
    {
        super.init(coder: coder)
        sChatConfigureLabel()
    }
    
    // MARK: Drawing
    
    override public func drawTextInRect(rect: CGRect)
    {
        super.drawTextInRect(CGRectMake(CGRectGetMinX(rect) + self.textInsets!.left,
            CGRectGetMinY(rect) + self.textInsets!.top,
            CGRectGetWidth(rect) - self.textInsets!.right,
            CGRectGetHeight(rect) - self.textInsets!.bottom))
    }
}
