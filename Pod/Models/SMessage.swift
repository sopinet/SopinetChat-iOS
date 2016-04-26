//
//  SMessage.swift
//  Pods
//
//  Created by David Moreno Lora on 26/4/16.
//
//

import Foundation
import UIKit
import RealmSwift

public class SMessage: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    public dynamic var id = -1
    public dynamic var data: NSData?
    public dynamic var dateString = ""
    public dynamic var read = 0
    public dynamic var state = 0
    public dynamic var text = ""
    public dynamic var time = -1
    public dynamic var chat: SChat?
    public dynamic var fromUser: SUser?
}
