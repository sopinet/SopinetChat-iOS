//
//  SChatCollectionViewCellOutgoing.swift
//  Pods
//
//  Created by David Moreno Lora on 16/5/16.
//
//

import Foundation

public class SChatCollectionViewCellOutgoing: SChatCollectionViewCell
{
    // MARK: Overrides
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.messageBubbleTopLabel?.textAlignment = .Right
        self.cellBottomLabel?.textAlignment = .Right
    }
}