//
//  SChatToolbarView.swift
//  Pods
//
//  Created by David Moreno Lora on 28/4/16.
//
//

import UIKit

class SChatToolbarView: UIView {

    // MARK: Outlets
    
    @IBOutlet weak var leftButtonVIew: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var rightButtonView: UIView!
    
    // MARK: Actions
    
    
    // MARK: Properties
    
    weak var leftBarButtomItem: UIButton?
    weak var rightBarButtomItem: UIButton?
}
