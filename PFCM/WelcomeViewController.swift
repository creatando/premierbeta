//
//  WelcomeViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 21/02/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import SwiftVideoBackground

class WelcomeViewController: UIViewController {

    @IBOutlet var backgroundVideo: BackgroundVideo!
    override var prefersStatusBarHidden: Bool {return true}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundVideo.createBackgroundVideo(name: "PremierBackground", type: "mp4", alpha: 0.3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
