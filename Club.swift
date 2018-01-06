//
//  Club.swift
//  PFCM
//
//  Created by Thomas Anderson on 12/04/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import Foundation
import Firebase

struct Club {
    
    let clubID: String
    let clubName: String
    let clubEmail: String
    let clubContact: String
    
    let clubHomeGround: String
    let clubAddress1: String
    let clubAddress2: String
    let clubCity: String
    let clubPostcode: String
    let clubLeague: String
    
    
    let ref: FIRDatabaseReference?
    
    
    init (clubID: String, clubName: String, clubEmail: String, clubContact: String) {
        
        self.clubID = clubID
        self.clubName = clubName
        self.clubEmail = clubEmail
        self.clubContact = clubContact
        
        self.clubHomeGround = "TBC"
        self.clubAddress1 = "TBC"
        self.clubAddress2 = "TBC"
        self.clubCity = "TBC"
        self.clubPostcode = "TBC"
        
        self.clubLeague = "TBC"
        
        
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        clubID = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        
        clubName = snapshotValue["clubName"] as! String
        clubEmail = snapshotValue["clubEmail"] as! String
        clubContact = snapshotValue["clubContact"] as! String
        
        clubHomeGround = snapshotValue["clubHomeGround"] as! String
        clubAddress1 = snapshotValue["clubAddress1"] as! String
        clubAddress2 = snapshotValue["clubAddress2"] as! String
        clubCity = snapshotValue["clubCity"] as! String
        clubPostcode = snapshotValue["clubPostcode"] as! String
        
        clubLeague = snapshotValue["clubLeague"] as! String
        
        ref = snapshot.ref
        
    }
    
    func toAny() -> Any {
        return [
            "clubName": clubName,
            "clubEmail": clubEmail,
            "clubContact": clubContact,
            "clubHomeGround": clubHomeGround,
            "clubAddress1": clubAddress1,
            "clubAddress2": clubAddress2,
            "clubCity": clubCity,
            "clubPostcode": clubPostcode,
            "clubLeague": clubLeague
        ]
    }
}
