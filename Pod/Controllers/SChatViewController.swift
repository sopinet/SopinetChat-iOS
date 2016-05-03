//
//  SChatViewController.swift
//  Pods
//
//  Created by David Moreno Lora on 28/4/16.
//
//

import UIKit
import Foundation

public class SChatViewController: UIViewController, UITextViewDelegate, SChatInputToolbarDelegate, SChatKeyboardControllerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet public var schatview: UIView!
    @IBOutlet weak public var sChatCollectionView: UICollectionView!
    @IBOutlet weak public var schatInputToolbar: SChatInputToolbar!
    
    @IBOutlet weak var toolbarBottomLayoutGuide: NSLayoutConstraint!
    
    // MARK: Properties
    
    var keyboardController: SChatKeyboardController?
    var topContentAdditionalInset: CGFloat?
    var isObserving: Bool = false
    
    // MARK: Class methods
    
    public class func nib() -> UINib!
    {
        return UINib.init(nibName:"SChatViewController", bundle: NSBundle(forClass: self))
    }
    
    public class func sChatViewController() -> SChatViewController {
        return SChatViewController.init(nibName: "SChatViewController", bundle: NSBundle(forClass: self))
    }
    
    // MARK: Life-Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        SChatViewController.nib().instantiateWithOwner(self, options:nil)
        
        sChatConfigureSChatViewController()
        sChatRegisterForNotifications(true)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.sChatAddObservers()
        self.keyboardController?.beginListeningForKeyboard()
    }
    
    // MARK: Helpers
    
    func sChatConfigureSChatViewController()
    {
        self.schatInputToolbar.delegate = self
        self.schatInputToolbar.contentView?.contentTextView.delegate = self
        self.topContentAdditionalInset = CGFloat(0.0)
        
        if self.schatInputToolbar.contentView?.contentTextView != nil {
            self.keyboardController = SChatKeyboardController(textView: self.schatInputToolbar.contentView!.contentTextView,
                                                              contextView: self.view,
                                                                panGestureRecognizer: self.sChatCollectionView.panGestureRecognizer,
                                                                delegate: self)
        }
    }
    
    func setDelegates()
    {
        
    }
    
    // MARK: CollectionView Utilities
    
    func sChatUpdateCollectionViewInsets()
    {
        self.sChatSetCollectionViewInsets(self.topLayoutGuide.length + self.topContentAdditionalInset!,
                                             bottomValue: CGRectGetMaxY(self.sChatCollectionView.frame) - CGRectGetMinY(self.schatInputToolbar.frame))
    }
    
    func sChatSetCollectionViewInsets(topValue: CGFloat, bottomValue: CGFloat)
    {
        let insets = UIEdgeInsetsMake(topValue, 0.0, bottomValue, 0.0)
        self.sChatCollectionView.contentInset = insets
        self.sChatCollectionView.scrollIndicatorInsets = insets
    }
    
    // MARK: Utilities
    
    func sChatAddObservers()
    {
        if isObserving {
            return
        }
        
        self.schatInputToolbar.contentView?.contentTextView.addObserver(self,
                                                                        forKeyPath: NSStringFromSelector(Selector("contentSize")),
                                                                        options: [NSKeyValueObservingOptions.Old, NSKeyValueObservingOptions.New],
                                                                        context: kSChatKeyboardControllerKeyValueObservingContext)
        
        self.isObserving = true
    }
    
    func sChatRemoveObservers()
    {
        if !isObserving {
            return
        }
        
        do {
            try self.schatInputToolbar.contentView?.contentTextView.removeObserver(self,
                                                                               forKeyPath: NSStringFromSelector(Selector("contentSize")),
                                                                                context: kSChatKeyboardControllerKeyValueObservingContext)
        } catch {}
        
        self.isObserving = false
    }
    
    func sChatRegisterForNotifications(registerForNotifications: Bool)
    {
        if registerForNotifications
        {
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(self.sChatHandleDidChangeStatusBarFrameNotification(_:)),
                                                             name: UIApplicationDidChangeStatusBarFrameNotification,
                                                             object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(self.sChatDidReceiveMenuWillShowNotification(_:)),
                                                             name: UIMenuControllerWillShowMenuNotification,
                                                             object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(self.sChatDidReceiveMenuWillHideNotification(_:)),
                                                             name: UIMenuControllerWillHideMenuNotification,
                                                             object: nil)
        }
        else
        {
            NSNotificationCenter.defaultCenter().removeObserver(self,
                                                             name: UIApplicationDidChangeStatusBarFrameNotification,
                                                             object: nil)
            
            NSNotificationCenter.defaultCenter().removeObserver(self,
                                                             name: UIMenuControllerWillShowMenuNotification,
                                                             object: nil)
            
            NSNotificationCenter.defaultCenter().removeObserver(self,
                                                             name: UIMenuControllerWillHideMenuNotification,
                                                             object: nil)
        }
    }
    
    func sChatAddActionsToInteractivePopGestureRecognizer(addAction: Bool)
    {
        // ...
    }
    
    // MARK: TextView Delegate
    
    public func textViewDidBeginEditing(textView: UITextView)
    {
        if textView != self.schatInputToolbar.contentView?.contentTextView {
            return
        }
        
        textView.becomeFirstResponder()
    }
    
    public func textViewDidChange(textView: UITextView)
    {
        if textView != self.schatInputToolbar.contentView?.contentTextView {
            return
        }
        
        self.schatInputToolbar.toogleSendButtonEnabled()
    }
    
    public func textViewDidEndEditing(textView: UITextView)
    {
        if textView != self.schatInputToolbar.contentView?.contentTextView {
            return
        }
        
        textView.resignFirstResponder()
    }
    
    // MARK: Notifications
    
    func sChatHandleDidChangeStatusBarFrameNotification(notification: NSNotification)
    {
        if self.keyboardController?.keyboardIsVisible() != nil{
            self.sChatSetToolbarBottomLayoutGuideConstant(CGRectGetHeight(self.keyboardController!.currentKeyboardFrame()))
        }
    }
    
    func sChatDidReceiveMenuWillShowNotification(notification: NSNotification)
    {
        // ...
    }
    
    func sChatDidReceiveMenuWillHideNotification(notification: NSNotification)
    {
        // ...
    }
    
    // MARK: SChatKeyboardControllerDelegate
    
    public func keyboardDidChangeFrame(keyboardFrame: CGRect)
    {
        if self.schatInputToolbar.contentView!.contentTextView.isFirstResponder() && self.toolbarBottomLayoutGuide.constant == 0.0 {
            return
        }
        
        var heightFromBottom = CGRectGetMaxY(self.sChatCollectionView.frame) - CGRectGetMinY(keyboardFrame)
        
        heightFromBottom = max(0.0, heightFromBottom)
        
        self.sChatSetToolbarBottomLayoutGuideConstant(heightFromBottom)
    }
    
    func sChatSetToolbarBottomLayoutGuideConstant(constant: CGFloat)
    {
        self.toolbarBottomLayoutGuide.constant = constant // 226 para probar
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        
        self.sChatUpdateCollectionViewInsets()
    }
    
    func sChatUpdateKeyboardTriggerPoint()
    {
        self.keyboardController!.keyboardTriggerPoint = CGPointMake(0.0, CGRectGetHeight(self.schatInputToolbar.bounds))
    }
    
    // MARK: SChatInputToolbarDelegate
    
    func attachButtonTapped(sender: AnyObject) {
        
    }
    
    func sendButtonTapped(sender: AnyObject) {
        
    }
}
