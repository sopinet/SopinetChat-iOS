//
//  SChatUIView.swift
//  Pods
//
//  Created by David Moreno Lora on 1/5/16.
//
//

import Foundation

extension UIView
{
    func sChatPinSubviewToEdge(subview:UIView, edge: NSLayoutAttribute) {
        self.addConstraint(NSLayoutConstraint(item: self,
            attribute: edge,
            relatedBy: NSLayoutRelation.Equal,
            toItem: subview,
            attribute: edge,
            multiplier: 1.0,
            constant: 0.0))
    }
    
    func sChatPinAllEdgesOfSubview(subview: UIView) {
        sChatPinSubviewToEdge(subview, edge: NSLayoutAttribute.Bottom)
        sChatPinSubviewToEdge(subview, edge: NSLayoutAttribute.Top)
        sChatPinSubviewToEdge(subview, edge: NSLayoutAttribute.Leading)
        sChatPinSubviewToEdge(subview, edge: NSLayoutAttribute.Trailing)
    }
}