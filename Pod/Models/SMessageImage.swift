//
//  SMessageImage.swift
//  Pods
//
//  Created by David Moreno Lora on 26/4/16.
//
//

import Foundation
import UIKit

public class SMessageImage: SMessage {
    
    public var file: SImageFile?
    
    init(id: Int, data: NSData, dateString: String, read: Int, state: Int, text: String, time: Int, chat: SChat, fromUser: SUser, file: SImageFile)
    {
        super.init(id: id, data: data, dateString: dateString, read: read, state: state, text: text, time: time, chat: chat, fromUser: fromUser)
        self.file = file
    }
}
