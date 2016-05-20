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
    @IBOutlet weak var contentTextView: SChatComposerTextView!
    @IBOutlet weak var rightButtonView: UIView!
    
    // MARK: Actions
    
    
    // MARK: Properties
    
    weak var leftBarButtonItem: UIButton? {
        didSet
        {
            if leftBarButtonItem != nil {
                leftBarButtonItem?.removeFromSuperview()
            }
            
            // TODO: Improve this to allow developers remove this button
            
            if let auxLeftBarButtomItem = leftBarButtonItem
            {
                if CGRectEqualToRect(auxLeftBarButtomItem.frame, CGRectZero)
                {
                    auxLeftBarButtomItem.frame = leftButtonView.bounds
                }
            }
            
            leftButtonView.hidden = false
            
            leftBarButtonItem?.translatesAutoresizingMaskIntoConstraints = false
            
            leftButtonView.backgroundColor = UIColor.clearColor()
            leftButtonView.addSubview(leftBarButtonItem!)
            leftButtonView.sChatPinAllEdgesOfSubview(leftBarButtonItem!)
            self.setNeedsUpdateConstraints()
        }
    }
    
    weak var rightBarButtonItem: UIButton? {
        didSet
        {
            if rightBarButtonItem != nil {
                rightBarButtonItem?.removeFromSuperview()
            }
            
            if let auxRightBarButtonItem = rightBarButtonItem
            {
                if CGRectEqualToRect(auxRightBarButtonItem.frame, CGRectZero)
                {
                    auxRightBarButtonItem.frame = rightButtonView.bounds
                }
            }
            
            rightButtonView.hidden = false
            
            rightBarButtonItem?.translatesAutoresizingMaskIntoConstraints = false
            
            rightButtonView.backgroundColor = UIColor.clearColor()
            rightButtonView.addSubview(rightBarButtonItem!)
            rightButtonView.sChatPinAllEdgesOfSubview(rightBarButtonItem!)
            self.setNeedsUpdateConstraints()
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: UIView overrides
    
    public override func setNeedsDisplay() {
        super.setNeedsDisplay()
    }
}
