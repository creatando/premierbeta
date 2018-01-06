//
//  HomeMenu.swift
//  PFCM
//
//  Created by Thomas Anderson on 26/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit

class Menu {
    var name = ""
    var image: UIImage
    var color: UIColor
    
    init(name: String, tacticImage: UIImage, color: UIColor)
    {
        self.name = name
        self.image = tacticImage
        self.color = color
    }
    
    
    static func fetchHomeMenu() -> [Menu]
    {
        return [
            Menu(name: "Player Centre", tacticImage: UIImage(named: "menu1.jpg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Menu(name: "Tactical Centre", tacticImage: UIImage(named: "menu5.jpg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Menu(name: "Social Centre", tacticImage: UIImage(named: "menu6.jpg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            //Menu(name: "Match Centre", tacticImage: UIImage(named: "menu2.jpeg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Menu(name: "Message", tacticImage: UIImage(named: "menu4.jpg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            //Menu(name: "Club Settings", tacticImage: UIImage(named: "menu3.jpeg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
        ]
    }
    
    static func fetchPlayerCentre () -> [Menu]
    {
        return [
            Menu(name: "View Players", tacticImage: UIImage(named: "menu1.jpg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Menu(name: "Add Player", tacticImage: UIImage(named: "menu4.jpg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
        ]
    }
    
    static func fetchPlayerMenu () -> [Menu]
    {
        return [
            Menu(name: "View Profile", tacticImage: UIImage(named: "menu1.jpg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            Menu(name: "Social Centre", tacticImage: UIImage(named: "menu6.jpg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
           // Menu(name: "Match Centre", tacticImage: UIImage(named: "menu2.jpeg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
            //Menu(name: "User Settings", tacticImage: UIImage(named: "menu3.jpeg")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)),
        ]
    }
    
    
}
