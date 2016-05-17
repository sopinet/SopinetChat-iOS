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
        
        self.init(cache: cache, minimumBubbleWidth: 0, usesFixedWidthBubbles: false)
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
    
    // ...
    
    // MARK: SChatBubbleSizeCalculating
    
    public func prepareForResettingLayout(layout: SChatCollectionViewFlowLayout)
    {
        self.cache!.removeAllObjects()
    }
    
    public func messageBubbleForMessageData(messageData: SChatMessageData, atIndexPath indexPath: NSIndexPath, withLayout layout: SChatCollectionViewFlowLayout)
    {
        
    }
}