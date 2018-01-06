//
//  AdminUser.swift
//  PFCM
//
//  Created by Thomas Anderson on 12/04/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import Foundation
import Firebase

struct AdminUser {
    
    let userID: String
    let name: String
    let email: String
    let phone: String
    let password: String
    let club: String
    let isAdmin: String
    let imgURL: String
    let ref: FIRDatabaseReference?
    
    
    init (userID: String, name: String, email: String, phone: String, password: String, club: String, imgURL: String) {
        
        self.userID = userID
        self.name = name
        self.email = email
        self.phone = phone
        self.password = password
        self.club = club
        self.isAdmin = "true"
        self.imgURL = imgURL
        
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        userID = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        
        name = snapshotValue["name"] as! String
        email = snapshotValue["email"] as! String
        phone = snapshotValue["phone"] as! String
        password = snapshotValue["password"] as! String
        club = snapshotValue["club"] as! String
        isAdmin = snapshotValue["isAdmin"] as! String
        imgURL = snapshotValue["imgURL"] as! String
        
        ref = snapshot.ref
        
    }
    
    func toAny() -> Any {
        return [
            "name": name,
            "email": email,
            "phone": phone,
            "password": password,
            "club": club,
            "isAdmin": isAdmin,
            "imgURL": imgURL,
        ]
    }
}
