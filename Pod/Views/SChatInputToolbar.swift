//
//  SChatInputToolbar.swift
//  Pods
//
//  Created by David Moreno Lora on 29/4/16.
//
//

import Foundation
import UIKit

class SChatInputToolbar: UIToolbar {

    // MARK: Properties
    
    weak var inputToolbarDelegate : SChatInputToolbarDelegate?
    
    override var delegate: UIToolbarDelegate? {
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    // MARK: Functions
    
    func loadToolbarView() -> SChatToolbarView
    {
        return NSBundle.mainBundle().loadNibNamed("SChatToolbarView",
                                                  owner: self, options: nil)[0] as! SChatToolbarView
    }
    
    func setUp()
    {
        let toolbarView: SChatToolbarView = loadToolbarView()
        
        toolbarView.frame = self.frame
        
        self.addSubview(toolbarView)
        self.contentView = toolbarView
        
        self.contentView?.leftButtonVIew = SChatToolbarButtonFactory.defaultAccessoryButtonItem()
        self.contentView?.rightButtonView = SChatToolbarButtonFactory.defaultSendButtonItem()
        
        toogleSendButtonEnabled()
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
}
