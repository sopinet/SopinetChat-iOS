//
//  SChatCollectionViewFlowLayout.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation
import UIKit

public let kSChatCollectionViewCellLabelHeightDefault: CGFloat = 20.0
public let kSChatCollectionViewAvatarSizeDefault: CGFloat = 30.0

public class SChatCollectionViewFlowLayout: UICollectionViewFlowLayout
{
    // MARK: Properties
    
    weak var collectionViewInterceptor: SChatCollectionView?
    
    /*public override var collectionView: UICollectionView? {
        didSet {
            if collectionView != nil {
                //let castedDelegate = unsafeBitCast(delegate, SChatInputToolbarDelegate.self)
                let castedCollectionView: SChatCollectionView = collectionView as! SChatCollectionView
                collectionViewInterceptor = castedCollectionView
            }
            else {
                collectionViewInterceptor = nil
            }
        }
    }*/
    
    private var _bubbleSizeCalculator: SChatBubbleSizeCalculating?
    var bubbleSizeCalculator: SChatBubbleSizeCalculating? {
        set
        {
            _bubbleSizeCalculator = newValue
        }
        get
        {
            if _bubbleSizeCalculator == nil
            {
                _bubbleSizeCalculator = SChatBubbleSizeCalculator()
            }
            return _bubbleSizeCalculator
        }
    }
    
    private var _springinessEnabled: Bool = false
    var springinessEnabled: Bool {
        set
        {
            if _springinessEnabled != newValue
            {
                _springinessEnabled = newValue
                
                if !_springinessEnabled
                {
                    dynamicAnimator?.removeAllBehaviors()
                    visibleIndexPaths?.removeAllObjects()
                }
                
                self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        get
        {
            return _springinessEnabled
        }
    }
    
    var springResistanceFactor: UInt = 1000
    
    var itemWidth: Float {
        get
        {
            return Float(CGRectGetWidth(self.collectionView!.frame) - self.sectionInset.left - self.sectionInset.right)
        }
    }
    
    private var _incomingAvatarViewSize: CGSize = CGSizeZero
    public var incomingAvatarViewSize: CGSize {
        set
        {
            if !CGSizeEqualToSize(_incomingAvatarViewSize, newValue)
            {
                _incomingAvatarViewSize = newValue
                
                self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        get
        {
            return _incomingAvatarViewSize
        }
    }
    
    private var _outgoingAvatarViewSize: CGSize = CGSizeZero
    public var outgoingAvatarViewSize: CGSize {
        set
        {
            if !CGSizeEqualToSize(_outgoingAvatarViewSize, newValue)
            {
                _outgoingAvatarViewSize = newValue
                
                self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        get
        {
            return _outgoingAvatarViewSize
        }
    }
    
    var messageBubbleTextViewFrameInsets: UIEdgeInsets?
    
    private var _messageBubbleTextViewTextContainerInsets: UIEdgeInsets = UIEdgeInsetsZero
    var messageBubbleTextViewTextContainerInsets: UIEdgeInsets {
        set
        {
            if !UIEdgeInsetsEqualToEdgeInsets(_messageBubbleTextViewTextContainerInsets, newValue)
            {
                _messageBubbleTextViewTextContainerInsets = newValue
                
                self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        get
        {
            return _messageBubbleTextViewTextContainerInsets
        }
    }
    
    private var _messageBubbleLeftRightMargin: Float = 0.0
    var messageBubbleLeftRightMargin: Float {
        set
        {
            assert(newValue >= 0.0, "messageBubbleLeftRightMargin must be equal to or greater than 0.0")
            _messageBubbleLeftRightMargin = ceilf(newValue)
            
            self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
        }
        get
        {
            return _messageBubbleLeftRightMargin
        }
    }
    
    private var _messageBubbleFont: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    var messageBubbleFont: UIFont? {
        set
        {
            if !_messageBubbleFont.isEqual(newValue!)
            {
                _messageBubbleFont = newValue!
                
                self.invalidateLayoutWithContext(SChatCollectionViewFlowLayoutInvalidationContext.context())
            }
        }
        get
        {
            return _messageBubbleFont
        }
    }
    
    var cacheLimit: UInt = 200
    
    private var _dynamicAnimator: UIDynamicAnimator?
    var dynamicAnimator: UIDynamicAnimator? {
        set
        {
            _dynamicAnimator = newValue
        }
        get
        {
            if _dynamicAnimator == nil
            {
                _dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
            }
            
            return _dynamicAnimator
        }
    }
    
    var _visibleIndexPaths: NSMutableSet?
    var visibleIndexPaths: NSMutableSet? {
        set
        {
            _visibleIndexPaths = newValue
        }
        get
        {
            if _visibleIndexPaths == nil
            {
                _visibleIndexPaths = NSMutableSet()
            }
            return _visibleIndexPaths
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
    
    public override class func layoutAttributesClass() -> AnyClass
    {
        return SChatCollectionViewLayoutAttributes.self
    }
    
    public override class func invalidationContextClass() -> AnyClass
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
            (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutAttributes = true
            (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutDelegateMetrics = true
        }
        
        if (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutAttributes
            || (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutDelegateMetrics
        {
            self.sChatResetDynamicAnimator()
        }
        
        if (context as! SChatCollectionViewFlowLayoutInvalidationContext).invalidateFlowLayoutMessagesCache
        {
            self.sChatResetLayout()
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
                    // TODO: Descomentar esto
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
        /* TODO: Descomentar esto */
        let customAttributes: SChatCollectionViewLayoutAttributes? = super.layoutAttributesForItemAtIndexPath(indexPath) as? SChatCollectionViewLayoutAttributes
        
        if customAttributes?.representedElementCategory == UICollectionElementCategory.Cell
        {
            self.sChatConfigureMessageCellLayoutAttributes(customAttributes!)
        }
        
        return customAttributes
        
        return nil
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
        let messageItem: SChatMessageData = (self.collectionView as! SChatCollectionView).dataSourceInterceptor!.collectionView((self.collectionView as! SChatCollectionView), messageDataForItemAtIndexPath: indexPath)!
        
        return self.bubbleSizeCalculator!.messageBubbleSizeForMessageData(messageItem,
                                                                          atIndexPath: indexPath,
                                                                          withLayout: self)
    }
    
    func sizeForItemAtIndexPath(indexPath: NSIndexPath) -> CGSize
    {
        let messageBubbleSize = self.messageBubblesSizeForItemAtIndexPath(indexPath)
        
        // Descomentar esto
        let attributes: SChatCollectionViewLayoutAttributes? = self.layoutAttributesForItemAtIndexPath(indexPath) as? SChatCollectionViewLayoutAttributes
        
        var finalHeight = Float(messageBubbleSize.height)
        
        /* TODO: Descomentar esto*/
        if attributes != nil
        {
            finalHeight += attributes!.cellTopLabelHeight!
            finalHeight += attributes!.messageBubbleTopLabelHeight!
            finalHeight += attributes!.cellBottomLabelHeight!
        }
        
        return CGSizeMake(CGFloat(self.itemWidth), CGFloat(ceilf(finalHeight)))
    }
    
    func sChatConfigureMessageCellLayoutAttributes(layoutAttributes: SChatCollectionViewLayoutAttributes)
    {
        let indexPath = layoutAttributes.indexPath
        
        let messageBubbleSize = self.messageBubblesSizeForItemAtIndexPath(indexPath)
        
        layoutAttributes.messageBubbleContainerViewWidth = Float(messageBubbleSize.width)
        
        layoutAttributes.textViewFrameInsets = self.messageBubbleTextViewFrameInsets
        
        layoutAttributes.textViewTextContainerInsets = self.messageBubbleTextViewTextContainerInsets
        
        layoutAttributes.messageBubbleFont = self.messageBubbleFont
        
        layoutAttributes.incomingAvatarViewSize = self.incomingAvatarViewSize
        
        layoutAttributes.outgoingAvatarViewSize = self.outgoingAvatarViewSize
        
        layoutAttributes.cellTopLabelHeight = (self.collectionView as! SChatCollectionView).delegateInterceptor?
            .collectionView((self.collectionView as! SChatCollectionView),
                            layout: self,
                            heightForCellTopLabelAtIndexPath: indexPath)
        
        layoutAttributes.messageBubbleTopLabelHeight = (self.collectionView as! SChatCollectionView).delegateInterceptor?
            .collectionView((self.collectionView as! SChatCollectionView),
                            layout: self,
                            heightForMessageBubbleTopLabelAtIndexPath: indexPath)
        
        layoutAttributes.cellBottomLabelHeight = (self.collectionView as! SChatCollectionView).delegateInterceptor?.collectionView((self.collectionView as! SChatCollectionView), layout: self, heightForCellBottomLabelAtIndexPath: indexPath)
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