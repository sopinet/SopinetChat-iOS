//
//  SChatMediaData.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation

public protocol SChatMediaData
{
    var mediaView: UIView { get }
    
    var mediaViewDisplaySize: CGSize { get }
    
    var mediaHash: UInt { get }
}