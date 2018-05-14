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
    
    func updateColors() {
        for label in labelCollection {
            label.setTitleColor(textColor, for: .normal)
        }
        view.backgroundColor = backgroundColor
        doneButton.setTitleColor(backgroundColor, for: .normal)
        doneButton.backgroundColor = textColor
    }

    @IBAction func themeTouchedUo(_ sender: UIButton) {
        switch sender.tag {
        case 0 : theme = kWinter
            textColor = UIColor.darkGray
            backgroundColor = UIColor.white
        case 1 : theme = kSummer
            textColor = UIColor.yellow
            backgroundColor = UIColor.blue
        case 2 : theme = kDark
            textColor = UIColor.white
            backgroundColor = UIColor.black
        case 3 : theme = kAutumn
            textColor = UIColor.orange
            backgroundColor = UIColor.brown
        default : theme = kWinter
            textColor = UIColor.darkGray
            backgroundColor = UIColor.white
        }
        updateColors()
        setThemeData()
    }
    
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
        case kSummer : backgroundColor = UIColor.cyan
            textColor = UIColor.yellow
        case kAutumn : backgroundColor = UIColor.brown
            textColor = UIColor.orange
        case kDark : backgroundColor = UIColor.black
            textColor = UIColor.white
        default : backgroundColor = UIColor.white
            textColor = UIColor.darkGray
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
