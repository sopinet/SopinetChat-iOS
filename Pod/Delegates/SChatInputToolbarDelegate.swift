//
//  SChatToolbarViewDelegate.swift
//  Pods
//
//  Created by David Moreno Lora on 28/4/16.
//
//

import Foundation
import UIKit

protocol SChatInputToolbarDelegate : UIToolbarDelegate
{
    // MARK: Abstract Functions
    
    func attachButtonTapped(sender: AnyObject)
    func sendButtonTapped(sender: AnyObject)
}