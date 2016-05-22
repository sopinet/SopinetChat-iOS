//
//  SChatNSBundle.swift
//  Pods
//
//  Created by David Moreno Lora on 1/5/16.
//
//

import Foundation

extension NSBundle
{
    static func sChatBundle() -> NSBundle
    {
        return NSBundle(forClass: SopinetChat.self)
    }
    
    static func sChatAssetBundle() -> NSBundle
    {
        let bundleResourcePath = NSBundle.sChatBundle().resourcePath
        let assetPath = bundleResourcePath! + "/SChatAssets.bundle"
        
        return NSBundle(path: assetPath)!
    }
    
    static func sChatLocalizedStringForKey(key: String) -> String
    {
        return NSLocalizedString(key, tableName: "Localizable", bundle: NSBundle.sChatAssetBundle(), comment: "")
    }
}