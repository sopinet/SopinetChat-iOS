//
//  SChatCollectionView.swift
//  Pods
//
//  Created by David Moreno Lora on 28/4/16.
//
//

import UIKit

public class SChatCollectionView: UICollectionView
{
    // MARK: Properties
    
    weak var dataSourceInterceptor: SChatCollectionViewDataSource?
    
    override public var dataSource: UICollectionViewDataSource? {
        didSet {
            if dataSource != nil {
                //let castedDelegate = unsafeBitCast(delegate, SChatInputToolbarDelegate.self)
                let castedDelegate: SChatCollectionViewDataSource = dataSource as! SChatCollectionViewDataSource
                dataSourceInterceptor = castedDelegate
            }
            else {
                dataSourceInterceptor = nil
            }
        }
    }
}
