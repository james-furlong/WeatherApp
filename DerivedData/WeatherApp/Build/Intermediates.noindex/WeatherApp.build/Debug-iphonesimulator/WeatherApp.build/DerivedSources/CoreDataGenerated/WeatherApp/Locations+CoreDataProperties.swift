//
//  Locations+CoreDataProperties.swift
//  
//
//  Created by James Furlong on 25/5/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Locations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locations> {
        return NSFetchRequest<Locations>(entityName: "Locations")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?

}
