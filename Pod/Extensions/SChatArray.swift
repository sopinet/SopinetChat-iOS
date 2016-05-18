//
//  SChatArray.swift
//  Pods
//
//  Created by David Moreno Lora on 18/5/16.
//
//

import Foundation

extension Array
{
    func indexOfObject(object : AnyObject) -> NSInteger {
        return self.indexOfObject(object)
    }
    
    mutating func removeObject(object : AnyObject) {
        for var index = self.indexOfObject(object); index != NSNotFound; index = self.indexOfObject(object) {
            self.removeAtIndex(index)
        }
    }
}