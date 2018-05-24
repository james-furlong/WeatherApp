//
//  Details+CoreDataProperties.swift
//  
//
//  Created by James Furlong on 25/5/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Details {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Details> {
        return NSFetchRequest<Details>(entityName: "Details")
    }

    @NSManaged public var airPressure: Bool
    @NSManaged public var highTemp: Bool
    @NSManaged public var humidity: Bool
    @NSManaged public var lowTemp: Bool
    @NSManaged public var rainFallen: Bool
    @NSManaged public var rainPredicted: Bool
    @NSManaged public var windDirection: Bool
    @NSManaged public var windSpeed: Bool

}
