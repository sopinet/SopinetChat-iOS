//
//  ChatViewController.swift
//  SopinetChat
//
//  Created by David Moreno Lora on 30/4/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Foundation
import SopinetChat

class ChatViewController: SChatViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        schatview.frame = self.view.frame
        self.view.addSubview(schatview)
        
        
    }

}
