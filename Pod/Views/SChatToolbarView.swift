//
//  SChatToolbarView.swift
//  Pods
//
//  Created by David Moreno Lora on 28/4/16.
//
//

import UIKit

public class SChatToolbarView: UIView {

    // MARK: Outlets
    
    @IBOutlet weak var leftButtonView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var rightButtonView: UIView!
    
    // MARK: Actions
    
    
    // MARK: Properties
    
    weak var leftBarButtomItem: UIButton? {
        didSet
        {
            if leftBarButtomItem != nil {
                leftBarButtomItem?.removeFromSuperview()
            }
            
            // TODO: Improve this to allow developers remove this button
            
            if let auxLeftBarButtomItem = leftBarButtomItem
            {
                if CGRectEqualToRect(auxLeftBarButtomItem.frame, CGRectZero)
                {
                    auxLeftBarButtomItem.frame = leftButtonView.bounds
                }
            }
            
            leftButtonView.hidden = false
            
            leftBarButtomItem?.translatesAutoresizingMaskIntoConstraints = false
            
            leftButtonView.backgroundColor = UIColor.clearColor()
            leftButtonView.addSubview(leftBarButtomItem!)
            leftButtonView.sChatPinAllEdgesOfSubview(leftBarButtomItem!)
            self.setNeedsUpdateConstraints()
        }
    }
    
    weak var rightBarButtomItem: UIButton? {
        didSet
        {
            if rightBarButtomItem != nil {
                rightBarButtomItem?.removeFromSuperview()
            }
            
            if let auxRightBarButtonItem = rightBarButtomItem
            {
                if CGRectEqualToRect(auxRightBarButtonItem.frame, CGRectZero)
                {
                    auxRightBarButtonItem.frame = rightButtonView.bounds
                }
            }
            
            rightButtonView.hidden = false
            
            rightBarButtomItem?.translatesAutoresizingMaskIntoConstraints = false
            
            rightButtonView.backgroundColor = UIColor.clearColor()
            rightButtonView.addSubview(rightBarButtomItem!)
            rightButtonView.sChatPinAllEdgesOfSubview(rightBarButtomItem!)
            self.setNeedsUpdateConstraints()
            
            print("RIGHT BUTTON VIEW FRAME: \(rightButtonView.frame) - RIGHT BUTTON ITEM FRAME: \(rightBarButtomItem?.frame)")
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
