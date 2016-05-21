//
//  SChatCollectionView.swift
//  Pods
//
//  Created by David Moreno Lora on 28/4/16.
//
//

import UIKit

public class SChatCollectionView: UICollectionView, SChatCollectionViewCellDelegate
{
    // MARK: Properties
    
    weak public var dataSourceInterceptor: SChatCollectionViewDataSource?
    
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
    
    weak public var delegateInterceptor: SChatCollectionViewDelegateFlowLayout?
    
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
    
    weak public var collectionViewLayoutInterceptor: SChatCollectionViewFlowLayout?
    
    override public var collectionViewLayout: UICollectionViewLayout {
        didSet
        {
            let castedCollectionViewLayout: SChatCollectionViewFlowLayout = collectionViewLayout as! SChatCollectionViewFlowLayout
            collectionViewLayoutInterceptor = castedCollectionViewLayout
            
        }
    }
    
    var typingIndicatorDysplaysOnLeft: Bool = false
    
    var typingIndicatorMessageBubbleColor: UIColor = UIColor.lightGrayColor()
    
    var typingIndicatorEllipsisColor: UIColor = UIColor.darkGrayColor()
    
    var loadEarlierMessagesHeaderTextColor: UIColor = UIColor.blueColor()
    
    // MARK: Initialization
    
    func sChatConfigureCollectionView()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = UIColor.whiteColor()
        self.keyboardDismissMode = UIScrollViewKeyboardDismissMode.None
        self.alwaysBounceVertical = true
        self.bounces = true
        
        self.registerNib(SChatCollectionViewCellIncoming.nib(), forCellWithReuseIdentifier: SChatCollectionViewCellIncoming.cellReuseIdentifier())
        
        self.registerNib(SChatCollectionViewCellOutgoing.nib(), forCellWithReuseIdentifier: SChatCollectionViewCellOutgoing.cellReuseIdentifier())
        
        self.registerNib(SChatCollectionViewCellIncoming.nib(), forCellWithReuseIdentifier: SChatCollectionViewCellIncoming.mediaCellReuseIdentifier())
        
        self.registerNib(SChatCollectionViewCellOutgoing.nib(), forCellWithReuseIdentifier: SChatCollectionViewCellOutgoing.mediaCellReuseIdentifier())
        
        // TODO: Faltan tipos de celdas
        
        let castedCollectionViewLayout: SChatCollectionViewFlowLayout = collectionViewLayout as! SChatCollectionViewFlowLayout
        collectionViewLayoutInterceptor = castedCollectionViewLayout
        
        self.typingIndicatorDysplaysOnLeft = true
        self.typingIndicatorMessageBubbleColor = UIColor.sChatMessageBubbleLightGrayColor()
        self.typingIndicatorEllipsisColor = typingIndicatorMessageBubbleColor // TODO: Color by darkening...
        
        loadEarlierMessagesHeaderTextColor = UIColor.sChatMessageBubbleBlueColor()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout)
    {
        super.init(frame: frame, collectionViewLayout: layout)
        
        sChatConfigureCollectionView()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        sChatConfigureCollectionView()
    }
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        sChatConfigureCollectionView()
    }
    
    // MARK: Messages Collection View Cell Delegate
    
    public func messagesCollectionViewCellDidTapAvatar(cell: SChatCollectionViewCell)
    {
        let indexPath = self.indexPathForCell(cell)
        
        if indexPath == nil
        {
            return
        }
        
        self.delegateInterceptor?.collectionView(self, didTapAvatarImageView: cell.avatarImageView, atIndexPath: indexPath!)
    }
    
    public func messagesCollectionViewCellDidTapMessageBubble(cell: SChatCollectionViewCell)
    {
        let indexPath = self.indexPathForCell(cell)
        
        if indexPath == nil
        {
            return
        }
        
        self.delegateInterceptor?.collectionView(self, didTapMessageBubbleAtIndexPath: indexPath!)
    }
    
    public func messagesCollectionViewCellDidTapCell(cell: SChatCollectionViewCell, atPosition position: CGPoint)
    {
        let indexPath = self.indexPathForCell(cell)
        
        if indexPath == nil
        {
            return
        }
        
        self.delegateInterceptor?.collectionView(self, didTapCellAtIndexPath: indexPath!, touchLocation: position)
    }
    
    public func messagesCollectionViewCell(cell: SChatCollectionViewCell, didPerformAction action: Selector, withSender sender: AnyObject?)
    {
        let indexPath = self.indexPathForCell(cell)
        
        if indexPath == nil
        {
            return
        }
        
        self.delegateInterceptor?.collectionView!(self, performAction: action, forItemAtIndexPath: indexPath!, withSender: sender)
    }
}
