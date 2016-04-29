//
//  SUser.swift
//  Pods
//
//  Created by David Moreno Lora on 26/4/16.
//
//

import Foundation
import UIKit

public class SUser {
    
    public dynamic var id = -1
    public let chats: [SChat]
    public let messages: [SMessage]
    
    init(id: Int, chats: [SChat], messages: [SMessage])
    {
        self.id = id
        self.chats = chats
        self.messages = messages
    }
}
