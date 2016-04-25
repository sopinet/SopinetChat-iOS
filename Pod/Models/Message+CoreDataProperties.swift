//
//  Message+CoreDataProperties.swift
//  
//
//  Created by David Moreno Lora on 31/3/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged public var data: NSData?
    @NSManaged public var dateString: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var read: NSNumber?
    @NSManaged public var state: NSNumber?
    @NSManaged public var text: String?
    @NSManaged public var time: NSNumber?
    @NSManaged public var chat: Chat?
    @NSManaged public var fromUser: NSManagedObject?

}
