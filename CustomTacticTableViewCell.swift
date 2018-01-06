//
//  CustomTacticTableViewCell.swift
//  PFCM
//
//  Created by Thomas Anderson on 26/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit

class CustomTacticTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBInspectable var selectedColor: UIColor = UIColor.black {
        didSet {
            selectedBackgroundView = UIView()
            selectedBackgroundView?.backgroundColor = selectedColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
