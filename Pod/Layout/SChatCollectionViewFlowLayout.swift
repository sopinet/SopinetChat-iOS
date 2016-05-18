//
//  SChatCollectionViewFlowLayout.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation
import UIKit

let kSChatCollectionViewCellLabelHeightDefault: CGFloat = 20.0
let kSChatCollectionViewAvatarSizeDefault: CGFloat = 30.0

public class SChatCollectionViewFlowLayout: UICollectionViewFlowLayout
{
    // MARK: Properties
    
    public override var collectionView: SChatCollectionView?
    {
        get { return collectionView }
    }
    
    var bubbleSizeCalculator: SChatBubbleSizeCalculating? {
        set
        {
            bubbleSizeCalculator = newValue
        }
        get
        {
            if bubbleSizeCalculator == nil
            {
                bubbleSizeCalculator = SChatBubbleSizeCalculator()
            }
            return bubbleSizeCalculator
        }
    }
    
    var springinessEnabled: Bool {
        set
        {
            if springinessEnabled != newValue
            {
                springinessEnabled = newValue
                
                if !springinessEnabled
                {
                    dynamicAnimator?.removeAllBehaviors()
                    visibleIndexPaths?.removeAllObjects()
                }
                
                self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        get
        {
            return springinessEnabled
        }
    }
    
    var springResistanceFactor: UInt = 1000
    
    var itemWidth: Float {
        get
        {
            return Float(CGRectGetWidth(self.collectionView!.frame) - self.sectionInset.left - self.sectionInset.right)
        }
    }
    
    var incomingAvatarViewSize: CGSize {
        set
        {
            if !CGSizeEqualToSize(incomingAvatarViewSize, newValue)
            {
                incomingAvatarViewSize = newValue
                
                self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        get
        {
            return incomingAvatarViewSize
        }
    }
    
    var outgoingAvatarViewSize: CGSize {
        set
        {
            if !CGSizeEqualToSize(outgoingAvatarViewSize, newValue)
            {
                outgoingAvatarViewSize = newValue
                
                self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        get
        {
            return outgoingAvatarViewSize
        }
    }
    
    var messageBubbleTextViewFrameInsets: UIEdgeInsets?
    
    var messageBubbleTextViewTextContainerInsets: UIEdgeInsets {
        set
        {
            if !UIEdgeInsetsEqualToEdgeInsets(self.messageBubbleTextViewTextContainerInsets, newValue)
            {
                messageBubbleTextViewTextContainerInsets = newValue
                
                self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        get
        {
            return messageBubbleTextViewTextContainerInsets
        }
    }
    
    var messageBubbleLeftRightMargin: Float {
        set
        {
            assert(newValue >= 0.0, "messageBubbleLeftRightMargin must be equal to or greater than 0.0")
            messageBubbleLeftRightMargin = ceilf(newValue)
            
            self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
        }
        get
        {
            return messageBubbleLeftRightMargin
        }
    }
    
    var messageBubbleFont: UIFont? {
        set
        {
            if newValue != nil
            {
                if messageBubbleFont == nil || !messageBubbleFont!.isEqual(newValue!)
                {
                    messageBubbleFont = newValue
                    
                    self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
                }
            }
            else
            {
                messageBubbleFont = newValue
            }
        }
        get
        {
            return messageBubbleFont
        }
    }
    
    var cacheLimit: UInt = 200
    
    var dynamicAnimator: UIDynamicAnimator? {
        set
        {
            dynamicAnimator = newValue
        }
        get
        {
            if dynamicAnimator == nil
            {
                dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
            }
            
            return dynamicAnimator
        }
    }
    
    var visibleIndexPaths: NSMutableSet? {
        set
        {
            visibleIndexPaths = newValue
        }
        get
        {
            if visibleIndexPaths == nil
            {
                visibleIndexPaths = NSMutableSet()
            }
            return visibleIndexPaths
        }
    }
    
    var latestDelta: Float?
    
    // MARK: Initialization
    
    func sChatConfigureFlowLayout()
    {
        self.scrollDirection = .Vertical
        self.sectionInset = UIEdgeInsetsMake(10.0, 4.0, 10.0, 4.0)
        self.minimumLineSpacing = 4.0
        
        self.messageBubbleFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        {
            self.messageBubbleLeftRightMargin = 240.0
        }
        else
        {
            self.messageBubbleLeftRightMargin = 50.0
        }
        
        self.messageBubbleTextViewFrameInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 6.0)
        self.messageBubbleTextViewTextContainerInsets = UIEdgeInsetsMake(7.0, 14.0, 7.0, 14.0)
        
        let defaultAvatarSize = CGSizeMake(kSChatCollectionViewAvatarSizeDefault, kSChatCollectionViewAvatarSizeDefault)
        
        self.incomingAvatarViewSize = defaultAvatarSize
        self.outgoingAvatarViewSize = defaultAvatarSize
        
        springinessEnabled = false
        springResistanceFactor = 1000
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(sChatDidReceiveApplicationMemoryWarningNotification(_:)),
                                                         name: UIApplicationDidReceiveMemoryWarningNotification,
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(sChatDidReceiveDeviceOrientationDidChangeNotification(_:)),
                                                         name: UIDeviceOrientationDidChangeNotification,
                                                         object: nil)
    }
    
    override init()
    {
        super.init()
        self.sChatConfigureFlowLayout()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.sChatConfigureFlowLayout()
    }
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        self.sChatConfigureFlowLayout()
    }
    
    func layoutAttributesClass() -> AnyClass
    {
        return SChatCollectionViewLayoutAttributes.self
    }
    
    func invalidationContextClass() -> AnyClass
    {
        return SChatCollectionViewFlowLayoutInvalidationContext.self
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        self.messageBubbleFont = nil
        self.bubbleSizeCalculator = nil
        
        self.dynamicAnimator?.removeAllBehaviors()
        self.dynamicAnimator = nil
        
        self.visibleIndexPaths?.removeAllObjects()
        self.visibleIndexPaths = nil
    }
    
    // MARK: Notifications
    
    func sChatDidReceiveApplicationMemoryWarningNotification(notification: NSNotification)
    {
        // TODO: self.resetLayout()
    }
    
    func sChatDidReceiveDeviceOrientationDidChangeNotification(notification: NSNotification)
    {
        // TODO: self.resetLayout()
        self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
    }
    
    // MARK: CollectionViewFlowLayout
    
    public override func invalidateLayoutWithContext(context: UICollectionViewLayoutInvalidationContext)
    {
        if context.invalidateDataSourceCounts
        {
            (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutAttributes = true
            (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutDelegateMetrics = true
        }
        
        if (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutAttributes
            || (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutDelegateMetrics
        {
            // TODO: self.sChatResetDynamicAnimator()
        }
        
        if (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutMessagesCache
        {
            // TODO: self.sChatResetLayout()
        }
        
        super.invalidateLayoutWithContext(context)
    }
    
    public override func prepareLayout()
    {
        super.prepareLayout()
        
        if self.springinessEnabled
        {
            let padding: CGFloat = -100.0
            
            let visibleRect = CGRectInset(self.collectionView!.bounds, padding, padding)
            
            let visibleItems: NSArray = super.layoutAttributesForElementsInRect(visibleRect)!
            
            let visibleItemsIndexPaths: NSSet = NSSet(array: visibleItems.valueForKey(NSStringFromSelector(Selector("indexPath"))) as! [AnyObject])
            
            // TODO: self.sChatRemoveNoLongerVisibleBehaviorsFromVisibleItemsIndexPaths(visibleItemsIndexPaths)
            
            // TODO: self.sChatAddNewlyVisibleBehaviorsFromVisibleItems(visibleItems)
        }
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var attributesInRect: [UICollectionViewLayoutAttributes]? = super.layoutAttributesForElementsInRect(rect)
        
        if self.springinessEnabled
        {
            if attributesInRect != nil
            {
                var attributesInRectCopy = attributesInRect
                let dynamicAttributes = self.dynamicAnimator?.itemsInRect(rect)
                
                for eachItem: UICollectionViewLayoutAttributes in attributesInRect!
                {
                    for eachDynamicItem: UIDynamicItem in dynamicAttributes!
                    {
                        if eachItem.indexPath.isEqual(eachDynamicItem)
                            && eachItem.representedElementCategory == (eachDynamicItem as! UICollectionViewLayoutAttributes).representedElementCategory
                        {
                            attributesInRectCopy!.removeObject(eachItem)
                            attributesInRectCopy!.append(eachDynamicItem as! UICollectionViewLayoutAttributes)
                            continue
                        }
                    }
                }
                
                attributesInRect = attributesInRectCopy
            }
        }
        
        if attributesInRect != nil {
            for (index, value) in attributesInRect!.enumerate()
            {
                if value.representedElementCategory == UICollectionElementCategory.Cell
                {
                    // TODO: self.sChatConfigureMessageCellLayoutAttributes(attributesItem)
                }
                else
                {
                    value.zIndex = -1
                }
            }
        }
        
        return attributesInRect
    }
    
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
    {
        let customAttributes: SChatCollectionViewLayoutAttributes = super.layoutAttributesForItemAtIndexPath(indexPath) as! SChatCollectionViewLayoutAttributes
        
        if customAttributes.representedElementCategory == UICollectionElementCategory.Cell
        {
            // TODO: self.sChatConfigureMessageCellLayoutAttributes(customAttributes)
        }
        
        return customAttributes
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool
    {
        if self.springinessEnabled
        {
            let scrollView: UIScrollView = self.collectionView!
            let delta: Float = Float(newBounds.origin.y - scrollView.bounds.origin.y)
            
            self.latestDelta = delta
            
            let touchLocation = self.collectionView?.panGestureRecognizer.locationInView(self.collectionView)
            
            for (index, value) in self.dynamicAnimator!.behaviors.enumerate()
            {
                // TODO: self.sChatAdjustSpringBehavior(value, forTouchLocation: touchLocation)
                self.dynamicAnimator?.updateItemUsingCurrentState((value as! UIAttachmentBehavior).items.first!)
            }
        }
        
        let oldBounds = self.collectionView!.bounds
        
        if CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)
        {
            return true
        }
        
        return false
    }
    
    public override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem])
    {
        // ...
    }
}