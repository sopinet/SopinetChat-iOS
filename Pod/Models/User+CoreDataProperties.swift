//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var id: NSNumber?
    @NSManaged var email: String?
    @NSManaged var password: String?
    @NSManaged var profileImage: String?

}
