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
                    case kSummer : setColors(back: UIColor.blue, text: UIColor.yellow)
                    case kDark : setColors(back: UIColor.black, text: UIColor.white)
                    case kAutumn : setColors(back: UIColor.brown, text: UIColor.orange)
                    default : setColors(back: UIColor.white, text: UIColor.darkGray)
                    }
                }
            }
        } catch {
            print("Data retrieval failed")
        }
    }
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
