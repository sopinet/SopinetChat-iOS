//
//  SChatAvatarImageDataSource.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation

public protocol SChatAvatarImageDataSource
{
    var avatarImage: UIImage { get }
    
    var avatarHighlightedImage: UIImage { get }
    
    var avatarPlaceholderImage: UIImage { get }
}