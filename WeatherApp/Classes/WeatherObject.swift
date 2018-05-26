//
//  WeatherObject.swift
//  WeatherApp
//
//  Created by James Furlong on 25/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit

class WeatherObject: NSObject {

    var Name : String!
    var ID : Int!
    var Temperature : Double!
    var TempMin : Double!
    var TempHigh : Double!
    var Pressure : Double!
    var Humidity : Int!
    var Rain : Double!
    var Sunrise : String!
    var Sunset : String!
    var WeatherDescription : String!
    var WeatherMain : String!
    var WindDirection : Double!
    var WindSpeed : Double!
    var WeatherDate : Double!
    
    init(weather: [String:Any]) {
        super.init()
        self.Name = weather["name"] as! String
        self.ID = weather["id"] as! Int
        if let weatherMain = weather["main"] as? [String:Any] {
            self.Temperature = convertKtoC(temp: weatherMain["temp"] as! Double)
            self.TempHigh = convertKtoC(temp: weatherMain["temp_max"] as! Double)
            self.TempMin = convertKtoC(temp: weatherMain["temp_min"] as! Double)
            self.Pressure = weatherMain["pressure"] as! Double
            self.Humidity = weatherMain["humidity"] as! Int
        }
        if let weatherRain = weather["rain"] as? [String:Any] {
            self.Rain = weatherRain["3h"] as! Double
        }
        if let weatherSys = weather["sys"] as? [String:Any] {
            self.Sunrise = convertUnixUTC(time: weatherSys["sunrise"] as! Double)
            self.Sunset = convertUnixUTC(time: weatherSys["sunset"] as! Double)
        }
        if let weatherDesc = weather["weather"] as? [String:Any] {
            self.WeatherDescription = weatherDesc["desciption"] as! String
            self.WeatherMain = weatherDesc["main"] as! String
        }
        if let weatherDesc = weather["weather"] as? [[String:Any]] {
            let data = weatherDesc[0]
            self.WeatherDescription = data["description"] as! String
            self.WeatherMain = data["main"] as! String
        }
        if let weatherWind = weather["wind"] as? [String:Any] {
            self.WindDirection = weatherWind["deg"] as! Double
            self.WindSpeed = weatherWind["speed"] as! Double
        }
        WeatherDate = weather["dt"] as! Double
    }
    
    func convertKtoC(temp: Double) -> Double {
        let CelTemp = temp - 273.15
        return CelTemp
    }
    
    func getHighTemp() -> String {
        let temp = Int(TempHigh)
        return String(temp)
    }
    
    func getLowTemp() -> String {
        let temp = Int(TempMin)
        return String(temp)
    }
    
    func getActualRain() -> String {
        let temp = Int(Rain)
        let string = "\(temp)mm"
        return string
    }
    
    func getHumidity() -> String {
        let temp = Int(Humidity)
        let string = "\(temp)%"
        return string
    }
    
    func getWindSpeed() -> String {
        let temp = Int(WindSpeed)
        let string = "\(temp) km/h"
        return string
    }
    
    func getWindirection() -> String {
        if WindDirection > 337.5 || WindDirection <= 22.5 {
            return "N"
        } else if WindDirection > 22.5 && WindDirection <= 67.5 {
            return "NE"
        } else if WindDirection > 67.5 && WindDirection <= 112.5 {
            return "E"
        } else if WindDirection > 112.5 && WindDirection <= 157.5 {
            return "SE"
        } else if WindDirection > 157.5 && WindDirection <= 202.5 {
            return "S"
        } else if WindDirection > 202.5 && WindDirection <= 247.5 {
            return "SW"
        } else if WindDirection > 247.5 && WindDirection <= 292.5 {
            return "W"
        } else {
            return "NW"
        }
    }
    
    func getAirPressure() -> String {
        let temp = Int(Pressure)
        let string = "\(temp) hPa"
        return string
    }
    
    func convertUnixUTC(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return String(dateFormatter.string(from: date))
    }
    
}
