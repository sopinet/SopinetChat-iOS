//
//  SChatAvatarImageFactory.swift
//  Pods
//
//  Created by David Moreno Lora on 22/5/16.
//
//

import Foundation

public class SChatAvatarImageFactory: NSObject
{
    // MARK: Public
    
    public static func avatarImageWithPlaceholder(placeholderImage: UIImage,
                                                  diameter: UInt) -> SChatAvatarImage
    {
        let circlePlaceholderImage = SChatAvatarImageFactory.sChatCircularImage(placeholderImage,
                                                                                withDiameter: diameter,
                                                                                highlightedColor: nil)
        
        return SChatAvatarImage.avatarImageWithPlaceholder(circlePlaceholderImage)
    }
    
    public static func avatarImageWithImage(image: UIImage,
                                            diameter: UInt) -> SChatAvatarImage
    {
        let avatar = SChatAvatarImageFactory.circularAvatarImage(image,
                                                                 withDiameter: diameter)
        let highlightedAvatar = SChatAvatarImageFactory.circularAvatarHighlightedImage(image,
                                                                                       withDiameter: diameter)
        
        return SChatAvatarImage(avatarImage: avatar,
                                highlightedImage: highlightedAvatar,
                                placeholderImage: avatar)
    }
    
    public static func circularAvatarImage(image: UIImage,
                                           withDiameter diameter: UInt) -> UIImage
    {
        return SChatAvatarImageFactory.sChatCircularImage(image,
                                                          withDiameter: diameter, highlightedColor: nil)
    }
    
    public static func circularAvatarHighlightedImage(image: UIImage, withDiameter diameter: UInt) -> UIImage
    {
        return SChatAvatarImageFactory.sChatCircularImage(image,
                                                          withDiameter: diameter,
                                                          highlightedColor: UIColor(white: 0.1, alpha: 0.3))
    }
    
    public static func avatarImageWithUserInitials(userInitials: String,
                                                   backgroundColor: UIColor,
                                                   textColor: UIColor,
                                                   font: UIFont,
                                                   diameter: UInt) -> SChatAvatarImage
    {
        let avatarImage = SChatAvatarImageFactory.sChatImageWithInitials(userInitials,
                                                                         backgroundColor: backgroundColor,
                                                                         textColor: textColor, font: font,
                                                                         diameter: diameter)
        
        let avatarHighlightedImage = SChatAvatarImageFactory.sChatCircularImage(avatarImage,
                                                                                withDiameter: diameter,
                                                                                highlightedColor: UIColor(white: 0.1, alpha: 0.3))
        
        return SChatAvatarImage(avatarImage: avatarImage,
                                highlightedImage: avatarHighlightedImage,
                                placeholderImage: avatarHighlightedImage)
    }
    
    // MARK: Private
    
    private static func sChatImageWithInitials(initials: String,
                                               backgroundColor: UIColor,
                                               textColor: UIColor,
                                               font: UIFont,
                                               diameter: UInt) -> UIImage
    {
        assert(diameter > 0, "The diameter should be greater than 0 in sChatImageWithInitials function.")
        
        let frame = CGRectMake(0.0, 0.0, CGFloat(diameter), CGFloat(diameter))
        
        let attributes = [NSFontAttributeName: font,
                          NSForegroundColorAttributeName: textColor]
        
        let textFrame = (initials as! NSString).boundingRectWithSize(frame.size,
                                                                     options: [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading],
                                                                     attributes: attributes, context: nil)
        
        let frameMidPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        
        let textFrameMidPoint = CGPointMake(CGRectGetMidX(textFrame), CGRectGetMidY(textFrame))
        
        let dx: CGFloat = frameMidPoint.x - textFrameMidPoint.x
        let dy: CGFloat = frameMidPoint.y - textFrameMidPoint.y
        let drawPoint = CGPointMake(dx, dy)
        var image: UIImage? = nil
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
        CGContextFillRect(context, frame)
        (initials as! NSString).drawAtPoint(drawPoint, withAttributes: attributes)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return SChatAvatarImageFactory.sChatCircularImage(image!,
                                                          withDiameter: diameter,
                                                          highlightedColor: nil)
    }
    
    private static func sChatCircularImage(image: UIImage?,
                                           withDiameter diameter: UInt,
                                                        highlightedColor: UIColor?) -> UIImage
    {
        assert(image != nil, "The image is nil in sChatCircularImage function")
        assert(diameter > 0, "The diameter should be greater than 0 in sChatCircularImage")
        
        let frame = CGRectMake(0.0, 0.0, CGFloat(diameter), CGFloat(diameter))
        var newImage: UIImage? = nil
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        let imgPath = UIBezierPath(ovalInRect: frame)
        imgPath.addClip()
        image?.drawInRect(frame)
        
        if let _highlightedColor = highlightedColor
        {
            CGContextSetFillColorWithColor(context, _highlightedColor.CGColor)
            CGContextFillEllipseInRect(context, frame)
        }
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}