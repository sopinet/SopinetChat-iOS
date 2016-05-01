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