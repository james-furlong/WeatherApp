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
        DataLabel1.textColor = text
        DataLabel1.backgroundColor = back
        DataDetails1.textColor = text
        DataDetails1.backgroundColor = back
        DataLabel2.textColor = text
        DataLabel2.backgroundColor = back
        DataDetails2.textColor = text
        DataDetails2.backgroundColor = back
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
