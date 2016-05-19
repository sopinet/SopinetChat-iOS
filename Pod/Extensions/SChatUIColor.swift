//
//  SChatUIColor.swift
//  Pods
//
//  Created by David Moreno Lora on 29/4/16.
//
//

import Foundation

let blueBubbleColor = 0x007AFF

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    public static func sChatMessageBubbleGreenColor() -> UIColor
    {
        return UIColor(hue:130 / 360, saturation: 0.68, brightness: 0.84, alpha: 1.0)
    }
    
    public static func sChatMessageBubbleBlueColor() -> UIColor
    {
        return UIColor(hue:210 / 360, saturation: 0.94, brightness: 1.0, alpha: 1.0)
    }
    
    public static func sChatMessageBubbleRedColor() -> UIColor
    {
        return UIColor(hue:0 / 360, saturation: 0.79, brightness: 1.0, alpha: 1.0)
    }
    
    public static func sChatMessageBubbleLightGrayColor() -> UIColor
    {
        return UIColor(hue:240 / 360, saturation: 0.02, brightness: 0.92, alpha: 1.0)
    }
}