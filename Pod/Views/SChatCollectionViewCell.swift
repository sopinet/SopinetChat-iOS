//
//  SChatCollectionViewCell.swift
//  Pods
//
//  Created by David Moreno Lora on 15/5/16.
//
//

import UIKit

var sChatCollectionViewCellActions: NSMutableSet? = nil

public class SChatCollectionViewCell: UICollectionViewCell
{
    // Properties
    
    let delegate: SChatCollectionViewCell? = nil
    
    @IBOutlet weak var cellTopLabel: SChatLabel? = nil
    
    @IBOutlet weak var messageBubbleTopLabel: SChatLabel? = nil
    
    @IBOutlet weak var cellBottomLabel: SChatLabel? = nil
    
    @IBOutlet weak var textView: SChatCellTextView? = nil
    
    @IBOutlet weak var messageBubbleImageView: UIImageView? = nil
    
    @IBOutlet weak var messageBubbleContainerView: UIView? = nil
    
    @IBOutlet weak var avatarImageView: UIImageView? = nil
    
    @IBOutlet weak var avatarContainerView: UIView? = nil
    
    @IBOutlet weak var mediaView: UIView? = nil
    
    let tapGestureRecognizer: UITapGestureRecognizer? = nil
    
    // MARK: Chat Methods
    
    public override static func initialize()
    {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            sChatCollectionViewCellActions = NSMutableSet()
        }
    }
    
    public class func nib() -> UINib!
    {
        return UINib.init(nibName:NSStringFromClass(self), bundle: NSBundle(forClass: self))
    }
    
    public static func cellReuseIdentifier() -> String
    {
        return NSStringFromClass(self)
    }
    
    public static func mediaCellReuseIdentifier() -> String
    {
        return NSStringFromClass(self) + "_SChatMedia"
    }
    
    public static func registerMenuAction(action: Selector)
    {
        sChatCollectionViewCellActions?.addObject(NSStringFromSelector(action))
    }
    
    // MARK: Initialization
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.whiteColor()
        
        
    }
    
}
