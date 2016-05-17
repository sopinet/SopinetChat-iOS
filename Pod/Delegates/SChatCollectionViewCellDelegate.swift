//
//  SChatCollectionViewCellDelegate.swift
//  Pods
//
//  Created by David Moreno Lora on 15/5/16.
//
//

import Foundation

public protocol SChatCollectionViewCellDelegate
{
    // MARK: Functions
    
    func messagesCollectionViewCellDidTapAvatar(cell: SChatCollectionViewCell)
    
    func messagesCollectionViewCellDidTapMessageBubble(cell: SChatCollectionViewCell)
    
    func messagesCollectionViewCellDidTapCell(cell: SChatCollectionViewCell, atPosition position: CGPoint)
    
    func messagesCollectionViewCell(cell: SChatCollectionViewCell, didPerformAction action: Selector, withSender sender: AnyObject?)
}
