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

public extension Chat {

    @NSManaged public var id: NSNumber?
    @NSManaged public var messages: NSSet?
    @NSManaged public var chatMembers: NSSet?

}
