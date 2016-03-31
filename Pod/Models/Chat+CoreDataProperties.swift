//
//  Chat+CoreDataProperties.swift
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

extension Chat {

    @NSManaged var id: NSNumber?
    @NSManaged var messages: NSSet?
    @NSManaged var chatMembers: NSSet?

}
