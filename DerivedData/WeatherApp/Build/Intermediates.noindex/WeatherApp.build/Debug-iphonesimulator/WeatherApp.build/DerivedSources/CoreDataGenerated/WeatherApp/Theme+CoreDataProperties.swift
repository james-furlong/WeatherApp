//
//  Theme+CoreDataProperties.swift
//  
//
//  Created by James Furlong on 25/5/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Theme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Theme> {
        return NSFetchRequest<Theme>(entityName: "Theme")
    }

    @NSManaged public var theme: String?

}
