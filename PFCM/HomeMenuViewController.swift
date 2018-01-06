//
//  HomeMenuViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 03/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeMenuViewController: UIViewController {
    
    var menuItems = Menu.fetchHomeMenu()
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
    
    @IBAction func logOut(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Welcome")
                vc.modalTransitionStyle = .crossDissolve
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeMenuViewController : UICollectionViewDataSource {
    
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
        case  "Player Centre":
            print("player centre")
            performSegue(withIdentifier: "PlayerSegue", sender: nil)
        case  "Tactical Centre":
            print("tactical")
            performSegue(withIdentifier: "TacticSegue", sender: nil)
        case  "Social Centre":
            print("social")
            performSegue(withIdentifier: "SocialSegue", sender: nil)
        case  "Match Centre":
            print("fr")
        case  "Message":
            print("message")
            performSegue(withIdentifier: "MessageSegue", sender: nil)
        case  "Club Settings":
            print("settings")
        default:
            print("default")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }

    
}

extension HomeMenuViewController : UIScrollViewDelegate, UICollectionViewDelegate
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



