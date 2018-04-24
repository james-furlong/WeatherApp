//
//  ViewController.swift
//  WeatherApp
//
//  Created by James Furlong on 23/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var ForecastAndDataTableView: UITableView!
    @IBOutlet var DaysArray: [UILabel]!
    @IBOutlet var DaysWeatherArray: [UIImageView]!
    @IBOutlet var DaysTemoArray: [UILabel]!
    
    var weather = LocationWeather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
