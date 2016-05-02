//
//  SChatString.swift
//  Pods
//
//  Created by David Moreno Lora on 2/5/16.
//
//

import Foundation

extension String
{
    func sChatStringByTrimingWhitespace() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}