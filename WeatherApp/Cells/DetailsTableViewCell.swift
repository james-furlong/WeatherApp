//
//  DetailsTableViewCell.swift
//  WeatherApp
//
//  Created by James Furlong on 27/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit
import CoreData

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var DataLabel1: UILabel!
    @IBOutlet weak var DataDetails1: UILabel!
    @IBOutlet weak var DataLabel2: UILabel!
    @IBOutlet weak var DataDetails2: UILabel!
    
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
                    case kSummer : setColors(back: UIColor(red: 201/255, green: 224/255, blue: 212/225, alpha: 1.0), text: UIColor(red: 26/255, green: 86/255, blue: 132/255, alpha: 1.0))
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
    
    
    // Set the theme colors for the cell
    func setColors(back: UIColor, text: UIColor) {
        DataLabel1.textColor = text
        DataLabel1.backgroundColor = back
        DataDetails1.textColor = text
        DataDetails1.backgroundColor = back
        DataLabel2.textColor = text
        DataLabel2.backgroundColor = back
        DataDetails2.textColor = text
        DataDetails2.backgroundColor = back
    }
}
