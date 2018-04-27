//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by James Furlong on 25/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet var DaysArray: [UILabel]!
    @IBOutlet var IconArray: [UIImageView]!
    @IBOutlet var TempArray: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var spunk = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
