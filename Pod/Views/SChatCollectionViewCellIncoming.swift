//
//  SChatCollectionViewCellIncoming.swift
//  Pods
//
//  Created by David Moreno Lora on 16/5/16.
//
//

import Foundation

public class SChatCollectionViewCellIncoming: SChatCollectionViewCell
{
    // MARK: Overrides
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.messageBubbleTopLabel?.textAlignment = .Left
        self.cellBottomLabel?.textAlignment = .Left
    }
}
