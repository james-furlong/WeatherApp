//
//  LocationWeather.swift
//  WeatherApp
//
//  Created by James Furlong on 24/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit

class LocationWeather: NSObject {
    
    var Name : String!
    var lat : Int!
    var lon : Int!
    var mainDescription : String!
    var longDescription : String!
    var temperature : Double!
    var pressure : Double!
    var humidity : Double!
    var tempMin : Double!
    var tempMax : Double!
    var windSpeed : Double!
    var windDeg : Int!
    var dataArray : [String:Any]!
    
    init(lat : Int, lon : Int) {
        self.dataArray = longLatGet(lat, lon)
        print(self.dataArray)
    }
    
    func longLatGet(lat:Int, lon:Int) -> [Array<Any>] {
        let url = URL(string: "\(kURLBase)lat=\(lat)&lon=\(lon)\(kAPIKey)")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                if let jsonArray = json as? [[String:Any]] {
                    print ("json is array", jsonArray)
                } else {
                    let jsonDictionary = json as! [String:Any]
                }
            }
        }
        task.resume()
        return task
    }

}
