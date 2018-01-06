//
//  PlayerViewController.swift
//  Premier Football Club Management
//
//  Created by Thomas Anderson on 05/02/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import SCLAlertView
import SwiftValidator
import Firebase

extension UIImage {
    func generateJPEGRepresentation() -> Data {
        let newImage = self.copyOriginalImage()
        let newData = UIImageJPEGRepresentation(newImage, 0.75)
        return newData!
    }
    private func copyOriginalImage() -> UIImage {
        UIGraphicsBeginImageContext(self.size);
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
}

class NewPlayerViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, ValidationDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var emailAdd: UITextField!
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postCode: UITextField!
    @IBOutlet weak var position: UITextField!
    @IBOutlet weak var position2: UITextField!
    @IBOutlet weak var position3: UITextField!
    @IBOutlet weak var squadNo: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var genPassword: UITextField!
    @IBOutlet weak var emailConfirm: UITextField!
    @IBOutlet weak var squad: UITextField!
    
    let imagePicker = UIImagePickerController()
    var createButtonClicked = false
    let validator = Validator()
    var positionData = ["", "GK", "LB", "CB", "RB", "LWB", "RWB", "DM", "CM", "LM", "RM", "CAM", "LW", "RW", "CF"]
    var squadNoData = ["","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99"]
    var picker = UIPickerView()
    var picker2 = UIPickerView()
    var picker3 = UIPickerView()
    var sNoPicker = UIPickerView()
    var storedURL: String?
    let clubID = FIRAuth.auth()?.currentUser?.uid
    let randomPw = String.random()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circlePicture()
        formDelegation()
        formValidation()
        genPassword.text = randomPw
        genPassword.inputView = UIView()
        genPassword.tintColor = .clear
    }
    
    @IBAction func dateEditField(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(NewPlayerViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func backNav(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let confirmAlertView = SCLAlertView(appearance: appearance)
        
        if self.createButtonClicked == false {
            confirmAlertView.addButton("Yes") {
                self.dismiss(animated: true, completion: nil)
                self.createButtonClicked = false
            }
            
            confirmAlertView.addButton("No") {
                self.createButtonClicked = false
            }
            self.view.endEditing(true)
            confirmAlertView.showInfo("Leave", subTitle: "Are you sure you want to exit before adding another player?")
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePic.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createPlayer(_ sender: Any) {
            validator.validate(self)
    }
    
    // Validation Delegates
    
    func validationSuccessful() {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "GoogleService-Info", ofType: "plist")!
        let options = FIROptions.init(contentsOfFile: path)
        FIRApp.configure(withName: "Secondary", options: options!)
        let secondary_app = FIRApp.init(named: "Secondary")
        let second_auth = FIRAuth(app: secondary_app!)
        
        second_auth?.createUser(withEmail: emailAdd.text!, password: genPassword.text!) { (user, error) in
            
            if error == nil {
                
                
                let storage = FIRStorage.storage()
                let storageRef = storage.reference()
                let picPath = "\(self.clubID!)/players/\(user!.uid).jpg"
                self.storedURL = picPath
                let picRef = storageRef.child(picPath)
                let data = UIImageJPEGRepresentation(self.profilePic.image!, 0.7)! as Data
                picRef.put(data,metadata: nil)
                
                let player = Player(
                    pid: user!.uid,
                    club: self.clubID!,
                    squad: self.squad.text!,
                    firstName: self.firstName.text!,
                    lastName: self.lastName.text!,
                    dob: self.dob.text!,
                    phoneNo: self.phoneNo.text!,
                    emailAdd: self.emailAdd.text!,
                    address1: self.address1.text!,
                    address2: self.address2.text!,
                    city: self.city.text!,
                    postCode:  self.postCode.text!,
                    position: self.position.text!,
                    position2: self.position2.text!,
                    position3: self.position3.text!,
                    squadNo: self.squadNo.text!,
                    apps: "0",
                    goals: "0",
                    assists: "0",
                    picURL: self.storedURL!,
                    password: self.genPassword.text!
                )
                
                
                let fullname = "\(self.firstName.text!) \(self.lastName.text!)"
                let newUser = User(userID: user!.uid, name: fullname, email: self.emailAdd.text!, phone: self.phoneNo.text!, password: self.genPassword.text!, club: self.clubID!, imgURL: self.storedURL!)
                var ref: FIRDatabaseReference!
                ref = FIRDatabase.database().reference()
                let clubRef = ref.child(self.clubID!)
                let playersRef = clubRef.child("players")
                playersRef.child(user!.uid).setValue(player.toAny())
                let usersRef = ref.child("users")
                usersRef.child(user!.uid).setValue(newUser.toAny())
                print("user created!")
                self.resetValidation()
                self.resetProfile()
                
                self.createButtonClicked = true
                let addSuccessAlertView = SCLAlertView()
                addSuccessAlertView.showSuccess("Congrats!", subTitle: "Player has successfully been added.")
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
                
                } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                if second_auth?.currentUser != nil {
                    do {
                        try second_auth?.signOut()
                        self.present(alertController, animated: true, completion: nil)
                        print("new user created + siged out")
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                //self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        
        let errorValAlertView = SCLAlertView()
        errorValAlertView.showWarning("Validation error", subTitle: "You have missed out/have entered some fields incorrectly.")
        
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
        }
        
    }
    
    func formValidation() {
        // Validation Rules
        validator.registerField(firstName, rules: [RequiredRule()])
        validator.registerField(lastName, rules: [RequiredRule()])
        validator.registerField(dob, rules: [RequiredRule()])
        validator.registerField(phoneNo, rules: [RequiredRule(), MinLengthRule(length: 11), MaxLengthRule(length: 11)])
        validator.registerField(emailAdd, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        validator.registerField(emailConfirm, rules: [ConfirmationRule(confirmField: emailAdd)])
        validator.registerField(address1, rules: [RequiredRule()])
        validator.registerField(address2, rules: [RequiredRule()])
        validator.registerField(city, rules: [RequiredRule()])
        validator.registerField(postCode, rules: [RequiredRule()])
        validator.registerField(position, rules: [RequiredRule()])
        validator.registerField(squad, rules: [RequiredRule()])
        validator.registerField(squadNo, rules: [RequiredRule()])
    }
    
    
    func formDelegation () {
        picker.delegate = self
        picker.dataSource = self
        picker2.delegate = self
        picker2.dataSource = self
        picker3.delegate = self
        picker3.dataSource = self
        sNoPicker.delegate = self
        sNoPicker.dataSource = self
        
        self.position.inputView = picker
        self.position2.inputView = picker2
        self.position3.inputView = picker3
        self.squadNo.inputView = sNoPicker
        
        firstName.delegate = self
        lastName.delegate = self
        dob.delegate = self
        phoneNo.delegate = self
        emailAdd.delegate = self
        address1.delegate = self
        address2.delegate = self
        city.delegate = self
        postCode.delegate = self
        position.delegate = self
        position2.delegate = self
        position3.delegate = self
        squadNo.delegate = self
        
        imagePicker.delegate = self

    }
    
   func resetProfile () {
        let newRandomPw = String.random()
        firstName.text = ""
        lastName.text! = ""
        dob.text! = ""
        phoneNo.text! = ""
        emailAdd.text! = ""
        emailConfirm.text! = ""
        address1.text! = ""
        address2.text! = ""
        city.text! = ""
        postCode.text! = ""
        position.text! = ""
        position2.text! = ""
        position3.text! = ""
        squad.text! = ""
        squadNo.text! = ""
        profilePic.image = UIImage(named: "profile.jpg")
        picker.reloadAllComponents()
        picker2.reloadAllComponents()
        picker3.reloadAllComponents()
        sNoPicker.reloadAllComponents()
    _ = createButtonClicked == false
        self.position.inputView = picker
        self.position2.inputView = picker2
        self.position3.inputView = picker3
        self.squadNo.inputView = sNoPicker
        genPassword.text = newRandomPw
        self.tableView.reloadData()
    }
    
    func resetValidation () {
        
        firstName.layer.borderWidth = 0
        lastName.layer.borderWidth = 0
        dob.layer.borderWidth = 0
        phoneNo.layer.borderWidth = 0
        emailAdd.layer.borderWidth = 0
        emailConfirm.layer.borderWidth = 0
        address1.layer.borderWidth = 0
        address2.layer.borderWidth = 0
        city.layer.borderWidth = 0
        postCode.layer.borderWidth = 0
        position.layer.borderWidth = 0
        squadNo.layer.borderWidth = 0
        squadNo.layer.borderWidth = 0
        
        validator.unregisterField(firstName)
        validator.unregisterField(lastName)
        validator.unregisterField(dob)
        validator.unregisterField(phoneNo)
        validator.unregisterField(emailAdd)
        validator.unregisterField(emailConfirm)
        validator.unregisterField(address1)
        validator.unregisterField(address2)
        validator.unregisterField(city)
        validator.unregisterField(postCode)
        validator.unregisterField(position)
        validator.unregisterField(squad)
        validator.unregisterField(squadNo)
        formValidation()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        createButtonClicked = false
    }
    
    func circlePicture () {
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        self.profilePic.layer.borderColor = UIColor.green.cgColor
        self.profilePic.layer.borderWidth = 2
        self.profilePic.layer.shouldRasterize = true
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dob.text = dateFormatter.string(from: sender.date)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        switch textField
        {
        case firstName:
            lastName.becomeFirstResponder()
            break
        case lastName:
            dob.becomeFirstResponder()
            break
        case dob:
            phoneNo.becomeFirstResponder()
            break
        case phoneNo:
            emailAdd.becomeFirstResponder()
            break
        case emailAdd:
            emailConfirm.becomeFirstResponder()
            break
        case emailConfirm:
            address1.becomeFirstResponder()
            break
        case address1:
            address2.becomeFirstResponder()
            break
        case address2:
            city.becomeFirstResponder()
            break
        case city:
            postCode.becomeFirstResponder()
            break
        case postCode:
            position.becomeFirstResponder()
            break
        case position:
            position2.becomeFirstResponder()
            break
        case position2:
            position3.becomeFirstResponder()
            break
        case position3:
            squad.becomeFirstResponder()
            break
        case squad:
            squadNo.becomeFirstResponder()
            break
        case squadNo:
            squadNo.resignFirstResponder()
        case genPassword:
            genPassword.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    // returns the number of 'columns' to display.
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == picker {
            return 1
        } else if pickerView == picker2 {
            return 1
        } else if pickerView == picker3 {
            return 1
        } else {
            return 1
        }
    }
    
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == picker {
            return positionData.count
        } else if pickerView == picker2 {
            return positionData.count
        } else if pickerView == picker3  {
            return positionData.count
        } else {
            return squadNoData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == picker {
            position.text = positionData[row]
        } else if pickerView == picker2 {
            position2.text = positionData[row]
        } else if pickerView == picker3 {
            position3.text = positionData[row]
        } else {
            squadNo.text = squadNoData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == picker {
            return positionData[row]
        } else if pickerView == picker2 {
            return positionData[row]
        } else if pickerView == picker3 {
            return positionData[row]
        } else {
            return squadNoData[row]
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension String {
    
    static func random(length: Int = 10) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
