//
//  SChat.swift
//  Pods
//
//  Created by David Moreno Lora on 26/4/16.
//
//

import Foundation
import UIKit
import RealmSwift

public class SChat: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    public dynamic var id = -1
    public let messages = List<SMessage>()
    public let chatUsers = List<SUser>()
}
