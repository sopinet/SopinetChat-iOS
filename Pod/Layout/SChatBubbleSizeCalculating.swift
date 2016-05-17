//
//  File.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation

public protocol SChatBubbleSizeCalculating
{
    func messageBubbleForMessageData(messageData: SChatMessageData,
                                     atIndexPath indexPath: NSIndexPath,
                                                 withLayout layout: SChatCollectionViewFlowLayout)
    
    func prepareForResettingLayout(layout: SChatCollectionViewFlowLayout)
}
