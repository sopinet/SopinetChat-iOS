//
//  SChatCollectionViewDelegateFlowLayout.swift
//  Pods
//
//  Created by David Moreno Lora on 18/5/16.
//
//

import Foundation

public protocol SChatCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout
{
    // MARK: Functions
    
    func collectionView(collectionView: SChatCollectionView,
                        layout: SChatCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> Float
    
    func collectionView(collectionView: SChatCollectionView,
                        layout: SChatCollectionViewFlowLayout, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> Float
    
    func collectionView(collectionView: SChatCollectionView,
                        layout: SChatCollectionViewFlowLayout, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath) -> Float
    
    func collectionView(collectionView: SChatCollectionView,
                        didTapAvatarImageView avatarImageView: UIImageView, atIndexPath indexPath: NSIndexPath)
    
    func collectionView(collectionView: SChatCollectionView,
                        didTapMessageBubbleAtIndexPath indexPath: NSIndexPath)
    
    func collectionView(collectionView: SChatCollectionView,
                        didTapCellAtIndexPath indexPath: NSIndexPath,
                                              touchLocation touchLocation: CGPoint)
    
    func collectionView(collectionView: SChatCollectionView,
                        header: SChatLoadEarlierHeaderView, didTapLoadEarlierMessagesButton sender: UIButton)
}