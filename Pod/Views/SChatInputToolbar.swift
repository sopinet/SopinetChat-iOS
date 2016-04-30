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
    
    override public var delegate: UIToolbarDelegate? {
        didSet {
            if delegate != nil {
                let castedDelegate = unsafeBitCast(delegate, SChatInputToolbarDelegate.self)
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
        let toolbarView: SChatToolbarView = loadToolbarView()
        
        toolbarView.frame = self.frame
        
        self.addSubview(toolbarView)
        self.contentView = toolbarView
        
        self.contentView?.leftBarButtomItem = SChatToolbarButtonFactory.defaultAccessoryButtonItem()
        self.contentView?.rightBarButtomItem = SChatToolbarButtonFactory.defaultSendButtonItem()
        
        if let auxLeftBarButtomItem = self.contentView?.leftBarButtomItem
        {
            self.contentView?.leftButtonView.addSubview(auxLeftBarButtomItem)
            auxLeftBarButtomItem.addTarget(self, action: #selector(sChatLeftButtonTapped(_:)), forControlEvents: .TouchUpInside)
        }
        
        if let auxRightBarButtomItem = self.contentView?.rightBarButtomItem
        {
            self.contentView?.leftButtonView.addSubview(auxRightBarButtomItem)
            auxRightBarButtomItem.addTarget(self, action: #selector(sChatRightButtonTapped(_:)), forControlEvents: .TouchUpInside)
        }
        
        toogleSendButtonEnabled()
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
    
    func toogleSendButtonEnabled()
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
