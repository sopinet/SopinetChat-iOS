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

    @NSManaged var data: NSData?
    @NSManaged var dateString: String?
    @NSManaged var id: NSNumber?
    @NSManaged var read: NSNumber?
    @NSManaged var state: NSNumber?
    @NSManaged var text: String?
    @NSManaged var time: NSNumber?
    @NSManaged var chat: Chat?
    @NSManaged var fromUser: NSManagedObject?

}
