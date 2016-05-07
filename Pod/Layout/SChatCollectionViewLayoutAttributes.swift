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
    var messageBubbleFont: UIFont?
    
    var messageBubbleContainerViewWidth: Float? {
        set { self.messageBubbleContainerViewWidth = ceilf(newValue!) }
        get {return self.messageBubbleContainerViewWidth }
    }
    
    var textViewTextContainerInsets: UIEdgeInsets? = nil
    
    var textViewFrameInsets: UIEdgeInsets? = nil
    
    var incomingAvatarViewSize: CGSize? {
        set { self.incomingAvatarViewSize = self.sChatCorrectedAvatarSizeFromSize(newValue!) }
        get { return self.incomingAvatarViewSize }
    }
    
    var outgoingAvatarViewSize: CGSize? {
        set { self.outgoingAvatarViewSize = self.sChatCorrectedAvatarSizeFromSize(newValue!) }
        get { return self.outgoingAvatarViewSize }
    }
    
    var cellTopLabelHeight: Float? {
        set { self.cellTopLabelHeight = self.sChatCorrectedLabelHeightForHeight(newValue!) }
        get { return self.cellTopLabelHeight }
    }
    
    var messageBubbleTopLabelHeight: Float? {
        set { self.messageBubbleTopLabelHeight = self.sChatCorrectedLabelHeightForHeight(newValue!) }
        get { return messageBubbleTopLabelHeight }
    }
    
    var cellBottomLabelHeight: Float? {
        set { self.cellBottomLabelHeight = self.sChatCorrectedLabelHeightForHeight(newValue!) }
        get { return cellBottomLabelHeight }
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
        if self.isEqual(object) {
            return true
        }
        
        if !object!.isKindOfClass(self.dynamicType) {
            return false
        }
        
        if self.representedElementCategory == UICollectionElementCategory.Cell
        {
            let layoutAttributes: SChatCollectionViewLayoutAttributes = object as! SChatCollectionViewLayoutAttributes
            
            if !layoutAttributes.messageBubbleFont!.isEqual(self.messageBubbleFont)
                || !UIEdgeInsetsEqualToEdgeInsets(layoutAttributes.textViewFrameInsets!, self.textViewFrameInsets!)
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
