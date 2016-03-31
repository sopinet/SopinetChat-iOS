//
//  ImageFile+CoreDataProperties.swift
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

extension ImageFile {

    @NSManaged var id: NSNumber?
    @NSManaged var path: String?
    @NSManaged var messageImage: NSManagedObject?

}
