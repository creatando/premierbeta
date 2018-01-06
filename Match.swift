//
//  Match.swift
//  PFCM
//
//  Created by Thomas Anderson on 12/04/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import Foundation
import Firebase

struct Match {
    
    let matchID: String
    let home: String
    let away: String
    let venue: String
    let referee: String
    let kickoff: String
    
    let ref: FIRDatabaseReference?
    
    
    init (matchID: String, home: String, away: String, venue: String, referee: String, kickoff: String) {
        
        self.matchID = matchID
        self.home = home
        self.away = away
        self.venue = venue
        self.referee = referee
        self.kickoff = kickoff
        
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        matchID = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        
        home = snapshotValue["home"] as! String
        away = snapshotValue["away"] as! String
        venue = snapshotValue["venue"] as! String
        referee = snapshotValue["referee"] as! String
        kickoff = snapshotValue["kickoff"] as! String
        
        ref = snapshot.ref
        
    }
    
    func toAny() -> Any {
        return [
            "home": home,
            "away": away,
            "venue": venue,
            "referee": referee,
            "kickoff": kickoff
        ]
    }
}
