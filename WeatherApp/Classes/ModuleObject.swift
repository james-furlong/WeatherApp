//
//  ModuleObject.swift
//  WeatherApp
//
//  Created by James Furlong on 27/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit

class ModuleObject: NSObject {

    let Name : String!
    let Details : String!
    
    init(name: String, details: String) {
        Name = name
        Details = details
    }
    
}
