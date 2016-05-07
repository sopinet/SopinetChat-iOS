//
//  SChatCollectionViewFlowLayoutInvalidationContext.swift
//  Pods
//
//  Created by David Moreno Lora on 7/5/16.
//
//

import UIKit

class SChatCollectionViewFlowLayoutInvalidationContext: UICollectionViewFlowLayoutInvalidationContext {
    
    var invalidateFlowLayoutMessagesCache: Bool = false
    
    override init()
    {
        super.init()
        
        self.invalidateFlowLayoutDelegateMetrics = false
        self.invalidateFlowLayoutAttributes = false
        self.invalidateFlowLayoutMessagesCache = false
    }
    
    static func context() -> SChatCollectionViewFlowLayoutInvalidationContext
    {
        let context = SChatCollectionViewFlowLayoutInvalidationContext()
        context.invalidateFlowLayoutDelegateMetrics = true
        context.invalidateFlowLayoutAttributes = true
        
        return context
    }
    
    // MARK: NSObject
    
    override var description: String
    {
        return "<\(self.dynamicType): invalidateFlowLayoutDelegateMetrics=\(self.invalidateFlowLayoutDelegateMetrics), invalidateFlowLayoutAttributes=\(self.invalidateFlowLayoutAttributes), invalidateDataSourceCounts=\(self.invalidateDataSourceCounts), invalidateFlowLayoutMessagesCache=\(self.invalidateFlowLayoutMessagesCache)>"
    }

}
