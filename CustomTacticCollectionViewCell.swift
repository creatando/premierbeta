//
//  CustomTacticCollectionViewCell.swift
//  PFCM
//
//  Created by Thomas Anderson on 22/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit

class CustomTacticCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tacticImage: UIImageView!
    @IBOutlet weak var tacticName: UILabel!
    @IBOutlet weak var backColor: UIView!
    
    var tactic: PresetTactic? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        if let tactic = tactic {
            tacticImage.image = tactic.tacticImage
            tacticName.text = tactic.name
            backColor.backgroundColor = tactic.color
        } else {
            tacticImage.image = nil
            tacticName.text = nil
            backColor.backgroundColor = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2, height: 10)
        
        self.clipsToBounds = false
    }
    
    
}
