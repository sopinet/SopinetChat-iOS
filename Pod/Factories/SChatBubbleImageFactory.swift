//
//  SChatBubbleImageFactory.swift
//  Pods
//
//  Created by David Moreno Lora on 20/5/16.
//
//

import Foundation

public class SChatBubbleImageFactory: NSObject
{
    // MARK: Properties
    
    var bubbleImage: UIImage?
    
    var capInsets: UIEdgeInsets?
    
    // MARK: Initialization
    
    override convenience public init()
    {
        self.init(bubbleImage: UIImage.sChatBubbleCompactImage(), capInsets: UIEdgeInsetsZero)
    }
    
    public init(bubbleImage: UIImage, capInsets: UIEdgeInsets)
    {
        super.init()
        
        self.bubbleImage = bubbleImage
        
        if UIEdgeInsetsEqualToEdgeInsets(capInsets, UIEdgeInsetsZero)
        {
            self.capInsets = sChatCenterPointEdgeInsetsForImageSize(bubbleImage.size)
        }
        else
        {
            self.capInsets = capInsets
        }
    }
    
    // MARK: Public
    
    public func outgoingMessageBubbleImageWithColor(color: UIColor) -> SChatBubbleImage
    {
        return self.sChatMessagesBubbleImageWithColor(color, flippedForIncoming: false)
    }
    
    public func incomingMessageBubbleImageWithColor(color: UIColor) -> SChatBubbleImage
    {
        return self.sChatMessagesBubbleImageWithColor(color, flippedForIncoming: true)
    }
    
    // MARK: Private
    
    func sChatCenterPointEdgeInsetsForImageSize(bubbleImageSize: CGSize) -> UIEdgeInsets
    {
        let center = CGPointMake(bubbleImageSize.width / 2.0, bubbleImageSize.height / 2.0)
        
        return UIEdgeInsetsMake(center.y, center.x, center.y, center.x)
    }
    
    func sChatMessagesBubbleImageWithColor(color: UIColor, flippedForIncoming: Bool) -> SChatBubbleImage
    {
        var normalBubble = self.bubbleImage!.sChatImageMaskedWithColor(color)
        
        var highlightedImage = self.bubbleImage!.sChatImageMaskedWithColor(color) // TODO: Colorbydarkeringcolorwithvalue()
        
        if flippedForIncoming
        {
            normalBubble = self.sChatStretchableImageFromImage(normalBubble, withCapInsets: self.capInsets!)
            highlightedImage = self.sChatHorizontallyFlippedImageFromImage(highlightedImage)
        }
        
        normalBubble = self.sChatStretchableImageFromImage(normalBubble, withCapInsets: self.capInsets!)
        
        return SChatBubbleImage(bubbleImage: normalBubble, highlightedImage: highlightedImage)
    }
    
    func sChatHorizontallyFlippedImageFromImage(image: UIImage) -> UIImage
    {
        return UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.UpMirrored)
    }
    
    func sChatStretchableImageFromImage(image: UIImage, withCapInsets capInsets: UIEdgeInsets) -> UIImage
    {
        return image.resizableImageWithCapInsets(capInsets, resizingMode: UIImageResizingMode.Stretch)
    }
}