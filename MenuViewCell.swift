//
//  HomeMenuViewCell.swift
//  PFCM
//
//  Created by Thomas Anderson on 26/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit

class MenuViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var backColor: UIView!
    
    var menu: Menu? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        if let menu = menu {
            image.image = menu.image
            name.text = menu.name
            backColor.backgroundColor = menu.color
        } else {
            image.image = nil
            name.text = nil
            backColor.backgroundColor = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 4, height: 10)
        
        self.clipsToBounds = false
    }

}
