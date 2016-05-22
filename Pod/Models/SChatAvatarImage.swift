//
//  SChatAvatarImage.swift
//  Pods
//
//  Created by David Moreno Lora on 22/5/16.
//
//

import Foundation

public class SChatAvatarImage: NSObject, SChatAvatarImageDataSource, NSCopying
{
    // MARK: Properties
    
    public var avatarImage: UIImage?
    
    public var avatarHighlightedImage: UIImage?
    
    public var avatarPlaceholderImage: UIImage?
    
    // MARK: Initialization
    
    public static func avatarWithImage(image: UIImage) -> SChatAvatarImage
    {
        return self.init(avatarImage: image,
                    highlightedImage: image,
                    placeholderImage: image)
    }
    
    public static func avatarImageWithPlaceholder(placeholderImage: UIImage) -> SChatAvatarImage
    {
        return self.init(avatarImage: nil,
                  highlightedImage: nil,
                  placeholderImage: placeholderImage)
    }
    
    override convenience init()
    {
        assert(false, "init() is not a valid initializer for SChatAvatarImage. Use init(avatarImage, highlightedImage, placeholderImage) instead.")
        self.init()
    }
    
    required public convenience init(avatarImage: UIImage?,
                                     highlightedImage: UIImage?,
                                     placeholderImage: UIImage?)
    {
        self.init(avatarImage: avatarImage,
                  highlightedImage: highlightedImage,
                  placeholderImage: placeholderImage,
                  nilParameter: nil)
    }
    
    init(avatarImage: UIImage?,
         highlightedImage: UIImage?,
         placeholderImage: UIImage?,
         nilParameter: AnyObject?)
    {
        self.avatarImage = avatarImage
        self.avatarHighlightedImage = highlightedImage
        self.avatarPlaceholderImage = placeholderImage
    }
    
    // MARK: NSObject
    
    override public var description: String
        {
        get {
            return "<\(self.dynamicType): avatarImage=\(self.avatarImage), avatarHighlightedImage=\(self.avatarHighlightedImage), avatarPlaceholderImage=\(self.avatarPlaceholderImage)"
        }
    }
    
    func debugQuickLookObject() -> AnyObject
    {
        return UIImageView(image: self.avatarImage, highlightedImage: self.avatarHighlightedImage)
    }
    
    // MARK: NSCopying
    
    public func copyWithZone(zone: NSZone) -> AnyObject
    {
        return self.dynamicType.init(avatarImage: UIImage(CGImage: self.avatarImage!.CGImage!),
                                     highlightedImage: UIImage(CGImage: self.avatarHighlightedImage!.CGImage!),
                                     placeholderImage: UIImage(CGImage: self.avatarPlaceholderImage!.CGImage!))
    }
}