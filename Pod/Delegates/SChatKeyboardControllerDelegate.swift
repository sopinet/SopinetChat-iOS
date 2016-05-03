//
//  SChatKeyboardControllerDelegate.swift
//  Pods
//
//  Created by David Moreno Lora on 3/5/16.
//
//

import Foundation
import UIKit

public protocol SChatKeyboardControllerDelegate: class
{
    // MARK: Abstract functions
    
    func keyboardDidChangeFrame(keyboardFrame: CGRect)
}
