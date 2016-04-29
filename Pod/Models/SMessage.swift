//
//  SMessage.swift
//  Pods
//
//  Created by David Moreno Lora on 26/4/16.
//
//

import Foundation
import UIKit

public class SMessage {
    
    public dynamic var id = -1
    public dynamic var data: NSData?
    public dynamic var dateString = ""
    public dynamic var read = 0
    public dynamic var state = 0
    public dynamic var text = ""
    public dynamic var time = -1
    public var chat: SChat?
    public var fromUser: SUser?
    
    init(id: Int, data: NSData, dateString: String, read: Int, state: Int, text: String, time: Int, chat: SChat, fromUser: SUser)
    {
        self.id = id
        self.data = data
        self.dateString = dateString
        self.read = read
        self.state = state
        self.text = text
        self.time = time
        self.chat = chat
        self.fromUser = fromUser
    }
}
