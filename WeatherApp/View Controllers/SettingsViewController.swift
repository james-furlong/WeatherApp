//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by James Furlong on 27/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    @IBOutlet weak var maxTemp: UISwitch!
    @IBOutlet weak var minTemp: UISwitch!
    @IBOutlet weak var predRain: UISwitch!
    @IBOutlet weak var actRain: UISwitch!
    @IBOutlet weak var windSpeed: UISwitch!
    @IBOutlet weak var windDir: UISwitch!
    @IBOutlet weak var humidity: UISwitch!
    @IBOutlet weak var airPressure: UISwitch!
    @IBOutlet var labelArray: [UILabel]!
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var detailsArray = [Details]()
    var theme : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCoreData()
        updateColors()
        updateSwitches()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Load the core data for the theme that is to be used
    func loadCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Details")
        request.returnsObjectsAsFaults = false
        guard let tempArray = try? context.fetch(request) as! [Details] else { return }
        detailsArray = tempArray
        let themeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Theme")
        themeRequest.returnsObjectsAsFaults = false
        guard let tempThemeArray = try? context.fetch(themeRequest) as! [Theme] else { return }
        for data in tempThemeArray {
            theme = data.theme
        }
    }
    
    // Update the colours to match the theme that has been retrieved from core data
    func updateColors() {
        var backgroundColor : UIColor!
        var textColor : UIColor!
        switch theme {
        case kWinter : backgroundColor = UIColor.white
            textColor = UIColor.darkGray
        case kSummer : backgroundColor = UIColor(red: 201/255, green: 224/255, blue: 212/225, alpha: 1.0)
        textColor = UIColor(red: 26/255, green: 86/255, blue: 132/255, alpha: 1.0)
        case kAutumn : backgroundColor = UIColor(red: 188/255, green: 132/255, blue: 98/255, alpha: 1.0)
        textColor = UIColor(red: 132/255, green: 42/255, blue: 26/255, alpha: 1.0)
        case kDark : backgroundColor = UIColor.black
        textColor = UIColor(red: 196/255, green: 188/255, blue: 186/255, alpha: 1.0)
        default : backgroundColor = UIColor.white
            textColor = UIColor.darkGray
        }
        for label in labelArray {
            label.textColor = textColor
            label.backgroundColor = backgroundColor
        }
        view.backgroundColor = backgroundColor
        saveButton.setTitleColor(backgroundColor, for: .normal)
        cancelButton.setTitleColor(backgroundColor, for: .normal)
        themeButton.setTitleColor(textColor, for: .normal)
        saveButton.backgroundColor = textColor
        cancelButton.backgroundColor = textColor
        themeButton.backgroundColor = backgroundColor
        let switchArray = [maxTemp, minTemp, actRain, predRain, windSpeed, windDir, humidity, airPressure]
        for swtch in switchArray {
            swtch?.onTintColor = textColor
        }
    }
    
    // Update the data for the switched used to display the setting information
    func updateSwitches() {
        for data in detailsArray {
            airPressure.isOn = data.value(forKey: kAirPressure) as! Bool
            maxTemp.isOn = data.value(forKey: kHighTemp) as! Bool
            humidity.isOn = data.value(forKey: kHumidity) as! Bool
            minTemp.isOn = data.value(forKey: kLowTemp) as! Bool
            actRain.isOn = data.value(forKey: kRainFallen) as! Bool
            predRain.isOn = data.value(forKey: kRainPredicted) as! Bool
            windDir.isOn = data.value(forKey: kWindDirction) as! Bool
            windSpeed.isOn = data.value(forKey: kWindSpeed) as! Bool
        }
    }
    
    // Save the data for the switched into core data
    func saveSwitches() {
        var details = [Details]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Details")
        request.returnsObjectsAsFaults = false
        do {
            details = try (context.fetch(Details.fetchRequest()) as! [Details])
        } catch {}
        for data in details {
            data.airPressure = airPressure.isOn
            data.highTemp = maxTemp.isOn
            data.lowTemp = minTemp.isOn
            data.rainFallen = actRain.isOn
            data.rainPredicted = predRain.isOn
            data.windSpeed = windSpeed.isOn
            data.windDirection = windDir.isOn
            data.humidity = humidity.isOn
        }
        do {
            try context.save()
        } catch {}
    }

    // Save button. Saves the switch information into core data, then presents the WeatherViewController
    @IBAction func saveButtonTouchUp(_ sender: Any) {
        saveSwitches()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! ViewController
        //controller.initialiseWeather()
        self.present(controller, animated: true, completion: nil)
    }
}
