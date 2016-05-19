//
//  SChatViewController.swift
//  Pods
//
//  Created by David Moreno Lora on 28/4/16.
//
//

import UIKit
import Foundation

public class SChatViewController: UIViewController, UITextViewDelegate, SChatInputToolbarDelegate, SChatKeyboardControllerDelegate, SChatCollectionViewDataSource, SChatCollectionViewDelegateFlowLayout {
    
    // MARK: Outlets
    
    @IBOutlet public var schatview: UIView!
    @IBOutlet weak public var sChatCollectionView: SChatCollectionView!
    @IBOutlet weak public var schatInputToolbar: SChatInputToolbar!
    
    @IBOutlet weak var toolbarBottomLayoutGuide: NSLayoutConstraint!
    @IBOutlet weak var toolbarHeightConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    
    var keyboardController: SChatKeyboardController?
    var topContentAdditionalInset: CGFloat?
    var isObserving: Bool = false
    var textViewWasFirstResponderDuringInteractivePop: Bool = false
    var currentInteractivePopGestureRecognizer: UIGestureRecognizer? = nil
    var selectedIndexPathForMenu: NSIndexPath?
    
    public var senderDisplayName: String
    
    public var senderId: String
    
    var automaticallyScrollsToMostRecentMessage: Bool = true
    
    var outgoingCellIdentifier: String = ""
    
    var outgoingMediaCellIdentifier: String = ""
    
    var incomingCellIdentifier: String = ""
    
    var incomingMediaCellIdentifier: String = ""
    
    var showTypingIndicator: Bool = true
    
    var showLoadEarlierMessagesHeader: Bool = false
    
    // MARK: Class methods
    
    public class func nib() -> UINib!
    {
        return UINib.init(nibName:"SChatViewController", bundle: NSBundle(forClass: self))
    }
    
    public class func sChatViewController() -> SChatViewController {
        return SChatViewController.init(nibName: "SChatViewController", bundle: NSBundle(forClass: self))
    }
    
    // MARK: Life-Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        SChatViewController.nib().instantiateWithOwner(self, options:nil)
        
        sChatConfigureSChatViewController()
        sChatRegisterForNotifications(true)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.sChatAddObservers()
        self.sChatAddActionsToInteractivePopGestureRecognizer(true)
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
    
    public override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.sChatAddActionsToInteractivePopGestureRecognizer(false)
        self.sChatRemoveObservers()
        self.keyboardController?.endListeningForKeyboard()
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
    
    func sChatIsMenuVisible() -> Bool
    {
        return self.selectedIndexPathForMenu != nil && UIMenuController.sharedMenuController().menuVisible
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
        if self.currentInteractivePopGestureRecognizer != nil
        {
            self.currentInteractivePopGestureRecognizer?.removeTarget(nil,
                                                                      action: #selector(sChatHandleInteractivePopGestureRecognizer(_:)))
            self.currentInteractivePopGestureRecognizer = nil
        }
        
        if addAction
        {
            self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(sChatHandleInteractivePopGestureRecognizer(_:)))
            
            self.currentInteractivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer
        }
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
        
        self.schatInputToolbar.toggleSendButtonEnabled()
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
        if self.keyboardController!.keyboardIsVisible(){
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
    
    // MARK: Gesture recognizers
    
    func sChatHandleInteractivePopGestureRecognizer(gestureRecognizer: UIGestureRecognizer)
    {
        switch gestureRecognizer.state {
        case .Began:
            self.textViewWasFirstResponderDuringInteractivePop = self.schatInputToolbar.contentView!.contentTextView.isFirstResponder()
            
            self.keyboardController?.endListeningForKeyboard()
        case .Changed:
            break
        case .Cancelled,
             .Ended,
             .Failed:
            self.keyboardController?.beginListeningForKeyboard()
            
            if self.textViewWasFirstResponderDuringInteractivePop
            {
                self.schatInputToolbar.contentView!.contentTextView.becomeFirstResponder()
            }
        default:
            break
        }
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
                let oldContentSize: CGSize = change![NSKeyValueChangeOldKey]!.CGSizeValue()
                let newContentSize: CGSize = change![NSKeyValueChangeNewKey]!.CGSizeValue()
                
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
        self.toolbarBottomLayoutGuide.constant = constant
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
    
    // TODO: View rotation methods
    
    // MARK: SChat Messages View Controller
    
    func didPressSendButton(button: UIButton,
                            withMessageText text: String,
                                            senderId senderId: String,
                                                     senderDisplayName senderDisplayName: String,
                                                                       date date: NSDate)
    {
        assert(false, "Error! required method not implemented in subclass. Need to implement")
    }
    
    func didPressAccesoryButton(sender: UIButton)
    {
        assert(false, "Error! required method not implemented in subclass. Need to iplement")
    }
    
    func finishSendingMessage()
    {
        self.finishSendingMessageAnimated(true)
    }
    
    func finishSendingMessageAnimated(animated: Bool)
    {
        let textView = self.schatInputToolbar.contentView?.contentTextView
        textView!.text = nil
        textView?.undoManager?.removeAllActions()
        
        self.schatInputToolbar.toggleSendButtonEnabled()
        
        NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: textView!)
        
        self.sChatCollectionView.collectionViewLayoutInterceptor?.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
        
        self.sChatCollectionView.reloadData()
        
        if self.automaticallyScrollsToMostRecentMessage
        {
            self.scrollToBottomAnimated(animated)
        }
    }
    
    func finishReceivingMessage()
    {
        self.finishReceivingMessageAnimated(true)
    }
    
    func finishReceivingMessageAnimated(animated: Bool)
    {
        self.showTypingIndicator = false
        
        self.sChatCollectionView.collectionViewLayoutInterceptor?.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
        
        self.sChatCollectionView.reloadData()
        
        if self.automaticallyScrollsToMostRecentMessage && self.sChatIsMenuVisible()
        {
            self.scrollToBottomAnimated(true)
        }
    }
    
    func scrollToBottomAnimated(animated: Bool)
    {
        if self.sChatCollectionView.numberOfSections() == 0
        {
            return
        }
        
        let items = self.sChatCollectionView.numberOfItemsInSection(0)
        
        if items == 0
        {
            return
        }
        
        let collectionViewContentHeight = self.sChatCollectionView.collectionViewLayoutInterceptor?.collectionViewContentSize().height
        
        let isContentTooSmall = collectionViewContentHeight < CGRectGetHeight(self.sChatCollectionView.bounds)
        
        if isContentTooSmall
        {
            self.sChatCollectionView.scrollRectToVisible(CGRectMake(0.0,
                collectionViewContentHeight! - 1.0,
                1.0,
                1.0),
                                                         animated: animated)
            
            return
        }
        
        let finalRow = max(0, self.sChatCollectionView.numberOfItemsInSection(0) - 1)
        
        let finalIndexPath = NSIndexPath(forRow:finalRow, inSection: 0)
        
        let finalCellSize = self.sChatCollectionView.collectionViewLayoutInterceptor?.sizeForItemAtIndexPath(finalIndexPath)
        
        let maxHeightForVisibleMessage = CGRectGetHeight(self.sChatCollectionView.bounds) - self.sChatCollectionView.contentInset.top - CGRectGetHeight(self.schatInputToolbar.bounds)
        
        let scrollPosition = finalCellSize!.height > maxHeightForVisibleMessage ? UICollectionViewScrollPosition.Bottom : UICollectionViewScrollPosition.Top
        
        self.sChatCollectionView.scrollToItemAtIndexPath(finalIndexPath,
                                                         atScrollPosition: scrollPosition,
                                                         animated: animated)
    }
    
    // MARK: SChat CollectionView Data Source
}
