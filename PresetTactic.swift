//
//  PresetTactic.swift
//  PFCM
//
//  Created by Thomas Anderson on 22/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import Foundation
import UIKit

class PresetTactic {
var name = ""
var tacticImage: UIImage
var color: UIColor

    init(name: String, tacticImage: UIImage, color: UIColor)
    {
        self.name = name
        self.tacticImage = tacticImage
        self.color = color
    }
    
    
    static func fetchTactics() -> [PresetTactic]
    {
        return [
            PresetTactic(name: "4-4-2", tacticImage: UIImage(named: "442.JPG")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            PresetTactic(name: "4-3-3", tacticImage: UIImage(named: "433.JPG")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            PresetTactic(name: "4-2-3-1", tacticImage: UIImage(named: "4231.JPG")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            PresetTactic(name: "3-4-3", tacticImage: UIImage(named: "343.JPG")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            PresetTactic(name: "3-5-2", tacticImage: UIImage(named: "352.JPG")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            PresetTactic(name: "3-6-1", tacticImage: UIImage(named: "361.JPG")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            PresetTactic(name: "5-3-2", tacticImage: UIImage(named: "532.JPG")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
        ]
    }
    

}
