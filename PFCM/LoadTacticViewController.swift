//
//  LoadTacticViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 26/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import PKHUD

class LoadTacticViewController: UITableViewController {
    
    let club = FIRAuth.auth()?.currentUser
    var results = [Tactic]()
    var searchResults = [Tactic]()
    var searchController: UISearchController!
    var tacticName: String?
    var date: String?
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    var tacticID: String?
    
    var gkCoord: [Double]?
    var p2Coord: [Double]?
    var p3Coord: [Double]?
    var p4Coord: [Double]?
    var p5Coord: [Double]?
    var p6Coord: [Double]?
    var p7Coord: [Double]?
    var p8Coord: [Double]?
    var p9Coord: [Double]?
    var p10Coord: [Double]?
    var p11Coord: [Double]?
    
    var annotationLink: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveTactics()
        setupSearch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func retrieveTactics () {
        let clubRef = ref.child(club!.uid)
        let tacticsRef = clubRef.child("tactics")
        tacticsRef.observe(.value, with: { (snapshot) in
            
            var tactics: [Tactic] = []
            
            for item in snapshot.children {
                let tactic = Tactic(snapshot: item as! FIRDataSnapshot)
                tactics.append(tactic)
                print("adding tactics....")
            }
            
            self.results = tactics
            self.searchResults = tactics
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func setupSearch() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.barTintColor = UIColor.white
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = ""
        searchController.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        searchController.hidesNavigationBarDuringPresentation = false
        
        //definesPresentationContext = true
        tableView.tableHeaderView?.addSubview(searchController.searchBar)
        searchController.searchBar.showsCancelButton = false
        
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

   
    @IBAction func selectTactic(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let confirmAlertView = SCLAlertView(appearance: appearance)
        
        confirmAlertView.addButton("Yes") {
            lgkCoord = CGPoint(x: self.gkCoord!.first!, y: self.gkCoord!.last!)
            lp2Coord = CGPoint(x: self.p2Coord!.first!, y:self.p2Coord!.last!)
            lp3Coord = CGPoint(x: self.p3Coord!.first!, y: self.p3Coord!.last!)
            lp4Coord = CGPoint(x: self.p4Coord!.first!, y: self.p4Coord!.last!)
            lp5Coord = CGPoint(x: self.p5Coord!.first!, y: self.p5Coord!.last!)
            lp6Coord = CGPoint(x: self.p6Coord!.first!, y: self.p6Coord!.last!)
            lp7Coord = CGPoint(x: self.p7Coord!.first!, y: self.p7Coord!.last!)
            lp8Coord = CGPoint(x: self.p8Coord!.first!, y: self.p8Coord!.last!)
            lp9Coord = CGPoint(x: self.p9Coord!.first!, y: self.p9Coord!.last!)
            lp10Coord = CGPoint(x: self.p10Coord!.first!, y: self.p10Coord!.last!)
            lp11Coord = CGPoint(x: self.p11Coord!.first!, y: self.p11Coord!.last!)
            
            lannotationLink = self.annotationLink
            
            loadTactic = true
            
            self.dismiss(animated: true, completion: nil)
            HUD.flash(HUDContentType.label("Loading tactic..."), delay: 1.5)
    }

        
        confirmAlertView.addButton("No") {
            
        }
            confirmAlertView.showInfo("Select Tactic?", subTitle: "Select \(tacticName!)?")
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? searchResults.count : results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loadTactic", for: indexPath) as! CustomTacticTableViewCell
        let object = searchController.isActive ? searchResults[indexPath.item] : results[indexPath.item]
        cell.name.text = object.tacticName
        cell.date.text = object.date

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell : Tactic = searchController.isActive ? searchResults[indexPath.item] : results[indexPath.row]
        gkCoord = [selectedCell.gkCoord_x, selectedCell.gkCoord_y]
        p2Coord = [selectedCell.p2Coord_x, selectedCell.p2Coord_y]
        p3Coord = [selectedCell.p3Coord_x, selectedCell.p3Coord_y]
        p4Coord = [selectedCell.p4Coord_x, selectedCell.p4Coord_y]
        p5Coord = [selectedCell.p5Coord_x, selectedCell.p5Coord_y]
        p6Coord = [selectedCell.p6Coord_x, selectedCell.p6Coord_y]
        p7Coord = [selectedCell.p7Coord_x, selectedCell.p7Coord_y]
        p8Coord = [selectedCell.p8Coord_x, selectedCell.p8Coord_y]
        p9Coord = [selectedCell.p9Coord_x, selectedCell.p9Coord_y]
        p10Coord = [selectedCell.p10Coord_x, selectedCell.p10Coord_y]
        p11Coord = [selectedCell.p11Coord_x, selectedCell.p11Coord_y]
        annotationLink = selectedCell.aURL
        tacticName = selectedCell.tacticName
        tacticID = selectedCell.tid
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let selectedCell : Tactic = searchController.isActive ? searchResults[indexPath.item] : results[indexPath.row]
        
        if editingStyle == .delete {
           
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let confirmAlertView = SCLAlertView(appearance: appearance)
            
            confirmAlertView.addButton("Yes") {
                let clubRef = self.ref.child(self.club!.uid)
                let tacticsRef = clubRef.child("tactics")
                let currentTactic = tacticsRef.child(selectedCell.tid)
                currentTactic.removeValue()
            }
            confirmAlertView.addButton("No") {
            
            }
            confirmAlertView.showInfo("Clear?", subTitle: "Are you sure you want to delete this tactic?")
            
        }
    }


}

// MARK: - UISearchResultsUpdating
extension LoadTacticViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        print (searchText)
        searchResults = results.filter { tactic in
            return tactic.tacticName.lowercased().contains(searchText.lowercased()) || tactic.date.lowercased().contains(searchText.lowercased())
        }

        tableView.reloadData()
    }
    
}

// MARK: - UISearchBarDelegate
extension LoadTacticViewController:  UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}
