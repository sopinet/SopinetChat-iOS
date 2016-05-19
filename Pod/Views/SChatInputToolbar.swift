//
//  SChatInputToolbar.swift
//  Pods
//
//  Created by David Moreno Lora on 29/4/16.
//
//

import Foundation
import UIKit

public class SChatInputToolbar: UIToolbar {

    // MARK: Properties
    
    weak var inputToolbarDelegate : SChatInputToolbarDelegate?
    
    var preferredDefaultHeight: CGFloat = 44.0
    var maximumHeight: Int = NSNotFound
    
    override public var delegate: UIToolbarDelegate? {
        didSet {
            if delegate != nil {
                //let castedDelegate = unsafeBitCast(delegate, SChatInputToolbarDelegate.self)
                let castedDelegate: SChatInputToolbarDelegate = delegate as! SChatInputToolbarDelegate
                inputToolbarDelegate = castedDelegate
            }
            else {
                inputToolbarDelegate = nil
            }
        }
    }
    
    var contentView: SChatToolbarView?
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    // MARK: Functions
    
    func loadToolbarView() -> SChatToolbarView
    {
        return NSBundle(forClass: SChatToolbarView.self).loadNibNamed("SChatToolbarView",
                                                  owner: self, options: nil)[0] as! SChatToolbarView
    }
    
    func setUp()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbarView: SChatToolbarView = loadToolbarView()
        
        toolbarView.frame = self.frame
        
        self.addSubview(toolbarView)
        sChatPinAllEdgesOfSubview(toolbarView)
        self.setNeedsUpdateConstraints()
        
        self.contentView = toolbarView
        
        self.contentView?.leftBarButtomItem = SChatToolbarButtonFactory.defaultAccessoryButtonItem()
        self.contentView?.rightBarButtomItem = SChatToolbarButtonFactory.defaultSendButtonItem()
        
        toogleSendButtonEnabled()
    }
    
    // MARK: Setters
    
    func sChatSetPreferredDefaultHeight(preferredDefaultHeight: CGFloat)
    {
        self.preferredDefaultHeight = preferredDefaultHeight
    }
    
    // MARK: Actions
    
    func sChatLeftButtonTapped(sender: AnyObject)
    {
        self.inputToolbarDelegate?.attachButtonTapped(sender)
    }
    
    func sChatRightButtonTapped(sender: AnyObject)
    {
        self.inputToolbarDelegate?.sendButtonTapped(sender)
    }
    
    // MARK: Input Toolbar functions
    
    func toggleSendButtonEnabled()
    {
        if let auxContentView = self.contentView
        {
            let hasText = auxContentView.contentTextView.hasText()
            
            if let auxRightBarButtonItem = auxContentView.rightBarButtomItem {
                auxRightBarButtonItem.enabled = hasText
            }
        }
    }
    
    func addTapGestureRecognizers()
    {
        
    }
}
