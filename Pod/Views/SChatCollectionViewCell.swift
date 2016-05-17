//
//  SChatCollectionViewCell.swift
//  Pods
//
//  Created by David Moreno Lora on 15/5/16.
//
//

import UIKit

var sChatCollectionViewCellActions: NSMutableSet? = nil

public class SChatCollectionViewCell: UICollectionViewCell
{
    // Outlets
    
    var delegate: SChatCollectionViewCellDelegate? = nil
    
    @IBOutlet weak var cellTopLabel: SChatLabel!
    
    @IBOutlet weak var messageBubbleTopLabel: SChatLabel!
    
    @IBOutlet weak var cellBottomLabel: SChatLabel!
    
    @IBOutlet weak var textView: SChatCellTextView!
    
    @IBOutlet weak var messageBubbleImageView: UIImageView!
    
    @IBOutlet weak var messageBubbleContainerView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var avatarContainerView: UIView!
    
    @IBOutlet weak var messageBubbleContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewTopVerticalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewBottomVerticalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewAvatarHorizontalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewMarginHorizontalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cellTopLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageBubbleTopLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cellBottomLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var avatarContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var avatarContainerViewHeightConstraint: NSLayoutConstraint!
    
    // Properties
    
    weak var mediaView: UIView? {
        set
        {
            if mediaView != nil
            {
                self.messageBubbleImageView.removeFromSuperview()
                self.textView.removeFromSuperview()
                
                
                mediaView!.translatesAutoresizingMaskIntoConstraints = false
                mediaView!.frame = self.messageBubbleContainerView.bounds
                
                self.messageBubbleContainerView.addSubview(mediaView!)
                self.messageBubbleContainerView.sChatPinAllEdgesOfSubview(mediaView!)
                mediaView = newValue
                
                dispatch_async(dispatch_get_main_queue(), {
                    for index in 0...(self.messageBubbleContainerView.subviews.count - 1)
                    {
                        if !self.messageBubbleContainerView.subviews[index].isEqual(self.mediaView)
                        {
                            self.messageBubbleContainerView.subviews[index].removeFromSuperview()
                        }
                    }
                })
            }
        }
        get { return mediaView }
    }
    
    weak var tapGestureRecognizer: UITapGestureRecognizer? = nil
    
    var textViewFrameInsets: UIEdgeInsets? {
        set
        {
            if newValue != nil
            {
                if UIEdgeInsetsEqualToEdgeInsets(newValue!, textViewFrameInsets!)
                {
                    return
                }
                
                self.sChatUpdateConstraint(self.textViewTopVerticalSpaceConstraint, withConstant: Float(newValue!.top))
                self.sChatUpdateConstraint(self.textViewBottomVerticalSpaceConstraint, withConstant: Float(newValue!.bottom))
                self.sChatUpdateConstraint(self.textViewAvatarHorizontalSpaceConstraint, withConstant: Float(newValue!.right))
                self.sChatUpdateConstraint(self.textViewMarginHorizontalSpaceConstraint, withConstant: Float(newValue!.left))
            }
        }
        get
        {
            return UIEdgeInsetsMake(self.textViewTopVerticalSpaceConstraint.constant,
                                    self.textViewMarginHorizontalSpaceConstraint.constant,
                                    self.textViewBottomVerticalSpaceConstraint.constant,
                                    self.textViewAvatarHorizontalSpaceConstraint.constant)
        }
    }
    
    var avatarViewSize: CGSize? {
        set
        {
            if newValue != nil
            {
                if CGSizeEqualToSize(newValue!, avatarViewSize!)
                {
                    return
                }
                
                self.sChatUpdateConstraint(self.avatarContainerViewWidthConstraint, withConstant: Float(newValue!.width))
                self.sChatUpdateConstraint(self.avatarContainerViewHeightConstraint, withConstant: Float(newValue!.height))
            }
        }
        get
        {
            return CGSizeMake(self.avatarContainerViewWidthConstraint.constant, self.avatarContainerViewHeightConstraint.constant)
        }
    }
    
    // MARK: Chat Methods
    
    public override static func initialize()
    {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            sChatCollectionViewCellActions = NSMutableSet()
        }
    }
    
    public class func nib() -> UINib!
    {
        return UINib.init(nibName:NSStringFromClass(self), bundle: NSBundle(forClass: self))
    }
    
    public static func cellReuseIdentifier() -> String
    {
        return NSStringFromClass(self)
    }
    
    public static func mediaCellReuseIdentifier() -> String
    {
        return NSStringFromClass(self) + "_SChatMedia"
    }
    
    public static func registerMenuAction(action: Selector)
    {
        sChatCollectionViewCellActions?.addObject(NSStringFromSelector(action))
    }
    
    // MARK: Initialization
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.cellTopLabelHeightConstraint.constant = 0.0
        self.messageBubbleTopLabelHeightConstraint.constant = 0.0
        self.cellBottomLabelHeightConstraint.constant = 0.0
        
        self.avatarViewSize = CGSizeZero
        
        self.cellTopLabel.textAlignment = .Center
        self.cellTopLabel.font = UIFont.boldSystemFontOfSize(12.0)
        self.cellTopLabel.textColor = UIColor.lightGrayColor()
        
        self.messageBubbleTopLabel.font = UIFont.systemFontOfSize(12.0)
        self.messageBubbleTopLabel.textColor = UIColor.lightGrayColor()
        
        self.cellBottomLabel.font = UIFont.systemFontOfSize(11.0)
        self.cellBottomLabel.textColor = UIColor.lightGrayColor()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(sChatHandleTapGesture(_:)))
        self.addGestureRecognizer(tap)
        self.tapGestureRecognizer = tap
    }
    
    deinit
    {
        self.delegate = nil
        
        self.cellTopLabel = nil
        self.messageBubbleTopLabel = nil
        self.cellBottomLabel = nil
        
        self.textView = nil
        self.messageBubbleImageView = nil
        self.mediaView = nil
        
        self.avatarImageView = nil
        
        self.tapGestureRecognizer?.removeTarget(nil, action: nil)
        self.tapGestureRecognizer = nil
    }
    
    // MARK: CollectionViewCell
    
    public override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.cellTopLabel.text = nil
        self.messageBubbleTopLabel.text = nil
        self.cellBottomLabel.text = nil
        
        self.textView.dataDetectorTypes = .None
        self.textView.text = nil
        self.textView.attributedText = nil
        
        self.avatarImageView.image = nil
        self.avatarImageView.highlightedImage = nil
    }
    
    public override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
    {
        return layoutAttributes
    }
    
    public override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes)
    {
        super.applyLayoutAttributes(layoutAttributes)
        
        let customAttributes: SChatCollectionViewLayoutAttributes = layoutAttributes as! SChatCollectionViewLayoutAttributes
        
        if self.textView.font != customAttributes.messageBubbleFont
        {
            self.textView.font = customAttributes.messageBubbleFont
        }
        
        if UIEdgeInsetsEqualToEdgeInsets(self.textView.textContainerInset, customAttributes.textViewTextContainerInsets!)
        {
            self.textView.textContainerInset = customAttributes.textViewTextContainerInsets!
        }
        
        self.textViewFrameInsets = customAttributes.textViewFrameInsets!
        
        self.sChatUpdateConstraint(self.messageBubbleContainerWidthConstraint, withConstant: customAttributes.messageBubbleContainerViewWidth!)
        
        self.sChatUpdateConstraint(self.cellTopLabelHeightConstraint, withConstant: customAttributes.cellTopLabelHeight!)
        
        self.sChatUpdateConstraint(self.messageBubbleTopLabelHeightConstraint, withConstant: customAttributes.messageBubbleTopLabelHeight!)
        
        self.sChatUpdateConstraint(self.cellBottomLabelHeightConstraint, withConstant: customAttributes.cellBottomLabelHeight!)
        
        if self.isKindOfClass(SChatCollectionViewCellIncoming)
        {
            self.avatarViewSize = customAttributes.incomingAvatarViewSize
        }
        else if self.isKindOfClass(SChatCollectionViewCellOutgoing)
        {
            self.avatarViewSize = customAttributes.outgoingAvatarViewSize
        }
    }
    
    override public var highlighted: Bool
    {
        set { self.messageBubbleImageView.highlighted = newValue }
        get { return highlighted }
    }
    
    override public var selected: Bool
    {
        set { self.messageBubbleImageView.highlighted = newValue }
        get { return selected }
    }
    
    // MARK: Menu actions
    
    public override func respondsToSelector(aSelector: Selector) -> Bool
    {
        if sChatCollectionViewCellActions!.containsObject(NSStringFromSelector(aSelector))
        {
            return true
        }
        
        return super.respondsToSelector(aSelector)
    }
    
    public override func forwardingTargetForSelector(aSelector: Selector) -> AnyObject?
    {
        if sChatCollectionViewCellActions!.containsObject(NSStringFromSelector(aSelector))
        {
            // TODO: This can be wrong
            self.delegate?.messagesCollectionViewCell(self, didPerformAction: aSelector, withSender: ":")
            
            return super.forwardingTargetForSelector(aSelector)
        }
        else
        {
            return super.forwardingTargetForSelector(aSelector)
        }
    }
    
    // TODO: NSMethodSignature is not allowed in swift, I have to do a workaround
    
    // MARK: Vars overrides
    
    override public var backgroundColor: UIColor?
    {
        set
        {
            backgroundColor = newValue
            
            self.cellTopLabel.backgroundColor = newValue
            self.messageBubbleTopLabel.backgroundColor = newValue
            self.cellBottomLabel.backgroundColor = newValue
            
            self.messageBubbleImageView.backgroundColor = newValue
            self.avatarImageView.backgroundColor = newValue
            
            self.messageBubbleContainerView.backgroundColor = newValue
            self.avatarContainerView.backgroundColor = newValue
        }
        get { return backgroundColor }
    }
    
    // MARK: Utilities
    
    func sChatUpdateConstraint(constraint: NSLayoutConstraint, withConstant constant: Float)
    {
        if constraint.constant == CGFloat(constant)
        {
            return
        }
        
        constraint.constant = CGFloat(constant)
    }
    
    // MARK: Gesture Recognizers
    
    func sChatHandleTapGesture(tap: UITapGestureRecognizer)
    {
        let touchPt = tap.locationInView(self)
        
        if CGRectContainsPoint(self.avatarContainerView.frame, touchPt)
        {
            self.delegate?.messagesCollectionViewCellDidTapAvatar(self)
        }
        else if CGRectContainsPoint(self.messageBubbleContainerView.frame, touchPt)
        {
            self.delegate?.messagesCollectionViewCellDidTapMessageBubble(self)
        }
        else
        {
            self.delegate?.messagesCollectionViewCellDidTapCell(self, atPosition: touchPt)
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
    {
        let touchPt = touch.locationInView(self)
        
        if gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer)
        {
            return CGRectContainsPoint(self.messageBubbleContainerView.frame, touchPt)
        }
        
        return true
    }
}
