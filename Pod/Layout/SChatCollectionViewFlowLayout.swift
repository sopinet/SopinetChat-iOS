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
    
    // TODO: Hacerle el casting
    
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
    
    public var incomingAvatarViewSize: CGSize {
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
    
    public var outgoingAvatarViewSize: CGSize {
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
        
        // TODO: Descomentar esto self.messageBubbleFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        {
            self.messageBubbleLeftRightMargin = 240.0
        }
        else
        {
            // TODO: Descomentar esto self.messageBubbleLeftRightMargin = 50.0
        }
        
        self.messageBubbleTextViewFrameInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 6.0)
        // TODO: Descomentar esto self.messageBubbleTextViewTextContainerInsets = UIEdgeInsetsMake(7.0, 14.0, 7.0, 14.0)
        
        let defaultAvatarSize = CGSizeMake(kSChatCollectionViewAvatarSizeDefault, kSChatCollectionViewAvatarSizeDefault)
        
        // TODO: Descomentar esto self.incomingAvatarViewSize = defaultAvatarSize
        // TODO: Descomentar esto self.outgoingAvatarViewSize = defaultAvatarSize
        
        // TODO: Descomentar esto springinessEnabled = false
        // TODO: Descomentar esto springResistanceFactor = 1000
        
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
        self.sChatResetLayout()
    }
    
    func sChatDidReceiveDeviceOrientationDidChangeNotification(notification: NSNotification)
    {
        self.sChatResetLayout()
        self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
    }
    
    // MARK: CollectionViewFlowLayout
    
    public override func invalidateLayoutWithContext(context: UICollectionViewLayoutInvalidationContext)
    {
        if context.invalidateDataSourceCounts
        {
            // TODO: Descomentar esto (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutAttributes = true
            // TODO: Descomentar esto (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutDelegateMetrics = true
        }
        
        /* TODO: Descomentar esto if (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutAttributes
            || (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutDelegateMetrics
        {
            self.sChatResetDynamicAnimator()
        }
        
        if (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutMessagesCache
        {
            self.sChatResetLayout()
        }*/
        
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
            
            self.sChatRemoveNoLongerVisibleBehaviorsFromVisibleItemsIndexPaths(visibleItemsIndexPaths)
            
            self.sChatAddNewlyVisibleBehaviorsFromVisibleItems(visibleItems as [AnyObject])
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
                    self.sChatConfigureMessageCellLayoutAttributes(value as! SChatCollectionViewLayoutAttributes)
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
            self.sChatConfigureMessageCellLayoutAttributes(customAttributes)
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
                self.sChatAdjustSpringBehavior(value as! UIAttachmentBehavior, forTouchLocation: touchLocation!)
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
        super.prepareForCollectionViewUpdates(updateItems)
        
        for (index, value) in updateItems.enumerate()
        {
            if value.updateAction == UICollectionUpdateAction.Insert
            {
                if !self.springinessEnabled && (self.dynamicAnimator!.layoutAttributesForCellAtIndexPath(value.indexPathAfterUpdate!) == nil) != nil
                {
                    let collectionViewHeight = CGRectGetHeight(self.collectionView!.bounds)
                    
                    let attributes: SChatCollectionViewLayoutAttributes = self.dynamicAnimator!.layoutAttributesForCellAtIndexPath(value.indexPathAfterUpdate!) as! SChatCollectionViewLayoutAttributes
                    
                    if attributes.representedElementCategory == UICollectionElementCategory.Cell
                    {
                        self.sChatConfigureMessageCellLayoutAttributes(attributes)
                    }
                    
                    attributes.frame = CGRectMake(0.0,
                                                  collectionViewHeight + CGRectGetHeight(attributes.frame),
                                                  CGRectGetWidth(attributes.frame),
                                                  CGRectGetHeight(attributes.frame))
                    
                    if self.springinessEnabled
                    {
                        let springBehaviour = self.sChatSpringBehaviorWithLayoutAttributesItem(attributes)
                        
                        self.dynamicAnimator?.addBehavior(springBehaviour!)
                    }
                }
            }
        }
    }
    
    // MARK: Invalidation utilities
    
    func sChatResetLayout()
    {
        self.bubbleSizeCalculator?.prepareForResettingLayout(self)
        self.sChatResetDynamicAnimator()
    }
    
    func sChatResetDynamicAnimator()
    {
        if self.springinessEnabled
        {
            self.dynamicAnimator?.removeAllBehaviors()
            self.visibleIndexPaths?.removeAllObjects()
        }
    }
    
    // MARK: Message cell layout utilities
    
    func messageBubblesSizeForItemAtIndexPath(indexPath: NSIndexPath) -> CGSize
    {
        let messageItem: SChatMessageData = self.collectionView!.dataSourceInterceptor!.collectionView(self.collectionView!, messageDataForItemAtIndexPath: indexPath)!
        
        return self.bubbleSizeCalculator!.messageBubbleSizeForMessageData(messageItem,
                                                                          atIndexPath: indexPath,
                                                                          withLayout: self)
    }
    
    func sizeForItemAtIndexPath(indexPath: NSIndexPath) -> CGSize
    {
        let messageBubbleSize = self.messageBubblesSizeForItemAtIndexPath(indexPath)
        
        let attributes: SChatCollectionViewLayoutAttributes = self.layoutAttributesForItemAtIndexPath(indexPath) as! SChatCollectionViewLayoutAttributes
        
        var finalHeight = Float(messageBubbleSize.height)
        
        finalHeight += attributes.cellTopLabelHeight!
        finalHeight += attributes.messageBubbleTopLabelHeight!
        finalHeight += attributes.cellBottomLabelHeight!
        
        return CGSizeMake(CGFloat(self.itemWidth), CGFloat(ceilf(finalHeight)))
    }
    
    func sChatConfigureMessageCellLayoutAttributes(layoutAttributes: SChatCollectionViewLayoutAttributes)
    {
        let indexPath = layoutAttributes.indexPath
        
        let messageBubbleSize = self.messageBubblesSizeForItemAtIndexPath(indexPath)
        
        layoutAttributes.messageBubbleContainerViewWidth = Float(messageBubbleSize.width)
        
        layoutAttributes.textViewFrameInsets = self.messageBubbleTextViewFrameInsets
        
        layoutAttributes.textViewTextContainerInsets = self.messageBubbleTextViewTextContainerInsets
        
        layoutAttributes.incomingAvatarViewSize = self.incomingAvatarViewSize
        
        layoutAttributes.outgoingAvatarViewSize = self.outgoingAvatarViewSize
        
        layoutAttributes.cellTopLabelHeight = self.collectionView!.delegateInterceptor?
            .collectionView(self.collectionView!,
                            layout: self,
                            heightForCellTopLabelAtIndexPath: indexPath)
        
        layoutAttributes.messageBubbleTopLabelHeight = self.collectionView!.delegateInterceptor?
            .collectionView(self.collectionView!,
                            layout: self,
                            heightForMessageBubbleTopLabelAtIndexPath: indexPath)
        
        layoutAttributes.cellBottomLabelHeight = self.collectionView!.delegateInterceptor?.collectionView(self.collectionView!, layout: self, heightForCellBottomLabelAtIndexPath: indexPath)
    }
    
    // MARK: Spring behavior utilities
    
    func sChatSpringBehaviorWithLayoutAttributesItem(item: UICollectionViewLayoutAttributes) -> UIAttachmentBehavior?
    {
        if CGSizeEqualToSize(item.frame.size, CGSizeZero)
        {
            return nil
        }
        
        let springBehavior: UIAttachmentBehavior = UIAttachmentBehavior(item: item,
                                                                        attachedToAnchor: item.center)
        
        springBehavior.length = 1.0
        springBehavior.damping = 1.0
        springBehavior.frequency = 1.0
        
        return springBehavior
    }
    
    func sChatAddNewlyVisibleBehaviorsFromVisibleItems(visibleItems: [AnyObject])
    {
        let indexSet: NSIndexSet = (visibleItems as NSArray).indexesOfObjectsPassingTest({
            (item: AnyObject!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Bool in
            return !self.visibleIndexPaths!.containsObject(item.indexPath)
        })
        
        let newlyVisibleItems = (visibleItems as NSArray).objectsAtIndexes(indexSet)
        
        let touchLocation = self.collectionView!.panGestureRecognizer.locationInView(self.collectionView!)
        
        for (index, value) in newlyVisibleItems.enumerate()
        {
            let springBehaviour: UIAttachmentBehavior = self.sChatSpringBehaviorWithLayoutAttributesItem(value as! UICollectionViewLayoutAttributes)!
            
            self.sChatAdjustSpringBehavior(springBehaviour, forTouchLocation: touchLocation)
            
            self.dynamicAnimator?.addBehavior(springBehaviour)
            self.visibleIndexPaths?.addObject(value.indexPath)
        }
    }
    
    func sChatRemoveNoLongerVisibleBehaviorsFromVisibleItemsIndexPaths(visibleItemsIndexPaths: NSSet)
    {
        let behaviors = self.dynamicAnimator!.behaviors
        
        let indexSet: NSIndexSet = (behaviors as NSArray).indexesOfObjectsPassingTest({
            (springBehaviour: AnyObject!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Bool in
            
            let layoutAttributes: UICollectionViewLayoutAttributes = springBehaviour.items.first! as! UICollectionViewLayoutAttributes
            
            return !self.visibleIndexPaths!.containsObject(layoutAttributes.indexPath)
        })
        
        let behaviorsNSArray: NSArray = self.dynamicAnimator!.behaviors as! NSArray
        let behaviorsToRemove = behaviorsNSArray.objectsAtIndexes(indexSet)
        
        for (index, value) in behaviorsToRemove.enumerate()
        {
            let layoutAttributes: UICollectionViewLayoutAttributes = value.items.first! as! UICollectionViewLayoutAttributes
            
            self.dynamicAnimator?.removeBehavior(value as! UIDynamicBehavior)
            self.visibleIndexPaths?.removeObject(layoutAttributes.indexPath)
        }
    }
    
    func sChatAdjustSpringBehavior(springBehavior: UIAttachmentBehavior, forTouchLocation touchLocation: CGPoint)
    {
        let item: UICollectionViewLayoutAttributes = springBehavior.items.first! as! UICollectionViewLayoutAttributes
        
        var center = item.center
        
        if !CGPointEqualToPoint(CGPointZero, touchLocation)
        {
            let distanceFromTouch = fabs(touchLocation.y - springBehavior.anchorPoint.y)
            
            let scrollResistance = distanceFromTouch / CGFloat(self.springResistanceFactor)
            
            if self.latestDelta < 0.0
            {
                center.y += max(CGFloat(self.latestDelta!), CGFloat(self.latestDelta!) * scrollResistance)
            }
            else
            {
                center.y += min(CGFloat(self.latestDelta!), CGFloat(self.latestDelta!) * scrollResistance)
            }
            
            item.center = center
        }
    }
}