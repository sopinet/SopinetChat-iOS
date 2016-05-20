//
//  SChatBubbleImageDataSource.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation

public protocol SChatBubbleImageDataSource
{
    var messageBubbleImage: UIImage? { get }
    
    var messageBubbleHighlightedImage: UIImage? { get }
}