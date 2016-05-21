//
//  SChatBubbleSizeCalculator.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation

public class SChatBubbleSizeCalculator: NSObject, SChatBubbleSizeCalculating
{
    // MARK: Properties
    
    var cache: NSCache?
    
    var minimumBubbleWidth: UInt?
    
    var usesFixedWidthBubbles: Bool?
    
    var additionalInset: Int?
    
    var layoutWidthForFixedWidthBubbles: Float?
    
    // MARK: Initializers
    
    override convenience init()
    {
        let cache = NSCache()
        cache.name = "SChatBubblesSizeCalculator.cache"
        cache.countLimit = 200
        
        self.init(cache: cache, minimumBubbleWidth: UInt(UIImage.sChatBubbleCompactImage().size.width), usesFixedWidthBubbles: false)
    }
    
    init(cache: NSCache, minimumBubbleWidth: UInt, usesFixedWidthBubbles: Bool)
    {
        super.init()
        
        self.cache = cache
        self.minimumBubbleWidth = minimumBubbleWidth
        self.usesFixedWidthBubbles = usesFixedWidthBubbles
        self.layoutWidthForFixedWidthBubbles = 0.0
        
        self.additionalInset = 2
    }
    
    // MARK NSObject
    
    override public var description: String
    {
        set {
            description = "<\(self.dynamicType): cache=\(self.cache), minimumBubbleWidth=\(self.minimumBubbleWidth), usesFixedWidthBubbles=\(self.usesFixedWidthBubbles)>"
        }
        get
        {
            return description
        }
    }
    
    // MARK: SChatBubbleSizeCalculating
    
    public func prepareForResettingLayout(layout: SChatCollectionViewFlowLayout)
    {
        self.cache!.removeAllObjects()
    }
    
    public func messageBubbleSizeForMessageData(messageData: SChatMessageData, atIndexPath indexPath: NSIndexPath, withLayout layout: SChatCollectionViewFlowLayout) -> CGSize
    {
        // TODO: Descomentar esto
        /*if let auxMessageHash = messageData.messageHash
        {
            let cachedSize: NSValue? = self.cache?.objectForKey(auxMessageHash) as? NSValue
            
            if cachedSize != nil
            {
                return cachedSize!.CGSizeValue()
            }
        }*/
        
        var finalSize = CGSizeZero
        
        if messageData.isMediaMessage!
        {
            finalSize = messageData.media!.mediaViewDisplaySize
        }
        else
        {
            let avatarSize = self.sChatAvatarSizeForMessageData(messageData, withLayout: layout)
            
            let spacingBetweenAvatarAndBubble: CGFloat = 2.0
            
            let horizontalContainerInsets = layout.messageBubbleTextViewTextContainerInsets.left + layout.messageBubbleTextViewTextContainerInsets.right
            
            let horizontalFrameInsets = layout.messageBubbleTextViewFrameInsets!.left + layout.messageBubbleTextViewFrameInsets!.right
            
            let horizontalInsetsTotal = horizontalContainerInsets + horizontalFrameInsets + spacingBetweenAvatarAndBubble
            
            let maximumTextWidth = self.textBubbleWidthForLayout(layout) - Float(avatarSize.width) - layout.messageBubbleLeftRightMargin - Float(horizontalInsetsTotal)
            
            let stringRect = (messageData.text as! NSString).boundingRectWithSize(CGSizeMake(CGFloat(maximumTextWidth), CGFloat.max), options: [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading],
                                                                                  attributes: [NSFontAttributeName : (layout.messageBubbleFont!)], context: nil)
            
            let stringSize = CGRectIntegral(stringRect).size
            
            let verticalContainerInsets = layout.messageBubbleTextViewTextContainerInsets.top + layout.messageBubbleTextViewTextContainerInsets.bottom

            let verticalFrameInsets = layout.messageBubbleTextViewFrameInsets!.top + layout.messageBubbleTextViewFrameInsets!.bottom
            
            let verticalInsets = verticalContainerInsets + verticalFrameInsets + CGFloat(self.additionalInset!)
            
            let finalWidth = max(Float(stringSize.width + horizontalInsetsTotal), Float(self.minimumBubbleWidth!)) + Float(self.additionalInset!)
            
            finalSize = CGSizeMake(CGFloat(finalWidth), stringSize.height + verticalInsets)
        }
        
        // TODO: Descomentar esto:
        /*if let auxMessageHash = messageData.messageHash
        {
            self.cache?.setObject(NSValue(CGSize: finalSize), forKey: auxMessageHash)
        }*/
    
        return finalSize
    }
    
    func sChatAvatarSizeForMessageData(messageData: SChatMessageData,
                                       withLayout layout: SChatCollectionViewFlowLayout) -> CGSize
    {
        let messageSender = messageData.senderId
        
        if messageSender == (layout.collectionView as! SChatCollectionView).dataSourceInterceptor?.senderId
        {
            return layout.outgoingAvatarViewSize
        }
        
        return layout.incomingAvatarViewSize
    }
    
    func textBubbleWidthForLayout(layout: SChatCollectionViewFlowLayout) -> Float
    {
        if self.layoutWidthForFixedWidthBubbles > 0.0
        {
            return self.layoutWidthForFixedWidthBubbles!
        }
        
        let horizontalInsets = layout.sectionInset.left + layout.sectionInset.right + CGFloat(self.additionalInset!)
        
        let width = CGRectGetWidth(layout.collectionView!.bounds) - horizontalInsets
        
        let height = CGRectGetHeight(layout.collectionView!.bounds) - horizontalInsets
        
        self.layoutWidthForFixedWidthBubbles = min(Float(width), Float(height))
        
        return self.layoutWidthForFixedWidthBubbles!
    }
}