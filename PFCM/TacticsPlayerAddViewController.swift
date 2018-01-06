//
//  TacticsPlayerAddViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 26/02/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class TacticsPlayerAddViewController: UITableViewController {
    
    var results: [Player] = []
    var searchResults: [Player] = []
    var searchController: UISearchController!
    var playerID: String?
    var playerName: String?
    var playerNo: String?
    var picPath: String?
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    
    var selectedPosition: UIView?
    
    @IBAction func selectPlayer(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let confirmAlertView = SCLAlertView(appearance: appearance)
        
        confirmAlertView.addButton("Yes") {
            let viewController = "TacticCreator"
            let storyboard : UIStoryboard = UIStoryboard(name: "Tactics", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: viewController) as? TacticalCreatorViewController
            vc?.picPath = self.picPath
            vc?.playerNo = self.playerNo
            vc?.playerName = self.playerName
            vc?.selectedPosition = self.selectedPosition
            vc?.playerID = self.playerID
            vc?.setPlayer()
            
            self.dismiss(animated: true, completion: nil)
        }
        
        confirmAlertView.addButton("No") {
            
        }
        if (playerNo != nil) && (playerName != nil) {
            confirmAlertView.showInfo("Select Player?", subTitle: "Select #\(playerNo!) \(playerName!)?")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrievePlayers()
        setupSearch()
        searchController.loadViewIfNeeded()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func retrievePlayers () {
        self.results.removeAll()
        
        let club = FIRAuth.auth()?.currentUser?.uid
        let clubRef = ref.child(club!)
        let playersRef = clubRef.child("players").queryOrdered(byChild: "lastName")
        
        playersRef.observe(.value, with: { (snapshot) in
            
            var players: [Player] = []
            
            for item in snapshot.children {
                let player = Player(snapshot: item as! FIRDataSnapshot)
                players.append(player)
                print("adding players....")
                self.results = players
                print(player)
            }
            
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : results.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if self.searchController.isActive == false {
                cell.fadeOut(withDuration: 0)
                cell.fadeIn()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! CustomPlayerTableViewCell
        let players : Player = searchController.isActive ? searchResults[indexPath.item] : results[indexPath.row]
        let storageRef = storage.reference(withPath: players.picURL)
        
        cell.name.text = "\(players.firstName) \(players.lastName)"
        cell.dob.text = players.dob
        cell.squadNumber.text = "#\(players.squadNo)"
        cell.stats.text = "Apps: \(players.apps), G: \(players.goals), A: \(players.assists)"
        cell.circlePicture()
        cell.profilePic.sd_setImage(with: storageRef)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell : Player = searchController.isActive ? searchResults[indexPath.item] : results[indexPath.row]
        playerName = selectedCell.lastName
        playerNo = selectedCell.squadNo
        picPath = selectedCell.picURL
        playerID = selectedCell.pid
    }
    
    
}

// MARK: - UISearchResultsUpdating
extension TacticsPlayerAddViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        print (searchText)
        searchResults = results.filter { player in
            return player.firstName.lowercased().contains(searchText.lowercased()) || player.lastName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension TacticsPlayerAddViewController:  UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}


