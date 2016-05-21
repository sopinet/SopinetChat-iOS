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
        
        self.sChatCollectionView.collectionViewLayoutInterceptor?.incomingAvatarViewSize = CGSizeZero
        self.sChatCollectionView.collectionViewLayoutInterceptor?.outgoingAvatarViewSize = CGSizeZero
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
        return nil
    }
    
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
        
        print("Messages count: \(messages.count) - CollectionView Items: \(self.sChatCollectionView.numberOfItemsInSection(0))")
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
