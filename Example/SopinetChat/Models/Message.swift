//
//  Message.swift
//  SopinetChat
//
//  Created by David Moreno Lora on 20/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SopinetChat

public class Message: NSObject, SChatMessageData, NSCoding
{
    // MARK: Properties
    
    public var senderId: String?
    
    public var senderDisplayName: String?
    
    public var date: NSDate?
    
    public var text: String?
    
    public var media: SChatMediaData?
    
    public var isMediaMessage: Bool?
    
    public var messageHash: UInt?
    
    // MARK: Initialization
    
    public init(senderId: String,
                         senderDisplayName: String,
                         date: NSDate?,
                         text: String?,
                         media: SChatMediaData?,
                         isMediaMessage: Bool)
    {   
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.date = date
        self.text = text
        self.media = media
        self.isMediaMessage = isMediaMessage
    }
    /*override convenience public init()
    {
        assert(false, "init() is not a valid initializer for SChatMessageData.")
        self.init(senderId: "", displayName: "", text: "")
    }
    
    convenience public init(senderId: String,
         displayName: String,
         text: String)
    {
        self.init()
        
        self.senderId = senderId
        self.senderDisplayName = displayName
        self.date = NSDate()
        self.text = text
        self.messageHash = UInt(self.hash)
    }
    
    convenience required public init(senderId: String,
         senderDisplayName: String,
         date: NSDate,
         text: String)
    {
        self.init()
        
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.date = date
        self.text = text
        self.messageHash = UInt(self.hash)
    }
    
    convenience public init(senderId: String,
                displayName: String,
                media: SChatMediaData)
    {
        self.init()
        
        self.senderId = senderId
        self.senderDisplayName = displayName
        self.date = NSDate()
        self.media = media
        self.messageHash = UInt(self.hash)
    }
    
    convenience required public init(senderId: String,
         senderDisplayName: String,
         date: NSDate,
         media: SChatMediaData)
    {
        self.init()
        
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.date = date
        self.isMediaMessage = true
        self.media = media
        self.messageHash = UInt(self.hash)
    }
    
    public init(senderId: String,
         senderDisplayName: String,
         date: NSDate,
         isMedia: Bool)
    {
        super.init()
        self.senderId = senderId
        self.senderDisplayName = senderDisplayName
        self.date = date
        self.isMediaMessage = isMedia
        self.messageHash = UInt(self.hash)
    }*/
    
    deinit
    {
        self.senderId = nil
        self.senderDisplayName = nil
        self.date = nil
        self.text = nil
        self.media = nil
    }
    
    // MARK: NSObject
    
    public override func isEqual(object: AnyObject?) -> Bool
    {
        if self.isEqual(object)
        {
            return true
        }
        
        if !object!.isKindOfClass(self.dynamicType)
        {
            return false
        }
        
        let aMessage: Message  = object as! Message
        
        if self.isMediaMessage != aMessage.isMediaMessage
        {
            return false
        }
        
        // TODO: Implement MediaItem
        let hasEqualContent = self.isMediaMessage! ? false : self.text! == aMessage.text!
        
        return self.senderId == aMessage.senderId
            && self.senderDisplayName == aMessage.senderDisplayName
            && self.date!.compare(aMessage.date!) == NSComparisonResult.OrderedSame
            && hasEqualContent
    }
    
    override public var hash: Int
    {
        let contentHash = self.isMediaMessage! ? Int(self.media!.mediaHash) : self.text!.hash
        
        return self.senderId!.hash ^ self.date!.hash ^ contentHash
    }
    
    override public var description: String
    {
        return "<\(self.dynamicType): senderId=\(self.senderId), senderDisplayName=\(self.senderDisplayName), date=\(self.date), isMediaMessage=\(self.isMediaMessage), text=\(text), media=\(media)"
    }
    
    func debugQuickLookObject() -> AnyObject?
    {
        if let auxMedia = self.media
        {
            return nil
            // TODO: return auxMedia.mediaView == nil ? nil : auxMedia.mediaPlaceholderView
        } else
        {
            return nil
        }
    }
    
    // MARK: NSCoding
    
    public required init?(coder aDecoder: NSCoder)
    {
        self.senderId = aDecoder.decodeObjectForKey(NSStringFromSelector(Selector("senderId"))) as? String
        self.senderDisplayName = aDecoder.decodeObjectForKey(NSStringFromSelector(Selector("senderDisplayName"))) as? String
        self.date = aDecoder.decodeObjectForKey(NSStringFromSelector(Selector("date"))) as? NSDate
        self.isMediaMessage = aDecoder.decodeObjectForKey(NSStringFromSelector(Selector("isMediaMessage"))) as? Bool
        self.text = aDecoder.decodeObjectForKey(NSStringFromSelector(Selector("text"))) as? String
        self.media = aDecoder.decodeObjectForKey(NSStringFromSelector(Selector("media"))) as? SChatMediaData
    }
    
    public func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.senderId, forKey: NSStringFromSelector(Selector("senderId")))
        aCoder.encodeObject(self.senderDisplayName, forKey: NSStringFromSelector(Selector("senderDisplayName")))
        aCoder.encodeObject(self.date, forKey: NSStringFromSelector(Selector("date")))
        aCoder.encodeObject(self.isMediaMessage, forKey: NSStringFromSelector(Selector("isMediaMessage")))
        aCoder.encodeObject(self.text, forKey: NSStringFromSelector(Selector("text")))
        
        /* TODO: if let media = self.media as! SChatMediaData
        {
            aCoder.encodeObject(self.media, forKey: NSStringFromSelector(Selector("media")))
        }*/
    }
    
    // MARK: NSCoding
    
    /*public func copyWithZone(zone: NSZone) -> AnyObject
    {
        if self.isMediaMessage!
        {
            return self.dynamicType.init(senderId: self.senderId!,
                                         senderDisplayName: self.senderDisplayName!,
                                         date: self.date!,
                                         media: self.media!)
        }
        else
        {
            return self.dynamicType.init(senderId: self.senderId!,
                                         senderDisplayName: self.senderDisplayName!,
                                         date: self.date!,
                                         text: self.text!)
        }
    }*/
}