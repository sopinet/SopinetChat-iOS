//
//  SChatBubbleImage.swift
//  Pods
//
//  Created by David Moreno Lora on 20/5/16.
//
//

import Foundation

public class SChatBubbleImage: NSObject, SChatBubbleImageDataSource, NSCopying
{
    // MARK: Properties
    
    public var messageBubbleImage: UIImage?
    
    public var messageBubbleHighlightedImage: UIImage?
    
    // MARK: Initialization
    
    override convenience init()
    {
        assert(false, "init() is not a valid initializer for SChatBubbleImage. Use init(bubbleImage, highlightedImage) instead.")
        self.init()
    }
    
    required public convenience init(bubbleImage: UIImage, highlightedImage: UIImage)
    {
        self.init(bubbleImage: bubbleImage, highlightedImage: highlightedImage, nilParameter: nil)
    }
    
    init(bubbleImage: UIImage, highlightedImage: UIImage, nilParameter: AnyObject?)
    {
        self.messageBubbleImage = bubbleImage
        self.messageBubbleHighlightedImage = highlightedImage
    }
    
    // MARK: NSObject
    
    override public var description: String
    {
        get {
            return "<\(self.dynamicType): messageBubbleImage=\(self.messageBubbleImage), messageBubbleHighlightedImage=\(messageBubbleHighlightedImage)"
        }
    }
    
    func debugQuickLookObject() -> AnyObject
    {
        return UIImageView(image: self.messageBubbleImage, highlightedImage: self.messageBubbleHighlightedImage)
    }
    
    // MARK: NSCopying
    
    public func copyWithZone(zone: NSZone) -> AnyObject
    {
        return self.dynamicType.init(bubbleImage: UIImage(CGImage: self.messageBubbleImage!.CGImage!), highlightedImage: UIImage(CGImage: self.messageBubbleHighlightedImage!.CGImage!))
    }
}