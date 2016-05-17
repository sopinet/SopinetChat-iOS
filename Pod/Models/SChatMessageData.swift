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
    var senderId: String { get }
    
    var senderDisplayName: String { get }
    
    var date: String { get }
    
    var text: String? { get }
    
    var media: SChatMediaData? { get }
    
    func isMediaMessage() -> Bool
    
    func messageHash() -> UInt
}