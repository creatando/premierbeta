//
//  ResetPasswordViewController.swift
//  Premier Football Club Management
//
//  Created by Thomas Anderson on 04/02/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ResetPasswordViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    override var prefersStatusBarHidden: Bool {return true}

    // Reset Password Action
    @IBAction func submitAction(_ sender: AnyObject)
    {
if self.emailTextField.text == "" {
        let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    
    } else {
        FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
            
            var title = ""
            var message = ""
            
            if error != nil {
                title = "Error!"
                message = (error?.localizedDescription)!
            } else {
                title = "Success!"
                message = "Password reset email sent."
                self.emailTextField.text = ""
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
    }
    

}
