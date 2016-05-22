//
//  ChatViewController.swift
//  SopinetChat
//
//  Created by David Moreno Lora on 30/4/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Foundation
import SopinetChat

class ChatViewController: SChatViewController
{
    // MARK: Properties
    
    var messages: [Message] = []
    
    var outgoingBubbleImageView: SChatBubbleImage!
    var incomingBubbleImageView: SChatBubbleImage!
    
    // MARK: Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        schatview.frame = self.view.frame
        self.view.addSubview(schatview)
        
        setupBubbles()
        
        //self.sChatCollectionView.collectionViewLayoutInterceptor?.incomingAvatarViewSize = CGSizeMake(30.0, 30.0)
        //self.sChatCollectionView.collectionViewLayoutInterceptor?.outgoingAvatarViewSize = CGSizeMake(30.0, 30.0)
    }
    
    // MARK: Functions
    
    override func collectionView(collectionView: SChatCollectionView, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> SChatMessageData?
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(collectionView: SChatCollectionView, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> SChatBubbleImageDataSource?
    {
        let message = messages[indexPath.item]
        
        if message.senderId == senderId
        {
            return outgoingBubbleImageView
        }
        else
        {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell: SChatCollectionViewCell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! SChatCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId
        {
            cell.textView!.textColor = UIColor.whiteColor()
        }
        else
        {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: SChatCollectionView, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> SChatAvatarImageDataSource?
    {
        return SChatAvatarImageFactory.avatarImageWithUserInitials("DM",
                                                                   backgroundColor: UIColor.lightGrayColor(),
                                                                   textColor: UIColor.darkGrayColor(),
                                                                   font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
                                                                   diameter: 40)
    }
    
    override func collectionView(collectionView: SChatCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString?
    {
        let message = self.messages[indexPath.item]
        
        if let date = message.date
        {
            return NSAttributedString(string: "Hoy, 19:23")
        }
        else
        {
            return nil
        }
    }
    
    override func collectionView(collectionView: SChatCollectionView, layout: SChatCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> Float
    {
        return Float(kSChatCollectionViewCellLabelHeightDefault)
    }
    
    override func collectionView(collectionView: SChatCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString?
    {
        let message = self.messages[indexPath.item]
        
        if let displayName = message.senderDisplayName
        {
            return NSAttributedString(string: displayName)
        }
        else
        {
            return nil
        }
    }
    
    override func collectionView(collectionView: SChatCollectionView, layout: SChatCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> Float
    {
        return Float(kSChatCollectionViewCellLabelHeightDefault)
    }
    
    /*override func collectionView(collectionView: SChatCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString?
    {
        let message = self.messages[indexPath.item]
        
        if let date = message.date
        {
            return NSAttributedString(string: date.description)
        }
        else
        {
            return nil
        }
    }
    
    override func collectionView(collectionView: SChatCollectionView, layout: SChatCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> Float
    {
        return Float(kSChatCollectionViewCellLabelHeightDefault)
    }*/
    
    func addMessage(id: String, text: String)
    {
        //let message = Message(senderId: id, displayName: "", text: text)
        let message = Message(senderId: id,
                              senderDisplayName: "David",
                              date: NSDate(),
                              text: text,
                              media: nil,
                              isMediaMessage: false)
        
        messages.append(message)
    }
    
    override func didPressSendButton(button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: NSDate)
    {
        addMessage(senderId, text: text)
        finishSendingMessage()
    }
    
    func setupBubbles()
    {
        let bubbleImageFactory = SChatBubbleImageFactory()
        
        outgoingBubbleImageView = bubbleImageFactory.outgoingMessageBubbleImageWithColor(UIColor.sChatMessageBubbleBlueColor())
        incomingBubbleImageView = bubbleImageFactory.incomingMessageBubbleImageWithColor(UIColor.sChatMessageBubbleLightGrayColor())
    }
}
