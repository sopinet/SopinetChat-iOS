//
//  SChatUIImage.swift
//  Pods
//
//  Created by David Moreno Lora on 1/5/16.
//
//

import Foundation

extension UIImage
{
    func sChatImageMaskedWithColor(maskColor: UIColor) -> UIImage
    {
        let imageRect = CGRectMake(0.0, 0.0, self.size.width, self.size.height)
        var newImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -(imageRect.size.height))
        
        CGContextClipToMask(context, imageRect, self.CGImage)
        CGContextSetFillColorWithColor(context, maskColor.CGColor)
        CGContextFillRect(context, imageRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func sChatImageFromBundleWithName(name: String) -> UIImage
    {
        let bundle = NSBundle.sChatAssetBundle()
        let path = bundle.pathForResource(name, ofType: "png", inDirectory: "Images")
        return UIImage(contentsOfFile: path!)!
    }
    
    static func sChatBubbleRegularImage() -> UIImage
    {
        return UIImage.sChatImageFromBundleWithName("bubble_regular")
    }
    
    static func sChatBubbleRegularTaillessImage() -> UIImage
    {
        return UIImage.sChatImageFromBundleWithName("bubble_tailless")
    }
    
    static func sChatBubbleStrokedImage() -> UIImage
    {
        return UIImage.sChatImageFromBundleWithName("bubble_stroked")
    }
    
    static func sChatBubbleStrokedTaillessImage() -> UIImage
    {
        return UIImage.sChatImageFromBundleWithName("bubble_stroked_tailless")
    }
    
    static func sChatBubbleCompactImage() -> UIImage
    {
        return UIImage.sChatImageFromBundleWithName("bubble_min")
    }
    
    static func sChatBubbleCompactTaillessImage() -> UIImage
    {
        return UIImage.sChatImageFromBundleWithName("bubble_min_tailless")
    }
    
    static func sChatDefaultAccesoryImage() -> UIImage
    {
        return sChatImageFromBundleWithName("clip")
    }
    
    static func sChatDefaultTypingIndicatorImage() -> UIImage
    {
        return UIImage.sChatImageFromBundleWithName("typing")
    }
    
    static func sChatDefaultPlayImage() -> UIImage
    {
        return UIImage.sChatImageFromBundleWithName("play")
    }
}