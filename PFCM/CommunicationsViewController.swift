//
//  CommunicationsViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 18/04/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

var mailArray: [String] = []
var txtArray: [String] = []

class CommunicationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {


    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var visuals: UIVisualEffectView!
    @IBOutlet weak var mail: UIImageView!
    @IBOutlet weak var texting: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessage: UIButton!
    
    var results: [User] = []
    var searchResults: [User] = []
    
    var searchController: UISearchController!
    let currentUser = FIRAuth.auth()?.currentUser
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    var commsType: String?
    let msgVC = MFMessageComposeViewController()
    let mailVC = MFMailComposeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visuals.fadeOut(withDuration: 0)
        background.fadeOut(withDuration: 0)
        mail.fadeOut(withDuration: 0)
        texting.fadeOut(withDuration: 0)
        tableView.fadeOut(withDuration: 0)
        tableView.delegate = self
        tableView.dataSource = self
        msgVC.messageComposeDelegate = self
        mailVC.mailComposeDelegate = self
        
        retrieve()
        setupSearch()
        background.fadeIn(withDuration: 0.5)
        visuals.fadeIn(withDuration: 1.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.tableView.fadeIn()
            self.visuals.fadeIn()
            self.background.fadeIn()
            self.mail.fadeIn()
            self.texting.fadeIn()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    private func retrieve() {
        
        let usersRef = ref.child("users")

        usersRef.observe(.value, with: { (snapshot) in
            
                if let users = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    self.results.removeAll()
                    for profile in users {
                        let usersClub = profile.childSnapshot(forPath: "club").value as! String?
                        if usersClub == self.currentUser?.uid {
                        let user = User(snapshot: profile)
                        self.results.append(user)
                        }
                    }
                    self.results.sort(by: {$0.name > $1.name})
                }
            self.tableView.reloadData()
        })
    }
    
    func sendTxt(contacts: [String]) {
        if !MFMessageComposeViewController.canSendText() {
            let alertController = UIAlertController(title: "Error", message: "Text services not available for your device.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            msgVC.recipients = txtArray
            msgVC.modalTransitionStyle = .crossDissolve
            self.present(msgVC, animated: true, completion: nil)
        }
    }
    
    func sendEmail(contacts: [String]) {
        if !MFMailComposeViewController.canSendMail() {
            let alertController = UIAlertController(title: "Error", message: "Mail services not available for your device.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            mailVC.setBccRecipients(mailArray)
            mailVC.modalTransitionStyle = .crossDissolve
            self.present(mailVC, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sending (_ sender: UIButton) {
        print("sending: \(commsType!)")
        
        switch (commsType!) {
        case "email":
            print ("sending email")
            sendEmail(contacts: mailArray)
            break
        case "txt":
            print ("sending txt")
            sendTxt(contacts: txtArray)
            break
        default:
            print("default")
        }
        
    }
    
    @IBAction func email(_ sender: UITapGestureRecognizer) {
        mail.alpha = 1
        commsType = "email"
        tableView.allowsMultipleSelection = true
        sendMessage.isHidden = false
        //sendMessage.setTitle("SEND EMAIL", for: .normal)
        texting.alpha = 0.2
    }
    
    @IBAction func text(_ sender: UITapGestureRecognizer) {
        texting.alpha = 1
        commsType = "txt"
        tableView.allowsMultipleSelection = true
        sendMessage.isHidden = false
        //sendMessage.setTitle("SEND TXT", for: .normal)
        mail.alpha = 0.3
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if self.searchController.isActive == false {
                cell.fadeOut(withDuration: 0)
                cell.fadeIn()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlobalCell", for: indexPath) as! GlobalSearchCell
        let users: User = self.results[indexPath.row]
        let storageRef = storage.reference(withPath: users.imgURL)
        
        cell.circlePicture()
        cell.profile.sd_setImage(with: storageRef)
        cell.name.text = users.name
        cell.email.text = users.email
        cell.phone.text = users.phone
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user : User = searchController.isActive ? searchResults[indexPath.item] : results[indexPath.row]
            if let selectedCell = tableView.cellForRow(at: indexPath) as? GlobalSearchCell {
                selectedCell.accessoryType = .checkmark
                let selectedEmail = user.email
                let selectedNo = user.phone
                
                mailArray.append(selectedEmail)
                txtArray.append(selectedNo)
                
                print("mail: \(mailArray)")
                print("txt: \(txtArray)")
        }
        
    }
    
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let user : User = searchController.isActive ? searchResults[indexPath.item] : results[indexPath.row]
        if let deselectedCell = tableView.cellForRow(at: indexPath) as? GlobalSearchCell {
            
            deselectedCell.accessoryType = .none
            let mailIndex = mailArray.index(of: user.email)
            mailArray.remove(at: mailIndex!)
            print("mail: \(mailArray)")
            
            let txtIndex = txtArray.index(of: user.phone)
            txtArray.remove(at: txtIndex!)
            print("txt: \(txtArray)")
        }
    }


}

// MARK: - UISearchResultsUpdating
extension CommunicationsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        print (searchText)
        searchResults = results.filter { user in
            return user.name.lowercased().contains(searchText.lowercased()) || user.email.lowercased().contains(searchText.lowercased()) || user.phone.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
}

// MARK: - UISearchBarDelegate
extension CommunicationsViewController:  UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}
