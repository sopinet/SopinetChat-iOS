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
    
    static func sChatDefaultAccesoryImage() -> UIImage
    {
        return sChatImageFromBundleWithName("clip")
    }
}