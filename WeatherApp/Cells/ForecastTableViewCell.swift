//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by James Furlong on 25/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit
import CoreData

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet var DaysArray: [UILabel]!
    @IBOutlet var IconArray: [UIImageView]!
    @IBOutlet var TempArray: [UILabel]!
    @IBOutlet weak var forecastLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadCoreData()
    }
    // Load the theme from Core Data
    func loadCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Theme")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [Theme]
            if result.isEmpty {
                setColors(back: UIColor.white, text: UIColor.darkGray)
            } else {
                for data in result {
                    switch data.theme {
                    case kWinter : setColors(back: UIColor.white, text: UIColor.darkGray)
                    case kSummer : setColors(back: UIColor(red: 201/255, green: 224/255, blue: 212/225, alpha: 1.0), text:UIColor(red: 26/255, green: 86/255, blue: 132/255, alpha: 1.0))
                    case kDark : setColors(back: UIColor.black, text: UIColor(red: 196/255, green: 188/255, blue: 186/255, alpha: 1.0))
                    case kAutumn : setColors(back: UIColor(red: 188/255, green: 132/255, blue: 98/255, alpha: 1.0), text: UIColor(red: 132/255, green: 42/255, blue: 26/255, alpha: 1.0))
                    default : setColors(back: UIColor.white, text: UIColor.darkGray)
                    }
                }
            }
        } catch {
            print("Data retrieval failed")
        }
    }
    
    // Set the colors for the cell
    func setColors(back: UIColor, text: UIColor) {
        for label in DaysArray {
            label.textColor = text
            label.backgroundColor = back
        }
        for label in TempArray {
            label.textColor = text
            label.backgroundColor = back
        }
        for images in IconArray {
            images.backgroundColor = back
        }
        forecastLabel.textColor = text
        forecastLabel.backgroundColor = back
    }
}
