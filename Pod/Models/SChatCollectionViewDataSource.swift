//
//  SChatCollectionViewDataSource.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation

public protocol SChatCollectionViewDataSource: UICollectionViewDataSource
{
    // MARK: Properties
    
    var senderDisplayName: String { get }
    
    var senderId: String { get }
    
    // MARK: Functions
    
    func collectionView(collectionView: SChatCollectionView, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> SChatMessageData
    
    func collectionView(collectionView: SChatCollectionView, didDeleteMessageAtIndexPath indexPath: NSIndexPath)
    
    func collectionView(collectionView: SChatCollectionView, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> SChatBubbleImageDataSource
    
    func collectionView(collectionView: SChatCollectionView, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> SChatAvatarImageDataSource
    
    func collectionView(collectionView: SChatCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString
    
    func collectionView(collectionView: SChatCollectionView, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString
    
    func collectionView(collectionView: SChatCollectionView, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString
}