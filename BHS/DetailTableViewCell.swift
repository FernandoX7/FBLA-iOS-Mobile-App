//
//  DetailTableViewCell.swift
//  BHS
//
//  Created by Fernando Ramirez
//  Copyright (c) 2014 oXpheen. All rights reserved.
//

import UIKit

// Custom cells for the view that comes up when you click the main view
class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!
    @IBOutlet var mapButton:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
