//
//  ViewPlayerController.swift
//  PFCM
//
//  Created by Thomas Anderson on 14/02/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import Hue
import PKHUD
import SDWebImage

class ViewPlayersController: UITableViewController {

    @IBAction func backNav(_ sender: Any) {
                self.dismiss(animated: true, completion: nil)
    }
    var results: [Player] = []
    var searchResults: [Player] = []
    var searchController: UISearchController!
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let club = FIRAuth.auth()?.currentUser
    var playerID: String?
    var savedIndexPath: IndexPath?
    var playerName: String?
    var fullname: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrievePlayers()
        setupSearch()
        searchController.loadViewIfNeeded()
        tableView.reloadData()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func selectButton(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Yes") {
            self.performSegue(withIdentifier: "EPS", sender: self)
        }
        
        alertView.addButton("No") {

        }
        if self.playerID != nil{
        alertView.showWait("View/Edit", subTitle: "Select \(playerName!)?")
        }
    }
    
    func retrievePlayers () {
        let clubRef = ref.child(club!.uid)
        self.results.removeAll()
        
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
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.white
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView?.addSubview(searchController.searchBar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : results.count
    }
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        savedIndexPath = indexPath
        let selectedCell : Player = searchController.isActive ? searchResults[indexPath.item] : results[indexPath.row]
        playerID = selectedCell.pid
        playerName = "\(selectedCell.firstName) \(selectedCell.lastName)"
        print("Selected person: \(selectedCell.firstName) & ID: \(playerID!)")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! CustomPlayerTableViewCell
        let players : Player = searchController.isActive ? searchResults[indexPath.item] : results[indexPath.row]
        let storageRef = storage.reference(withPath: players.picURL)
        
        fullname = "\(players.firstName) \(players.lastName)"
        cell.name.text = fullname
        cell.dob.text = players.dob
        cell.squadNumber.text = "#\(players.squadNo)"
        cell.stats.text = "Apps: \(players.apps), G: \(players.goals), A: \(players.assists)"
        cell.circlePicture()
        storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("error has occured: \(error)")
            } else {
                let image = UIImage(data: data!)
                cell.profilePic.image = image
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
       return false
    }


    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepared is called!")
            let nextScene = segue.destination as? EditPlayerViewController
            nextScene?.selectedPlayer = playerID!
    }
    
    

}


// MARK: - UISearchResultsUpdating
extension ViewPlayersController: UISearchResultsUpdating {
    
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
extension ViewPlayersController:  UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.tableView.reloadData()
    }
}

