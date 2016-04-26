//
//  SMessageImage.swift
//  Pods
//
//  Created by David Moreno Lora on 26/4/16.
//
//

import Foundation
import UIKit
import RealmSwift

public class SMessageImage: SMessage {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    public dynamic var file: SImageFile?
}
