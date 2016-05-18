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
                let castedDataSource: SChatCollectionViewDataSource = dataSource as! SChatCollectionViewDataSource
                dataSourceInterceptor = castedDataSource
            }
            else {
                dataSourceInterceptor = nil
            }
        }
    }
    
    weak var delegateInterceptor: SChatCollectionViewDelegateFlowLayout?
    
    override public var delegate: UICollectionViewDelegate? {
        didSet {
            if delegate != nil {
                //let castedDelegate = unsafeBitCast(delegate, SChatInputToolbarDelegate.self)
                let castedDelegate: SChatCollectionViewDelegateFlowLayout = delegate as! SChatCollectionViewDelegateFlowLayout
                delegateInterceptor = castedDelegate
            }
            else {
                delegateInterceptor = nil
            }
        }
    }
    
}
