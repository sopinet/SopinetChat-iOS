//
//  SImageFile.swift
//  Pods
//
//  Created by David Moreno Lora on 26/4/16.
//
//

import Foundation
import UIKit

public class SImageFile {
    
    public dynamic var id = -1
    public dynamic var path = ""
    public var message: SMessageImage?
    
    init(id: Int, path: String, message: SMessageImage)
    {
        self.id = id
        self.path = path
        self.message = message
    }
}
