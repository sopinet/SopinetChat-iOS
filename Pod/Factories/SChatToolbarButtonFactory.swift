//
//  SChatToolbarButtonFactory.swift
//  Pods
//
//  Created by David Moreno Lora on 29/4/16.
//
//

import UIKit
import Foundation

class SChatToolbarButtonFactory {
    
    // MARK: Functions
    
    static func defaultAccessoryButtonItem() -> UIButton
    {
        // TODO: Improve this with mask for other states
        
        let accessoryImage: UIImage = UIImage(named: "clipIcon")!
        
        let accessoryButton: UIButton = UIButton(frame: CGRectMake(0.0, 0.0, accessoryImage.size.width, 32.0))
        accessoryButton.setImage(accessoryImage, forState: .Normal)
        
        accessoryButton.contentMode = .ScaleAspectFit
        accessoryButton.backgroundColor = UIColor.clearColor()
        accessoryButton.tintColor = UIColor.lightGrayColor()
        
        accessoryButton.accessibilityLabel = NSLocalizedString("schat_share_media", comment: "")
        
        return accessoryButton
    }
    
    static func defaultSendButtonItem() -> UIButton
    {
        let sendTitle: NSString = NSLocalizedString("schat_send", comment: "")
        
        let sendButton = UIButton(frame: CGRectZero)
        sendButton.setTitle(sendTitle as String, forState: .Normal)
        
        // TODO: Maybe we should improve color system for different states
        
        sendButton.tintColor = UIColor(netHex: blueBubbleColor)
        
        sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17.0)
        sendButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        sendButton.titleLabel?.minimumScaleFactor = 0.85;
        sendButton.contentMode = .Center
        sendButton.backgroundColor = UIColor.clearColor()
        
        let maxHeight: CGFloat = 32.0
        
        let sendTitleRect = sendTitle.boundingRectWithSize(CGSizeMake(CGFloat.max, maxHeight),
                                                                          options: [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading],
                                                                          attributes: [NSFontAttributeName : (sendButton.titleLabel?.font)!],
                                                                          context: nil)
        
        sendButton.frame = CGRectMake(0.0,
                                      0.0, CGRectGetWidth(CGRectIntegral(sendTitleRect)),
                                      maxHeight)
        
        return sendButton
    }

}
