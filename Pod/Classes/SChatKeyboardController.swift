//
//  SChatKeyboardController.swift
//  Pods
//
//  Created by David Moreno Lora on 3/5/16.
//
//

import Foundation
import UIKit

let kSChatKeyboardControllerKeyValueObservingContext = UnsafeMutablePointer<()>()

//self.addObserver(self, forKeyPath: …, options: nil, context: kSChatKeyboardControllerKeyValueObservingContext)

/*override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>) {
    if context == kSChatKeyboardControllerKeyValueObservingContext {
        …
    } else {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
}*/

public class SChatKeyboardController : NSObject
{
    // MARK: Properties
    
    weak var delegate: SChatKeyboardControllerDelegate?
    
    let textView: UITextView
    
    let contextView: UIView
    
    let panGestureRecognizer: UIPanGestureRecognizer
    
    var keyboardTriggerPoint: CGPoint? = nil
    
    var isObserving: Bool
    
    var keyboardView: UIView?
    
    let SChatKeyboardControllerNotificationKeyboardDidChangeFrame = "SChatKeyboardControllerNotificationKeyboardDidChangeFrame"
    
    let SChatKeyboardControllerUserInfoKeyKeyboardDidChangeFrame = "SChatKeyboardControllerUserInfoKeyKeyboardDidChangeFrame"
    
    // MARK: Initializers
    
    init(textView: UITextView,
         contextView: UIView,
         panGestureRecognizer: UIPanGestureRecognizer,
         delegate: SChatKeyboardControllerDelegate)
    {
        self.textView = textView
        self.contextView = contextView
        self.panGestureRecognizer = panGestureRecognizer
        self.delegate = delegate
        self.isObserving = false
    }
    
    // MARK: Setters
    
    func setKeyboardControllerView(keyboardView: UIView)
    {
        if self.keyboardView != nil
        {
            self.sChatRemoveKeyboardFrameObserver()
        }
        
        self.keyboardView = keyboardView
        
        if !self.isObserving
        {
            self.keyboardView?.addObserver(self,
                                           forKeyPath: NSStringFromSelector(Selector("frame")),
                                           options: [NSKeyValueObservingOptions.Old, NSKeyValueObservingOptions.New],
                                           context: kSChatKeyboardControllerKeyValueObservingContext)
            self.isObserving = true
        }
    }
    
    // MARK: Getters
    
    func keyboardIsVisible() -> Bool
    {
        return self.keyboardView != nil
    }
    
    func currentKeyboardFrame() -> CGRect
    {
        if !self.keyboardIsVisible()
        {
            return CGRectNull
        }
        
        return self.keyboardView!.frame
    }
    
    // MARK: Keyboard Controller
    
    func beginListeningForKeyboard()
    {
        if self.textView.inputAccessoryView == nil {
            self.textView.inputAccessoryView = UIView()
        }
        
        self.sChatRegisterForNotifications()
    }
    
    func endListeningForKeyboard()
    {
        self.sChatUnregisterForNotifications()
        
        self.sChatSetKeyboardViewHidden(false)
        self.keyboardView = nil
    }
    
    // MARK: Notifications
    
    func sChatRegisterForNotifications()
    {
        self.sChatUnregisterForNotifications()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(sChatDidReceiveKeyboardDidShowNotification(_:)),
                                                         name: UIKeyboardDidShowNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(sChatDidReceiveKeyboardWillChangeFrameNotification(_:)),
                                                         name: UIKeyboardWillChangeFrameNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(sChatDidReceiveKeyboardDidChangeFrameNotification(_:)),
                                                         name: UIKeyboardDidChangeFrameNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(sChatDidReceiveKeyboardDidHideNotification(_:)),
                                                         name: UIKeyboardDidHideNotification,
                                                         object: nil)
    }
    
    func sChatUnregisterForNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func sChatDidReceiveKeyboardDidShowNotification(notification: NSNotification)
    {
        self.keyboardView = self.textView.inputAccessoryView?.superview
        self.sChatSetKeyboardViewHidden(false)
        
        self.sChatHandleKeyboardNotification(notification, completion: {
                finished in
            self.panGestureRecognizer.addTarget(self,
                action: #selector(self.sChatHandlePanGestureRecognizer(_:)))
            })
    }
    
    func sChatDidReceiveKeyboardWillChangeFrameNotification(notification: NSNotification)
    {
        self.sChatHandleKeyboardNotification(notification, completion: nil)
    }
    
    func sChatDidReceiveKeyboardDidChangeFrameNotification(notification: NSNotification)
    {
        self.sChatSetKeyboardViewHidden(false)
        
        self.sChatHandleKeyboardNotification(notification, completion: nil)
    }
    
    func sChatDidReceiveKeyboardDidHideNotification(notification: NSNotification)
    {
        self.keyboardView = nil
        
        self.sChatHandleKeyboardNotification(notification, completion: {
                finished in
            
                self.panGestureRecognizer.removeTarget(self, action: nil)
            })
    }
    
    func sChatHandleKeyboardNotification(notification: NSNotification, completion: ((finished: Bool) -> ())?)
    {
        let userInfo = notification.userInfo
        
        let keyboardEndFrame = userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        
        if CGRectIsNull(keyboardEndFrame!)
        {
            return
        }
        
        let animationCurve = userInfo![UIKeyboardAnimationCurveUserInfoKey]?.integerValue
        let animationCurveOption = UInt(animationCurve! << 16)
        
        let animationDuration = userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        
        let keyboardEndFrameConverted = self.contextView.convertRect(keyboardEndFrame!, fromView: nil)
        
        UIView.animateWithDuration(NSTimeInterval(animationDuration!),
                                   delay: NSTimeInterval(0.0),
                                   options: UIViewAnimationOptions(rawValue:animationCurveOption),
                                   animations: {
                                    self.sChatNotifyKeyboardFrameNotificationForFrame(keyboardEndFrameConverted)
            }, completion: {
                finished in
                if finished {
                    completion?(finished: finished)
                }
        })
    }
    
    // MARK: Utilities
    
    func sChatSetKeyboardViewHidden(hidden: Bool)
    {
        self.keyboardView?.hidden = hidden
        self.keyboardView?.userInteractionEnabled = !hidden
    }
    
    func sChatNotifyKeyboardFrameNotificationForFrame(frame: CGRect)
    {
        self.delegate?.keyboardDidChangeFrame(frame)
        
        NSNotificationCenter.defaultCenter().postNotificationName(SChatKeyboardControllerNotificationKeyboardDidChangeFrame,
                                                                  object: self, userInfo: [SChatKeyboardControllerUserInfoKeyKeyboardDidChangeFrame: NSValue(CGRect: frame)])
    }
    
    func sChatResetKeyboardAndTextView()
    {
        self.sChatSetKeyboardViewHidden(true)
        self.sChatRemoveKeyboardFrameObserver()
        self.textView.resignFirstResponder()
    }
    
    // MARK: Key-value observing
    
    override public func observeValueForKeyPath(keyPath: String!, ofObject: AnyObject!, change: [String: AnyObject]!, context: UnsafeMutablePointer<Void>)
    {
        if context == kSChatKeyboardControllerKeyValueObservingContext
        {
            // TODO: Si algo falla, mirar lo de @selector(frame)
            if ofObject.isEqual(self.keyboardView!) && keyPath == NSStringFromSelector(Selector("frame"))
            {
                let oldKeyboardFrame = change[NSKeyValueChangeOldKey]?.CGRectValue()
                let newKeyboardFrame = change[NSKeyValueChangeNewKey]?.CGRectValue()
                
                if oldKeyboardFrame != nil && newKeyboardFrame != nil
                {
                    if CGRectEqualToRect(newKeyboardFrame!, oldKeyboardFrame!) || CGRectIsNull(newKeyboardFrame!) {
                        return
                    }
                }
                
                let keyboardEndFrameConverted = self.contextView.convertRect(newKeyboardFrame!, toView: self.keyboardView!.superview)
                
                self.sChatNotifyKeyboardFrameNotificationForFrame(keyboardEndFrameConverted)
            }
        } else {
            observeValueForKeyPath(keyPath, ofObject: ofObject, change: change, context: context)
        }
    }
    
    func sChatRemoveKeyboardFrameObserver()
    {
        if !isObserving
        {
            return
        }
        
        do {
            try keyboardView?.removeObserver(self, forKeyPath: NSStringFromSelector(Selector("frame")), context:kSChatKeyboardControllerKeyValueObservingContext)
        } catch {
        
        }
        
        isObserving = false
    }
    
    // MARK: Pan Gesture Recognizer
    
    func sChatHandlePanGestureRecognizer(pan: UIPanGestureRecognizer)
    {
        let touch = pan.locationInView(self.contextView.window)
        
        let contextViewWindowHeight = CGRectGetHeight((self.contextView.window?.frame)!)
        
        let keyboardViewHeight = CGRectGetHeight((self.keyboardView?.frame)!)
        
        let dragThresholdY = contextViewWindowHeight - keyboardViewHeight - (self.keyboardTriggerPoint?.y)!
        
        var newKeyboardViewFrame = self.keyboardView?.frame
        
        let userIsDraggingNearThresholdForDismissing = touch.y > dragThresholdY
        
        self.keyboardView?.userInteractionEnabled = !userIsDraggingNearThresholdForDismissing
        
        switch (pan.state) {
        case .Changed:
                newKeyboardViewFrame!.origin.y = touch.y + self.keyboardTriggerPoint!.y;
                
                //  bound frame between bottom of view and height of keyboard
                newKeyboardViewFrame!.origin.y = min(newKeyboardViewFrame!.origin.y, contextViewWindowHeight)
                newKeyboardViewFrame!.origin.y = max(newKeyboardViewFrame!.origin.y, contextViewWindowHeight - keyboardViewHeight)
                
                if (CGRectGetMinY(newKeyboardViewFrame!) == CGRectGetMinY(self.keyboardView!.frame)) {
                    return;
                }
                
                
                UIView.animateWithDuration(NSTimeInterval(0.0),
                                           delay: NSTimeInterval(0.0),
                                           options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.TransitionNone],
                                            animations: {
                    self.keyboardView?.frame = newKeyboardViewFrame!
                }, completion: nil)
        case .Ended,
             .Cancelled,
             .Failed:
            
                let keyboardViewIsHidden = (CGRectGetMinY(self.keyboardView!.frame) >= contextViewWindowHeight);
                if (keyboardViewIsHidden) {
                    self.sChatResetKeyboardAndTextView()
                    return
                }
                
                let velocity = pan.velocityInView(self.contextView)
                let userIsScrollingDown = (velocity.y > 0.0)
                let shouldHide = (userIsScrollingDown && userIsDraggingNearThresholdForDismissing)
                
                newKeyboardViewFrame?.origin.y = shouldHide ? contextViewWindowHeight : (contextViewWindowHeight - keyboardViewHeight);
                
                UIView.animateWithDuration(NSTimeInterval(0.25),
                                           delay: NSTimeInterval(0.0),
                                           options: [UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseOut],
                                           animations:
                    {
                        self.keyboardView?.frame = newKeyboardViewFrame!
                    }, completion:
                    {
                        finished in
                        self.keyboardView?.userInteractionEnabled = !shouldHide
                        
                        if shouldHide {
                            self.sChatResetKeyboardAndTextView()
                        }
                    })
        default:
            break;
        }

    }
}