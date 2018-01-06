//
//  GlobalSearchCell.swift
//  PFCM
//
//  Created by Thomas Anderson on 18/04/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit

class GlobalSearchCell: UITableViewCell {
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
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
    
    func circlePicture () {
        self.profile.layer.cornerRadius = self.profile.frame.size.width / 2
        self.profile.layer.borderColor = UIColor.white.cgColor
        self.profile.layer.borderWidth = 1.5
        self.profile.layer.shouldRasterize = true
    }
   
}
