//
//  ViewController.swift
//  WeatherApp
//
//  Created by James Furlong on 23/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var ForecastAndDataTableView: UITableView!
    @IBOutlet weak var WeatherDescriptionLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    
    var weatherArray : Any!
    var forecastArray : Any!
    var weather : WeatherObject!
    var locationID : Int!
    var location : String!
    var forecastObjectsArray : [ForecastObject]!
    var htSettings = true
    var ltSettings = true
    var raSettings = true
    var rpSettings = true
    var humSettings = true
    var wsSettings = true
    var wdSettings = true
    var apSettings = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialiseCoreDate()
        var count = 0
        // ******************************* //
        getWeather(location: "Camberwell,AU")
        // ******************************* //
        while weather == nil {
            count += 1
            if count == 100000000 {
                //Show alert for timeout and cancel json request
                print("Too long")
            }
        }
        locationID = weather.ID
        getForecast(id: locationID)
        count = 0
        while forecastArray == nil {
            count += 1
            if count == 100000000 {
                //Show alert for timeout and cancel json request
                print("Too long")
            }
        }
        getForecastData()
        TemperatureLabel.text = String(Int(weather.Temperature))
        WeatherDescriptionLabel.text = String(weather.WeatherDescription)
        LocationLabel.text = String(weather.Name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastTableViewCell
            var count = 0
            while count < forecastObjectsArray.count {
                for days in cell.DaysArray {
                    if days.tag == count {
                        let day = forecastObjectsArray[count].day!
                        let index = day.index(day.startIndex, offsetBy: 0)
                        days.text = String(day[index])
                    }
                }
                for icons in cell.IconArray {
                    if icons.tag == count {
                        icons.image = selectIcon(name: forecastObjectsArray[count].weather)
                    }
                }
                for temp in cell.TempArray {
                    if temp.tag == count {
                        temp.text = String(forecastObjectsArray[count].temperature)
                    }
                }
                count += 1
            }
            if forecastObjectsArray.count < 5 {
                var count = forecastObjectsArray.count
                while count < 5 {
                    for days in cell.DaysArray {
                        if days.tag == count {
                            days.text = selectDay(day: forecastObjectsArray[count - 1].day)
                        }
                    }
                    for icon in cell.IconArray {
                        if icon.tag == count {
                            icon.image = nil
                        }
                    }
                    for temp in cell.TempArray {
                        if temp.tag == count {
                            temp.text = "--"
                        }
                    }
                    count += 1
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DetailsTableViewCell
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func getWeather(location: String) {
        let url = URL(string: "\(kURLBase)weather?q=\(location)\(kAPIKey)")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.weatherArray = json
                    print(self.weatherArray)
                    self.weather = WeatherObject(weather: self.weatherArray as! [String:Any])
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    func getForecast(id: Int) {
        let url = URL(string: "\(kURLBase)forecast?id=\(id)\(kAPIKey)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.forecastArray = json
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getForecastData() {
        var desc = ""
        var tempArray = [ForecastObject(temp: self.weather.Temperature + 273.15, weather: self.weather.WeatherMain, date: self.weather.WeatherDate)]
        let data = forecastArray as! [String:Any]
        let list = data["list"] as! [[String:Any]]
        for day in list {
            let main = day["main"] as! [String:Any]
            let temp = main["temp"] as! Double
            let weather = day["weather"] as! [NSDictionary]
            for data in weather {
                desc = data["main"] as! String
            }
            let date = day["dt"] as! Double
            if checkDate(date: date) {
                tempArray.append(ForecastObject(temp: temp, weather: desc, date: date))
            }
        }
        forecastObjectsArray = tempArray
    }
    
    func checkDate(date: Double) -> Bool {
        let tempDate = Date(timeIntervalSince1970: date)
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        let nowDate = Date()
        let stringDay = df.string(from: tempDate)
        let nowDay = df.string(from: nowDate)
        if stringDay == nowDay {
            return false
        }
        df.dateFormat = "hh:mm a"
        let stringDate = df.string(from: tempDate)
        if stringDate == "12:00 PM" || stringDate == "01:00 PM" || stringDate == "02:00 PM" {
            return true
        }
        return false
    }
    
    func selectIcon(name: String) -> UIImage {
        if name == "Clouds" {
            return UIImage(named: "Cloudy")!
        } else if name == "Clear" {
            return UIImage(named: "Sunny")!
        } else if name == "Rain" {
            return UIImage(named: "Rain")!
        } else {
            return UIImage(named: "Sunny")!
        }
    }
    
    func selectDay(day: String) -> String {
        let dayArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var count = 0
        while count < 7 {
            for day in dayArray {
                if day == dayArray[count] {
                    let day = dayArray[count + 1]
                    let index = day.index(day.startIndex, offsetBy: 0)
                    return String(day[index])
                }
                count += 1
            }
        }
        return "--"
    }
    
    func checkForCompleteion(object: Any!) {
        var count = 0
        while self.weather == nil {
            count += 1
            if count == 100000000 {
                //Show alert for timeout and cancel json request
                print("Too long")
            }
        }
        count = 0
        while self.forecastArray == nil {
            count += 1
            if count == 100000000 {
                //Show alert for timeout and cancel json request
                print("Too long")
            }
        }
    }
    
    func loadInitialiseCoreDate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Details", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Details")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                htSettings = (data.value(forKey: kHighTemp) != nil)
                ltSettings = (data.value(forKey: kLowTemp) != nil)
                raSettings = (data.value(forKey: kRainFallen) != nil)
                rpSettings = (data.value(forKey: kRainPredicted) != nil)
                humSettings = (data.value(forKey: kHumidity) != nil)
                wsSettings = (data.value(forKey: kWindSpeed) != nil)
                wdSettings = (data.value(forKey: kWindDirction) != nil)
                apSettings = (data.value(forKey: kAirPressure) != nil)
            }
            let count = try context.count(for: request)
            if count == 0 {
                let newData = NSManagedObject(entity: entity!, insertInto: context)
                newData.setValue(true, forKey: kHighTemp)
                newData.setValue(true, forKey: kLowTemp)
                newData.setValue(true, forKey: kRainFallen)
                newData.setValue(true, forKey: kRainPredicted)
                newData.setValue(true, forKey: kHumidity)
                newData.setValue(true, forKey: kWindSpeed)
                newData.setValue(true, forKey: kWindDirction)
                newData.setValue(true, forKey: kAirPressure)
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch {
            print("Failed")
        }
    }
}
