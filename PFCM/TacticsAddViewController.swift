//
//  TacticsAddTacticViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 21/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import PKHUD

class TacticsAddViewController: UIViewController {
    
    var presetTactics = PresetTactic.fetchTactics()
    let cellScaling: CGFloat = 0.6
    

    @IBOutlet weak var orig: UILabel!
    @IBOutlet weak var formationChosen: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    var chosenTactic: String?
    var currentPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self

        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func choose(_ sender: Any) {
        loadPreset = true
        chosenPreset = chosenTactic!
        dismiss(animated: true, completion: nil)
        HUD.flash(HUDContentType.label("Formation loading..."), delay: 1.0)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    
}

extension TacticsAddViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetTactics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PresetTacticCell", for: indexPath) as! CustomTacticCollectionViewCell
        
        cell.tactic = presetTactics[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPath = indexPath
        
        chooseButton.isUserInteractionEnabled = true
        chooseButton.titleLabel?.textColor = UIColor(hex: "#31A343")
        
        let tactic = presetTactics[indexPath.item]
        
        switch tactic.name {
        case  "4-4-2":
            print("The 4-4-2")
            chosenTactic = "4-4-2"
            orig.isHidden = true
            formationChosen.text = "4-4-2"
            formationChosen.isHidden = false
        case "4-3-3":
            print("The 4-3-3")
            chosenTactic = "4-3-3"
            orig.isHidden = true
            formationChosen.text = "4-3-3"
            formationChosen.isHidden = false
        case "4-2-3-1":
            print("The 4-2-3-1")
            chosenTactic = "4-2-3-1"
            orig.isHidden = true
            formationChosen.text = "4-2-3-1"
            formationChosen.isHidden = false
        case "3-4-3":
            print("The 3-4-3")
            chosenTactic = "3-4-3"
            orig.isHidden = true
            formationChosen.text = "3-4-3"
            formationChosen.isHidden = false
        case "3-5-2":
            print("The 3-5-2")
            chosenTactic = "3-5-2"
            orig.isHidden = true
            formationChosen.text = "3-5-2"
            formationChosen.isHidden = false
        case "3-6-1":
            print("The 3-6-1")
            chosenTactic = "3-6-1"
            orig.isHidden = true
            formationChosen.text = "3-6-1"
            formationChosen.isHidden = false
        case "5-3-2":
            print("The 5-3-2")
            chosenTactic = "5-3-2"
            orig.isHidden = true
            formationChosen.text = "5-3-2"
            formationChosen.isHidden = false
        default:
            print("default")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        chooseButton.isUserInteractionEnabled = false
        chooseButton.titleLabel?.textColor = UIColor.lightGray
    }
}

extension TacticsAddViewController : UIScrollViewDelegate, UICollectionViewDelegate
{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
        chooseButton.isUserInteractionEnabled = false
        chooseButton.titleLabel?.textColor = UIColor.lightGray
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentPath != nil {
        collectionView.deselectItem(at: currentPath!, animated: false)
        // print ("Current path is: \(currentPath!)")
            
        formationChosen.isHidden = true
        orig.isHidden = false
        }
    }
    

}
