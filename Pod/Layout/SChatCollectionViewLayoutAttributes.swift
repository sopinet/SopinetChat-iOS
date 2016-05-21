//
//  SChatCollectionViewLayoutAttributes.swift
//  Pods
//
//  Created by David Moreno Lora on 7/5/16.
//
//

import UIKit

class SChatCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes
{
    var messageBubbleFont: UIFont? = nil
    
    private var _messageBubbleContainerViewWidth: Float?
    var messageBubbleContainerViewWidth: Float? {
        set { _messageBubbleContainerViewWidth = ceilf(newValue!) }
        get {return _messageBubbleContainerViewWidth }
    }
    
    var textViewTextContainerInsets: UIEdgeInsets? = nil
    
    var textViewFrameInsets: UIEdgeInsets? = nil
    
    private var _incomingAvatarViewSize: CGSize?
    var incomingAvatarViewSize: CGSize? {
        set { _incomingAvatarViewSize = self.sChatCorrectedAvatarSizeFromSize(newValue!) }
        get { return _incomingAvatarViewSize }
    }
    
    private var _outgoingAvatarViewSize: CGSize?
    var outgoingAvatarViewSize: CGSize? {
        set { _outgoingAvatarViewSize = self.sChatCorrectedAvatarSizeFromSize(newValue!) }
        get { return _outgoingAvatarViewSize }
    }
    
    private var _cellTopLabelHeight: Float?
    var cellTopLabelHeight: Float? {
        set { _cellTopLabelHeight = self.sChatCorrectedLabelHeightForHeight(newValue!) }
        get { return _cellTopLabelHeight }
    }
    
    private var _messageBubbleTopLabelHeight: Float?
    var messageBubbleTopLabelHeight: Float? {
        set { _messageBubbleTopLabelHeight = self.sChatCorrectedLabelHeightForHeight(newValue!) }
        get { return _messageBubbleTopLabelHeight }
    }
    
    private var _cellBottomLabelHeight: Float?
    var cellBottomLabelHeight: Float? {
        set { _cellBottomLabelHeight = self.sChatCorrectedLabelHeightForHeight(newValue!) }
        get { return _cellBottomLabelHeight }
    }
    
    // MARK: Life-Cycle
    
    deinit
    {
        self.messageBubbleFont = nil
    }
    
    // MARK: Utilities
    
    func sChatCorrectedAvatarSizeFromSize(size: CGSize) -> CGSize
    {
        return CGSizeMake(CGFloat(ceilf(Float(size.width))),
                          CGFloat(ceilf(Float(size.height))))
    }
    
    func sChatCorrectedLabelHeightForHeight(height: Float) -> Float
    {
        return ceilf(height)
    }
    
    // MARK: NSObject
    
    override func isEqual(object: AnyObject?) -> Bool
    {
        if super.isEqual(object) {
            return true
        }
        
        if !object!.isKindOfClass(self.dynamicType) {
            return false
        }
        
        if self.representedElementCategory == UICollectionElementCategory.Cell
        {
            let layoutAttributes: SChatCollectionViewLayoutAttributes = object as! SChatCollectionViewLayoutAttributes
            
            if !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewFrameInsets!, self.textViewFrameInsets!)
                || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewTextContainerInsets!, self.textViewTextContainerInsets!)
                || !CGSizeEqualToSize(layoutAttributes.incomingAvatarViewSize!, self.incomingAvatarViewSize!)
                || !CGSizeEqualToSize(layoutAttributes.outgoingAvatarViewSize!, self.outgoingAvatarViewSize!)
                || Int(layoutAttributes.messageBubbleContainerViewWidth!) != Int(self.messageBubbleContainerViewWidth!)
                    || Int(layoutAttributes.cellTopLabelHeight!) != Int(self.cellTopLabelHeight!)
                        || Int(layoutAttributes.messageBubbleTopLabelHeight!) != Int(self.messageBubbleTopLabelHeight!)
                            || Int(layoutAttributes.cellBottomLabelHeight!) != Int(self.cellBottomLabelHeight!) {
                return false;
            }
        }
        
        return super.isEqual(object)
    }
    
    override var hash: Int
    {
        return self.indexPath.hash
    }
    
    // MARK: NSCopying
    
    override func copyWithZone(zone: NSZone) -> AnyObject
    {
        var copy: SChatCollectionViewLayoutAttributes = super.copyWithZone(zone) as! SChatCollectionViewLayoutAttributes
        
        if copy.representedElementCategory != UICollectionElementCategory.Cell {
            return copy
        }
        
        copy.messageBubbleFont = self.messageBubbleFont;
        copy.messageBubbleContainerViewWidth = self.messageBubbleContainerViewWidth;
        copy.textViewFrameInsets = self.textViewFrameInsets;
        copy.textViewTextContainerInsets = self.textViewTextContainerInsets;
        copy.incomingAvatarViewSize = self.incomingAvatarViewSize;
        copy.outgoingAvatarViewSize = self.outgoingAvatarViewSize;
        copy.cellTopLabelHeight = self.cellTopLabelHeight;
        copy.messageBubbleTopLabelHeight = self.messageBubbleTopLabelHeight;
        copy.cellBottomLabelHeight = self.cellBottomLabelHeight;
        
        return copy
    }
}
