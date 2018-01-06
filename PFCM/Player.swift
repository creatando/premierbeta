//
//  Player.swift
//  PFCM
//
//  Created by Thomas Anderson on 08/02/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import Foundation
import Firebase

struct Player {
    let pid: String
    let firstName: String
    let lastName: String
    let dob: String
    let phoneNo: String
    let emailAdd: String
    let address1: String
    let address2: String
    let city: String
    let postCode: String
    let position: String
    let position2: String
    let position3: String
    let squadNo: String
    let apps: String
    let goals: String
    let assists: String
    let picURL: String
    let password: String
    let club: String
    let squad: String
    
    let ref: FIRDatabaseReference?
    
    
    init (pid: String, club: String, squad: String, firstName: String, lastName: String, dob: String, phoneNo: String, emailAdd: String, address1: String, address2: String, city: String, postCode: String, position: String, position2: String, position3: String, squadNo: String, apps: String, goals: String, assists: String, picURL: String, password: String) {
        
        self.pid = pid
        self.club = club
        self.squad = squad
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
        self.phoneNo = phoneNo
        self.emailAdd = emailAdd
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.postCode = postCode
        self.position = position
        self.position2 = position2
        self.position3 = position3
        self.squadNo = squadNo
        self.apps = apps
        self.goals = goals
        self.assists = assists
        self.picURL = picURL
        self.password = password
        
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        pid = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        
        club = snapshotValue["club"] as! String
        squad = snapshotValue["squad"] as! String
        firstName = snapshotValue["firstName"] as! String
        lastName = snapshotValue["lastName"] as! String
        dob = snapshotValue["dob"] as! String
        phoneNo = snapshotValue["phoneNo"] as! String
        emailAdd = snapshotValue["emailAdd"] as! String
        address1 = snapshotValue["address1"] as! String
        address2 = snapshotValue["address2"] as! String
        city = snapshotValue["city"] as! String
        postCode = snapshotValue["postCode"] as! String
        position = snapshotValue["position"] as! String
        position2 = snapshotValue["position2"] as! String
        position3 = snapshotValue["position3"] as! String
        squadNo = snapshotValue["squadNo"] as! String
        apps = snapshotValue["apps"] as! String
        goals = snapshotValue["goals"] as! String
        assists = snapshotValue["assists"] as! String
        picURL = snapshotValue["picURL"] as! String
        password = snapshotValue["password"] as! String
        
        ref = snapshot.ref
        
    }
    
    func toAny() -> Any {
        return [
            "club": club,
            "squad": squad,
            "firstName": firstName,
            "lastName": lastName,
            "dob": dob,
            "phoneNo": phoneNo,
            "emailAdd": emailAdd,
            "address1": address1,
            "address2": address2,
            "city": city,
            "postCode": postCode,
            "position": position,
            "position2": position2,
            "position3": position3,
            "squadNo": squadNo,
            "apps": apps,
            "goals": goals,
            "assists": assists,
            "picURL": picURL,
            "password": password
        ]
    }
}
