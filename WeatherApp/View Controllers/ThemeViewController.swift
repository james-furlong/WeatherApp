//
//  ThemeViewController.swift
//  WeatherApp
//
//  Created by James Furlong on 30/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit
import CoreData

class ThemeViewController: UIViewController {
    @IBOutlet var tickImagesArray: [UIImageView]!
    @IBOutlet var labelCollection: [UIButton]!
    @IBOutlet weak var doneButton: UIButton!
    
    var theme : String!
    var backgroundColor : UIColor!
    var textColor : UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCoreData()
        updateColors()
        setThemeData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Load the core data
    func loadCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Theme")
        request.returnsObjectsAsFaults = false
        guard let tempTheme = try? context.fetch(request) as! [Theme] else { return }
        for data in tempTheme {
            theme = data.theme
        }
        setColors()
    }
    
    // Set the colors to the view controller as the user selects it. Change the position of the 'tick' to show the user which theme they are currently using.
    func setThemeData() {
        var tagNumber = 0
        switch theme {
        case kWinter : tagNumber = 0
        case kSummer : tagNumber = 1
        case kDark : tagNumber = 2
        case kAutumn : tagNumber = 3
        default : tagNumber = 0
        }
        
        for image in tickImagesArray  {
            image.image = nil
            if image.tag == tagNumber {
                image.image = UIImage(named: "tick")
            }
        }
    }
    
    // Update the colors in accordance with the theme
    func updateColors() {
        for label in labelCollection {
            label.setTitleColor(textColor, for: .normal)
        }
        view.backgroundColor = backgroundColor
        doneButton.setTitleColor(backgroundColor, for: .normal)
        doneButton.backgroundColor = textColor
    }

    // Each theme selection. Triggers the theme change and the change of position for the 'tick'
    @IBAction func themeTouchedUo(_ sender: UIButton) {
        switch sender.tag {
        case 0 : theme = kWinter
            textColor = UIColor.darkGray
            backgroundColor = UIColor.white
        case 1 : theme = kSummer
        backgroundColor = UIColor(red: 201/255, green: 224/255, blue: 212/225, alpha: 1.0)
        textColor = UIColor(red: 26/255, green: 86/255, blue: 132/255, alpha: 1.0)
        case 2 : theme = kDark
        backgroundColor = UIColor.black
        textColor = UIColor(red: 196/255, green: 188/255, blue: 186/255, alpha: 1.0)
        case 3 : theme = kAutumn
        backgroundColor = UIColor(red: 188/255, green: 132/255, blue: 98/255, alpha: 1.0)
        textColor = UIColor(red: 132/255, green: 42/255, blue: 26/255, alpha: 1.0)
        default : theme = kWinter
            textColor = UIColor.darkGray
            backgroundColor = UIColor.white
        }
        updateColors()
        setThemeData()
    }
    
    // Saves the relevant theme to core data and presents the SettingsViewController
    @IBAction func doneButtonTouchedUp(_ sender: Any) {
        var themeDetails = [Theme]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Theme", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Theme")
        request.returnsObjectsAsFaults = false
        do {
            themeDetails = try (context.fetch(Theme.fetchRequest()) as! [Theme])
        } catch {
            print("Theme was not saved")
        }
        if themeDetails.isEmpty {
            let newData = NSManagedObject(entity: entity!, insertInto: context)
            newData.setValue(theme, forKey: "theme")
        } else {
            for data in themeDetails {
                data.theme = theme
            }
        }
        do {
            try context.save()
        } catch {
            print("Theme was not saved")
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as UIViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    func setColors() {
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
    }
}
