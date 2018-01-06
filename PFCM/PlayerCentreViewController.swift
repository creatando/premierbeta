//
//  PlayerCentreViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 03/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit


class PlayerCentreViewController: UIViewController {
    
    var menuItems = Menu.fetchPlayerCentre()
    let cellScaling: CGFloat = 0.6
    var currentPath: IndexPath?
    @IBOutlet weak var collectionView: UICollectionView!
    
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
            self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func menuButton(_ sender: UIButton) {
        print ("main menu button clicked")
    }
    
    @IBAction func home(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PlayerCentreViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuViewCell
        
        cell.menu = menuItems[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPath = indexPath
        let items = menuItems[currentPath!.item]
        switch items.name {
        case  "View Players":
            print("view")
            performSegue(withIdentifier: "VPSegue", sender: nil)
        case  "Add Player":
            print("add")
            performSegue(withIdentifier: "APSegue", sender: nil)
        default:
            print("default")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
    
}

extension PlayerCentreViewController : UIScrollViewDelegate, UICollectionViewDelegate
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
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentPath != nil {
            self.collectionView.deselectItem(at: currentPath!, animated: false)
            // print ("Current path is: \(currentPath!)")
            
        }
    }
    
    
}

