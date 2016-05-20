//
//  SChatInputToolbar.swift
//  Pods
//
//  Created by David Moreno Lora on 29/4/16.
//
//

import Foundation
import UIKit

let kSChatInputToolbarKeyValueObservingContext = UnsafeMutablePointer<()>()

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
    
    //var sChatIsObserving: Bool = false
    
    // MARK: Initializers
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //setUp()
    }
    
    deinit
    {
        // remove observers
        self.contentView = nil
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
        
        //self.sChatIsObserving = false
        
        self.preferredDefaultHeight = 44.0
        self.maximumHeight = NSNotFound
        
        let toolbarView: SChatToolbarView = loadToolbarView()
        
        toolbarView.frame = self.frame
        
        self.addSubview(toolbarView)
        sChatPinAllEdgesOfSubview(toolbarView)
        self.setNeedsUpdateConstraints()
        
        self.contentView = toolbarView
        
        self.contentView?.leftBarButtonItem = SChatToolbarButtonFactory.defaultAccessoryButtonItem()
        self.contentView?.rightBarButtonItem = SChatToolbarButtonFactory.defaultSendButtonItem()
        
        toggleSendButtonEnabled()
        
        self.sChatAddObservers()
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
            
            if let auxRightBarButtonItem = auxContentView.rightBarButtonItem {
                auxRightBarButtonItem.enabled = hasText
            }
        }
    }
    
    // MARK: Key-value observing
    
    /*public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        
        if context == kSChatInputToolbarKeyValueObservingContext
        {
            if object!.isEqual(self.contentView)
            {
                if keyPath == NSStringFromSelector(Selector("leftBarButtonItem"))
                {
                    self.contentView?.leftBarButtonItem?.removeTarget(self,
                                                                      action: nil,
                                                                      forControlEvents: UIControlEvents.TouchUpInside)
                    
                    self.contentView?.leftBarButtonItem?.addTarget(self,
                                                                   action: #selector(self.sChatLeftButtonTapped(_:)),
                                                                   forControlEvents: UIControlEvents.TouchUpInside)
                }
                else if keyPath == NSStringFromSelector(Selector("rightBarButtonItem"))
                {
                    self.contentView?.rightBarButtonItem?.removeTarget(self,
                                                                      action: nil,
                                                                      forControlEvents: UIControlEvents.TouchUpInside)
                    
                    self.contentView?.rightBarButtonItem?.addTarget(self,
                                                                   action: #selector(self.sChatRightButtonTapped(_:)),
                                                                   forControlEvents: UIControlEvents.TouchUpInside)
                }
                
                self.toggleSendButtonEnabled()
            }
        }
    }*/
    
    func sChatAddObservers()
    {
        self.contentView?.leftBarButtonItem?.addTarget(self,
                                                       action: #selector(self.sChatLeftButtonTapped(_:)),
                                                       forControlEvents: UIControlEvents.TouchUpInside)
        
        self.contentView?.rightBarButtonItem?.addTarget(self,
                                                        action: #selector(self.sChatRightButtonTapped(_:)),
                                                        forControlEvents: UIControlEvents.TouchUpInside)
        /*if self.sChatIsObserving
        {
            return
        }
        
        self.contentView?.addObserver(self,
                                      forKeyPath: "leftBarButtonItem",
                                        options: [NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old],
                                        context: kSChatInputToolbarKeyValueObservingContext)
        
        self.contentView?.addObserver(self,
                                      forKeyPath: NSStringFromSelector(Selector("rightBarButtonItem")),
                                      options: NSKeyValueObservingOptions.New,
                                      context: kSChatInputToolbarKeyValueObservingContext)
        
        self.sChatIsObserving = true*/
    }
    
    func sChatRemoveObservers()
    {
        /*if !sChatIsObserving
        {
            return
        }
        
        self.contentView?.removeObserver(self,
                                         forKeyPath: NSStringFromSelector(Selector("leftBarButtomItem")),
                                         context: kSChatInputToolbarKeyValueObservingContext)
        
        self.contentView?.removeObserver(self,
                                         forKeyPath: NSStringFromSelector(Selector("rightBarButtomItem")),
                                         context: kSChatInputToolbarKeyValueObservingContext)
        
        self.sChatIsObserving = false*/
    }
}
