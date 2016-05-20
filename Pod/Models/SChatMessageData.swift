//
//  File.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation

public protocol SChatMessageData
{
    var senderId: String? { set get }
    
    var senderDisplayName: String? { set get }
    
    var date: NSDate? { set get }
    
    var text: String? { set get }
    
    var media: SChatMediaData? { set get }
    
    var isMediaMessage: Bool? { set get }
    
    var messageHash: UInt? { set get }
}