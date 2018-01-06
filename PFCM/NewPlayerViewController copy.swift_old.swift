//
//  PlayerViewController.swift
//  Premier Football Club Management
//
//  Created by Thomas Anderson on 05/02/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Former

class NewPlayerViewController: UITableViewController {
    
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
    //@IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func create(_ sender: Any) {
        
        var fName: String!
        if firstName.text == "" {
            firstName.text = "Not entered."
            fName = firstName.text
        } else {
        fName = firstName.text
        }
        
        var lName: String!
        if lastName.text == "" {
            lastName.text = "Not entered."
            lName = lastName.text
        } else {
            lName = lastName.text
        }
        
        var dateofbirth: String!
        if dob.text == "" {
            dob.text = "Not entered."
            dateofbirth = dob.text
        } else {
            dateofbirth = dob.text
        }
        
        var add1: String!
        if address1.text == "" {
            address1.text = "Not entered."
            add1 = address1.text
        } else {
            add1 = address1.text
        }
        
        var add2: String!
        if address2.text == "" {
            address2.text = "Not entered."
            add2 = address2.text
        } else {
            add2 = address2.text
        }
        
        var cityVar: String!
        if city.text == "" {
            city.text = "Not entered."
            cityVar = city.text
        } else {
            cityVar = city.text
        }
        
        var pC: String!
        if postCode.text == "" {
            postCode.text = "Not entered."
            pC = postCode.text
        } else {
            pC = postCode.text
        }
        
        var p1: String!
        if position.text == "" {
            position.text = "Not entered."
            p1 = position.text
        } else {
            p1 = position.text
        }
        
        var p2: String!
        if position2.text == "" {
            position2.text = "Not entered."
            p2 = position2.text
        } else {
            p2 = position.text
        }
        
        var p3: String!
        if position3.text == "" {
            position3.text = "Not entered."
            p3 = position3.text
        } else {
            p3 = position3.text
        }
        
        var sNo: String!
        if squadNo.text == "" {
            squadNo.text = "Not entered."
            sNo = squadNo.text
        } else {
            sNo = squadNo.text
        }
        
        let playerDbRef = ref.child("playerDatabase").childByAutoId()
        
        
       /* let player = Player (firstName: fName, lastName: lName, dob: dateofbirth, address1: add1, address2: add2, city: cityVar, postCode: pC, position: p1, position2: p2, position3: p3, squadNo: sNo, appearances: "N/A", goals: "N/A", assists: "N/A")*/
        
        //print(player)
        
        playerDbRef.child("fname").setValue(fName)
        playerDbRef.child("lname").setValue(lName)
        playerDbRef.child("dob").setValue(dateofbirth)
        playerDbRef.child("add1").setValue(add1)
        playerDbRef.child("add2").setValue(add2)
        playerDbRef.child("cityVar").setValue(cityVar)
        playerDbRef.child("pC").setValue(pC)
        playerDbRef.child("p1").setValue(p1)
        

        
        
       // playerDbRef.setValue(3.14)
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
