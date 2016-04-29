//
//  SChat.swift
//  Pods
//
//  Created by David Moreno Lora on 26/4/16.
//
//

import Foundation
import UIKit

public class SChat {
    
    public dynamic var id = -1
    public let messages: [SMessage]
    public let chatUsers: [SUser]
    
    init(id: Int, messages: [SMessage], chatUsers: [SUser])
    {
        self.id = id
        self.messages = messages
        self.chatUsers = chatUsers
    }
}
