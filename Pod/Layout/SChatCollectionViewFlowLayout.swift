//
//  SChatCollectionViewFlowLayout.swift
//  Pods
//
//  Created by David Moreno Lora on 17/5/16.
//
//

import Foundation

public class SChatCollectionViewFlowLayout: UICollectionViewFlowLayout
{
    public override var collectionView: SChatCollectionView?
    {
        get { return collectionView }
    }
    
    var incomingAvatarViewSize: CGSize?
    
    var outgoingAvatarViewSize: CGSize?
    
    var messageBubbleTextViewFrameInsets: UIEdgeInsets?
    
    var messageBubbleTextViewTextContainerInsets: UIEdgeInsets?
    
    var messageBubbleLeftRightMargin: Float?
    
    var messageBubbleFont: UIFont?
}