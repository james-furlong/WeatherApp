//
//  DetailsTableViewCell.swift
//  WeatherApp
//
//  Created by James Furlong on 27/4/18.
//  Copyright © 2018 James Furlong. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var DataLabel1: UILabel!
    @IBOutlet weak var DataDetails1: UILabel!
    @IBOutlet weak var DataLabel2: UILabel!
    @IBOutlet weak var DataDetails2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
