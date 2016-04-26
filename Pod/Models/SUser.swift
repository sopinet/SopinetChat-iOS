//
//  SUser.swift
//  Pods
//
//  Created by David Moreno Lora on 26/4/16.
//
//

import Foundation
import UIKit
import RealmSwift

public class SUser: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    public dynamic var id = -1
    public let chats = List<SChat>()
    public let messages = List<SMessage>()
}
