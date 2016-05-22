//
//  SChatKeyboardControllerDelegate.swift
//  Pods
//
//  Created by David Moreno Lora on 3/5/16.
//
//

import Foundation

public protocol SChatKeyboardControllerDelegate
{
    // MARK: Abstract functions
    
    func keyboardDidChangeFrame(keyboardFrame: CGRect)
}
