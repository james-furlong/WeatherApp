//
//  ViewController.swift
//  WeatherApp
//
//  Created by James Furlong on 23/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import AVKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var ForecastAndDataTableView: UITableView!
    @IBOutlet weak var WeatherDescriptionLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet var mainLabelCollection: [UILabel]!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var bookmarksButton: UIBarButtonItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var videoViewController: UIImageView!
    
    var weatherArray : Any!
    var forecastArray : Any!
    var weather : WeatherObject!
    var locationID : Int!
    var location : String!
    var forecastObjectsArray : [ForecastObject]!
    var detailsArray = [ModuleObject]()
    var htSettings = true
    var ltSettings = true
    var raSettings = true
    var rpSettings = true
    var humSettings = true
    var wsSettings = true
    var wdSettings = true
    var apSettings = true
    let mainTextColor = UIColor.white
    var textColor : UIColor!
    var backgroundColor : UIColor!
    var toolbarTextColor : UIColor!
    var toolbarBackgroundColor : UIColor!
    var locationManager : CLLocationManager!
    var player : AVPlayer!
    var latitude : Decimal!
    var longitude : Decimal!
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        startLoading()
        super.viewDidLoad()
        if weather != nil {
            initialiseWeather()
        } else {
            getLocation()
        }
    }
    
    // Initialise all of the components that go together to retrieve weather details and display them to the user. This function is only called once a location has been established
    func initialiseWeather() {
        var count = 0
        if weather != nil {
            loadWeatherVideo()
            updateLabels()
            return
        }
        getWeather(location: location)
        // A loop to ensure put a timeout on the response from the API call
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
        // A loop to ensure put a timeout on the response from the API call
        while forecastArray == nil {
            count += 1
            if count == 100000000 {
                //Show alert for timeout and cancel json request
                print("Too long")
            }
        }
        getForecastData()
        loadInitialiseCoreDate()
        if weather.WeatherMain == kHaze || weather.WeatherMain == kMist {
            weather.WeatherMain = kFog
        }
        loadWeatherVideo()
        updateLabels()
        stopLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update all the main labels with the information from the json request
    func updateLabels() {
        TemperatureLabel.text = String(Int(weather.Temperature))
        WeatherDescriptionLabel.text = String(weather.WeatherDescription)
        LocationLabel.text = String(weather.Name)
        ForecastAndDataTableView.reloadData()
    }
    
    // Initialise the location manager and begin updating the users current location.
    func getLocation() {
        locationManager = CLLocationManager()
        guard CLLocationManager.locationServicesEnabled() else {
            // An alert message to the user if location services are disabled
            let alert = UIAlertController(title: "Location Services", message: "Location services are disabled on your device. In order to use this app you will need to allow location services.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted :
                print("This app is not authorized to use your location")
                return
            case .notDetermined :
                locationManager.requestWhenInUseAuthorization()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            default:
                print("Error in logic")
                return
            }
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Check if the row being accessed is the forecast row, and if it is, follow the next code block to assign the correct information
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastTableViewCell
            var count = 0
            if forecastObjectsArray == nil {
                return cell
            }
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
                var i = forecastObjectsArray.count
                while i < 5 {
                    for days in cell.DaysArray {
                        if days.tag == i {
                            days.text = selectDay(day: forecastObjectsArray[i - 1].day)
                        }
                    }
                    for icon in cell.IconArray {
                        if icon.tag == i {
                            icon.image = nil
                        }
                    }
                    for temp in cell.TempArray {
                        if temp.tag == i {
                            temp.text = "--"
                        }
                    }
                    i += 1
                }
            }
            return cell
        } else { // If the cell being accessed is not the forecast cell, then it will be a detail cell. Determine which detail cell it is and provide the relevant information for that cell.
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DetailsTableViewCell
            if indexPath.row == 1 {
                cell.DataLabel1.text = detailsArray[0].Name
                cell.DataDetails1.text = detailsArray[0].Details
                if detailsArray.indices.contains(1) {
                    cell.DataLabel2.text = detailsArray[1].Name
                    cell.DataDetails2.text = detailsArray[1].Details
                }
            }
            if indexPath.row == 2 {
                cell.DataLabel1.text = detailsArray[2].Name
                cell.DataDetails1.text = detailsArray[2].Details
                if detailsArray.indices.contains(3) {
                    cell.DataLabel2.text = detailsArray[3].Name
                    cell.DataDetails2.text = detailsArray[3].Details
                }
            }
            if indexPath.row == 3 {
                cell.DataLabel1.text = detailsArray[4].Name
                cell.DataDetails1.text = detailsArray[4].Details
                if detailsArray.indices.contains(5) {
                    cell.DataLabel2.text = detailsArray[5].Name
                    cell.DataDetails2.text = detailsArray[5].Details
                }
            }
            if indexPath.row == 4 {
                cell.DataLabel1.text = detailsArray[6].Name
                cell.DataDetails1.text = detailsArray[6].Details
                if detailsArray.indices.contains(7) {
                    cell.DataLabel2.text = detailsArray[7].Name
                    cell.DataDetails2.text = detailsArray[7].Details
                }
            }
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailsArray.count % 2 == 0 {
            return (detailsArray.count / 2) + 1
        } else {
            return(detailsArray.count / 2) + 2
        }
    }
    
    // Load the weather video for the top of the view controller. If there is no video available, fall back onto static image of a clear day.
    func loadWeatherVideo() {
        var videoString : Optional<String>
        if weather.WeatherMain.contains("cloud") || weather.WeatherMain.contains("Cloud") {
            videoString = Bundle.main.path(forResource: "Cloudy", ofType: "mp4")!
        } else {
            videoString = Bundle.main.path(forResource: weather.WeatherMain, ofType: "mp4")!
        }
        guard let unwrappedVideoPath = videoString else {
            weatherImage.image = UIImage(named: "sunnyImage")
            return
        }
        let videoURL = URL(fileURLWithPath: unwrappedVideoPath)
        self.player = AVPlayer(url: videoURL)
        let layer : AVPlayerLayer = AVPlayerLayer(player: player)
        layer.frame = videoViewController.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoViewController.layer.addSublayer(layer)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        player?.play()
    }
    
    // Loop the video once it has reached the end
    @ objc func playerItemDidReachEnd() {
        player!.seek(to: kCMTimeZero)
        player.play()
    }

    // API request for the weather in the current location
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
    
    // API request for forecast data in the current location
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
    
    // Extract the forecast data from the returned json from the function getForecast
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
    
    // Check the date on the forecast data. As the data is provided in 3hr increments, this removes the additional information so that we only have one set of data for each day.
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
        df.dateFormat = "HH:mm"
        let stringDate = df.string(from: tempDate)
        if stringDate == "12:00" || stringDate == "13:00" || stringDate == "14:00" {
            return true
        }
        return false
    }
    
    // Determine which icon is most suitable for the weather information being dispalyed
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
    
    // Determine what day it is today, and then determine what the next 5 days are
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
    
    // Update the colors of the theme, including the navigation bar at the bottom of the view controller
    func updateThemeColor(text : UIColor, background : UIColor, toolbarText : UIColor, toolbarBackground : UIColor) {
        for label in labelCollection {
            label.textColor = text
            label.backgroundColor = nil
        }
        for label in mainLabelCollection {
            label.textColor = UIColor.white
        }
        LocationLabel.textColor = UIColor.white
        WeatherDescriptionLabel.textColor = UIColor.white
        toolbar.barTintColor = toolbarBackground
        bookmarksButton.tintColor = toolbarText
        settingsButton.tintColor = toolbarText
        view.backgroundColor = background
    }
    
    // func to receive the information from updating the current location. Location is then stored locally, displayed, and then used to determine the location for the weather APIs
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue : CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let tempLat = Decimal(locValue.latitude)
        latitude = tempLat
        let tempLon = Decimal(locValue.longitude)
        longitude = tempLon
        geocode(latitude: locValue.latitude, longitude: locValue.longitude) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            DispatchQueue.main.async {
                print("address1:", placemark.thoroughfare ?? "")
                print("address2:", placemark.subThoroughfare ?? "")
                print("city:",     placemark.locality ?? "")
                print("state:",    placemark.administrativeArea ?? "")
                print("zip code:", placemark.postalCode ?? "")
                print("country:",  placemark.country ?? "")
                print("latitude:", placemark.location ?? "")
                let temp = (placemark.locality)?.replacingOccurrences(of: " ", with: "+")
                self.location = temp
                self.initialiseWeather()
            }
        }
    }
    
    
    // Get the geocode of the location given by the location manager
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    func startLoading() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    // Load all of the core date required for the view controller. This is for both the actual weather details, as well as the theme details.
    func loadInitialiseCoreDate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Details", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Details")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: kHighTemp) as? Bool) == true {
                    detailsArray.append(ModuleObject(name: kHighTempLabel, details: weather.getHighTemp()))
                }
                if (data.value(forKey: kLowTemp) as? Bool) == true{
                    detailsArray.append(ModuleObject(name: kLowTempLabel, details: weather.getLowTemp()))
                }
                if (data.value(forKey: kRainFallen) as? Bool) == true {
                    if weather.Rain != nil {
                        detailsArray.append(ModuleObject(name: kRainFallenLabel, details: weather.getActualRain()))
                    } else {
                        detailsArray.append(ModuleObject(name: kRainFallenLabel, details: "--"))
                    }
                }
                if (data.value(forKey: kRainPredicted) as? Bool) == true {
                    if weather.Rain != nil {
                        detailsArray.append(ModuleObject(name: kRainPredictedLabel, details: weather.getActualRain()))
                    } else {
                        detailsArray.append(ModuleObject(name: kRainPredictedLabel, details: "--"))
                    }
                }
                if (data.value(forKey: kHumidity) as? Bool) == true {
                    detailsArray.append(ModuleObject(name: kHumidityLabel, details: weather.getHumidity()))
                }
                if (data.value(forKey: kWindSpeed) as? Bool) == true {
                    detailsArray.append(ModuleObject(name: kWindSpeedLabel, details: weather.getWindSpeed()))
                }
                if (data.value(forKey: kWindDirction) as? Bool) == true {
                    detailsArray.append(ModuleObject(name: kWindDirectionLabel, details: weather.getWindirection()))
                }
                if (data.value(forKey: kAirPressure) as? Bool) == true {
                    detailsArray.append(ModuleObject(name: kAirPressureLabel, details: weather.getAirPressure()))
                 }
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
        let themeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Theme")
        themeRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(themeRequest)
            if result.isEmpty {
                textColor = UIColor.darkGray
                backgroundColor = UIColor.white
                toolbarTextColor = UIColor.white
                toolbarBackgroundColor = UIColor.darkGray
            } else {
                for data in result as! [NSManagedObject] {
                    if (data.value(forKey: kTheme) as? String) == kWinter {
                        textColor = UIColor.darkGray
                        backgroundColor = UIColor.white
                        toolbarTextColor = UIColor.white
                        toolbarBackgroundColor = UIColor.darkGray
                    } else if (data.value(forKey: kTheme) as? String) == kSummer {
                        backgroundColor = UIColor(red: 201/255, green: 224/255, blue: 212/225, alpha: 1.0)
                        textColor = UIColor(red: 26/255, green: 86/255, blue: 132/255, alpha: 1.0)
                        toolbarTextColor = UIColor(red: 201/255, green: 224/255, blue: 212/225, alpha: 1.0)
                        toolbarBackgroundColor = UIColor(red: 26/255, green: 86/255, blue: 132/255, alpha: 1.0)
                    } else if (data.value(forKey: kTheme) as? String) == kAutumn {
                        backgroundColor = UIColor(red: 188/255, green: 132/255, blue: 98/255, alpha: 1.0)
                        textColor = UIColor(red: 132/255, green: 42/255, blue: 26/255, alpha: 1.0)
                        toolbarTextColor = UIColor(red: 188/255, green: 132/255, blue: 98/255, alpha: 1.0)
                        toolbarBackgroundColor = UIColor(red: 132/255, green: 42/255, blue: 26/255, alpha: 1.0)
                    } else {
                        backgroundColor = UIColor.black
                        textColor = UIColor(red: 196/255, green: 188/255, blue: 186/255, alpha: 1.0)
                        toolbarTextColor = UIColor.black
                        toolbarBackgroundColor = UIColor(red: 196/255, green: 188/255, blue: 186/255, alpha: 1.0)
                    }
                }
            }
            updateThemeColor(text: textColor, background: backgroundColor, toolbarText: toolbarTextColor, toolbarBackground: toolbarBackgroundColor)
        } catch {
            print("Failed theme get")
        }
    }
}
