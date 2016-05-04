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
    @IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!
    
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
    
    public override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        self.sChatCollectionView.collectionViewLayout.invalidateLayout()
        
        // ...
        
        self.sChatUpdateKeyboardTriggerPoint()
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
    
    // MARK: Input Toolbar Utilities
    
    func sChatInputToolbarHasReachedMaximumHeight() -> Bool
    {
        return CGRectGetMinY(self.schatInputToolbar!.frame) == (self.topLayoutGuide.length + self.topContentAdditionalInset!)
    }
    
    func sChatAdjustInputToolbarForComposerTextViewContentSizeChange(var dy: CGFloat)
    {
        let contentSizeIsIncreasing = (dy > 0)
        
        if sChatInputToolbarHasReachedMaximumHeight() {
            let contentOffsetIsPositive = (self.schatInputToolbar.contentView?.contentTextView.contentOffset.y > 0)
            
            if contentSizeIsIncreasing || contentOffsetIsPositive {
                self.sChatScrollComposerTextViewToBottomAnimated(true)
                return
            }
        }
        
        let toolbarOriginY = CGRectGetMinY(self.schatInputToolbar.frame)
        let newToolbarOriginY = toolbarOriginY - dy
        
        if newToolbarOriginY <= self.topLayoutGuide.length + self.topContentAdditionalInset!
        {
            dy = toolbarOriginY - (self.topLayoutGuide.length + self.topContentAdditionalInset!)
            self.sChatScrollComposerTextViewToBottomAnimated(true)
        }
        
        self.sChatAdjustInputToolbarHeightConstraintByDelta(dy)
        
        self.sChatUpdateKeyboardTriggerPoint()
        
        if dy < 0 {
            self.sChatScrollComposerTextViewToBottomAnimated(false)
        }
    }
    
    func sChatAdjustInputToolbarHeightConstraintByDelta(dy: CGFloat)
    {
        let proposedHeight = self.toolbarHeightConstraint.constant + dy
        
        var finalHeight = max(proposedHeight, self.schatInputToolbar.preferredDefaultHeight)
        
        if self.schatInputToolbar.maximumHeight != NSNotFound {
            finalHeight = min(finalHeight, CGFloat(self.schatInputToolbar.maximumHeight))
        }
        
        if self.toolbarHeightConstraint.constant != finalHeight {
            self.toolbarHeightConstraint.constant = finalHeight
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
        }
    }
    
    func sChatScrollComposerTextViewToBottomAnimated(animated: Bool)
    {
        let textView = self.schatInputToolbar.contentView?.contentTextView
        
        let contentOffsetToShowLastLine = CGPointMake(0.0, textView!.contentSize.height - CGRectGetHeight(textView!.bounds))
        
        if !animated {
            textView?.contentOffset = contentOffsetToShowLastLine
            return
        }
        
        UIView.animateWithDuration(NSTimeInterval(0.01),
                                   delay: NSTimeInterval(0.01),
                                   options: UIViewAnimationOptions.CurveLinear,
            animations: {
                textView?.contentOffset = contentOffsetToShowLastLine
            }, completion: nil)
    }
    
    // MARK: Key-Value Observing
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if context == kSChatKeyboardControllerKeyValueObservingContext
        {
            if object!.isEqual(self.schatInputToolbar.contentView?.contentTextView)
                && keyPath == NSStringFromSelector(Selector("contentSize"))
            {
                let oldContentSize = change![NSKeyValueChangeOldKey] as! CGSize
                let newContentSize = change![NSKeyValueChangeNewKey] as! CGSize
                
                let dy = newContentSize.height - oldContentSize.height
                
                self.sChatAdjustInputToolbarForComposerTextViewContentSizeChange(dy)
                self.sChatUpdateCollectionViewInsets()
                
                /*if self.sChatAutomaticallyScrollToMostRecentMessage() {
                    self.scrollToBottomAnimated(false)
                }*/
            }
        }
    }
    
    // MARK: SChatKeyboardControllerDelegate
    
    public func keyboardDidChangeFrame(keyboardFrame: CGRect)
    {
        if !self.schatInputToolbar.contentView!.contentTextView.isFirstResponder() && self.toolbarBottomLayoutGuide.constant == 0.0 {
            return
        }
        
        var heightFromBottom = CGRectGetMaxY(self.sChatCollectionView.frame) - CGRectGetMinY(keyboardFrame)
        
        heightFromBottom = max(0.0, heightFromBottom)
        
        self.sChatSetToolbarBottomLayoutGuideConstant(heightFromBottom)
    }
    
    func sChatSetToolbarBottomLayoutGuideConstant(constant: CGFloat)
    {
        self.toolbarBottomLayoutGuide.constant = constant + self.schatInputToolbar.frame.height // 226 para probar
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
