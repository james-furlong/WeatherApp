//
//  ForecastObject.swift
//  WeatherApp
//
//  Created by James Furlong on 25/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit

class ForecastObject: NSObject {
    
    var temperature : Int!
    var weather : String!
    var day : String!
    
    init(temp : Double, weather : String, date : Double) {
        super.init()
        self.temperature = convertKtoC(temp: temp)
        self.weather = weather
        let tempDate = Date(timeIntervalSince1970: date)
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        self.day = df.string(from: tempDate)   
    }

    func convertKtoC(temp: Double) -> Int {
        let CelTemp = temp - 273.15
        return Int(CelTemp)
    }
}
