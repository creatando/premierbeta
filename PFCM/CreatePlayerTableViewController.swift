//
//  CreatePlayerTableViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 06/02/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Former

class CreatePlayerTableViewController: UITableViewController {
    
    var databaseRef: FIRDatabaseReference!
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postCode: UITextField!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var position2: UITextField!
    @IBOutlet weak var position3: UITextField!
    @IBOutlet weak var squadNo: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        return 0
    }
    
    
    @IBAction func createPlayer(_ sender: Any) {
        
    
        var fName: String!
        firstName.text = fName
        
        var lName: String!
        lastName.text = lName
        
        var dateofbirth: String!
        dob.text = dateofbirth
        
        var add1: String!
        address1.text = add1
        
        var add2: String!
        address2.text = add2
        
        var cityVar: String!
        city.text = cityVar
        
        var pC: String!
        postCode.text = pC
        
        var p1: String!
        position.text = p1
        
        var p2: String!
        position2.text = p2
        
        var p3: String!
        position3.text = p2
        
        var sNo: String!
        squadNo.text = sNo

        
        let playerDbRef = databaseRef.child("playerDatabase").childByAutoId()
        let player = Player (firstName: fName, lastName: lName, dob: dateofbirth, address1: add1, address2: add2, city: cityVar, postCode: pC, position: p1, position2: p2, position3: p3, squadNo: sNo, appearances: "", goals: "", assists: "")
        
        playerDbRef.setValue(player.toAnyObject)
        
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
