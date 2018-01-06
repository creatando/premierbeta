//
//  Tactic.swift
//  PFCM
//
//  Created by Thomas Anderson on 21/03/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import Foundation
import Firebase

struct Tactic {
    let tacticName: String
    let date: String
    let tid: String
    let aURL: String
    
    let gkCoord_x: Double
    let gkCoord_y: Double
    
    let p2Coord_x: Double
    let p2Coord_y: Double
    
    let p3Coord_x: Double
    let p3Coord_y: Double
    
    let p4Coord_x: Double
    let p4Coord_y: Double
    
    let p5Coord_x: Double
    let p5Coord_y: Double
    
    let p6Coord_x: Double
    let p6Coord_y: Double
    
    let p7Coord_x: Double
    let p7Coord_y: Double
    
    let p8Coord_x: Double
    let p8Coord_y: Double
    
    let p9Coord_x: Double
    let p9Coord_y: Double
    
    let p10Coord_x: Double
    let p10Coord_y: Double
    
    let p11Coord_x: Double
    let p11Coord_y: Double
    
    let ref: FIRDatabaseReference?
    
    init(tid: String, tacticName: String, gkCoord_x: Double, gkCoord_y: Double, p2Coord_x: Double, p2Coord_y: Double, p3Coord_x: Double, p3Coord_y: Double, p4Coord_x: Double, p4Coord_y: Double, p5Coord_x: Double, p5Coord_y: Double, p6Coord_x: Double, p6Coord_y: Double, p7Coord_x: Double, p7Coord_y: Double, p8Coord_x: Double, p8Coord_y: Double, p9Coord_x: Double, p9Coord_y: Double, p10Coord_x: Double, p10Coord_y: Double, p11Coord_x: Double, p11Coord_y: Double, aURL: String) {
        
        self.tid = tid
        self.tacticName = tacticName
        self.date = Date().toString()
        
        self.gkCoord_x = gkCoord_x
        self.gkCoord_y = gkCoord_y
        
        self.p2Coord_x = p2Coord_x
        self.p2Coord_y = p2Coord_y
        
        self.p3Coord_x = p3Coord_x
        self.p3Coord_y = p3Coord_y
        
        self.p4Coord_x = p4Coord_x
        self.p4Coord_y = p4Coord_y
        
        self.p5Coord_x = p5Coord_x
        self.p5Coord_y = p5Coord_y
        
        self.p6Coord_x = p6Coord_x
        self.p6Coord_y = p6Coord_y
        
        self.p7Coord_x = p7Coord_x
        self.p7Coord_y = p7Coord_y
        
        self.p8Coord_x = p8Coord_x
        self.p8Coord_y = p8Coord_y
        
        self.p9Coord_x = p9Coord_x
        self.p9Coord_y = p9Coord_y
        
        self.p10Coord_x = p10Coord_x
        self.p10Coord_y = p10Coord_y
        
        self.p11Coord_x = p11Coord_x
        self.p11Coord_y = p11Coord_y
        
        self.aURL = aURL
        
        self.ref = nil
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        tid = snapshot.key
        
        let snapshotValue = snapshot.value as! [String: Any]
        
        tacticName = snapshotValue["tacticName"] as! String
        date = snapshotValue["date"] as! String
        
        gkCoord_x = snapshotValue["gkCoord_x"] as! Double
        gkCoord_y = snapshotValue["gkCoord_y"] as! Double
        
        p2Coord_x = snapshotValue["p2Coord_x"] as! Double
        p2Coord_y = snapshotValue["p2Coord_y"] as! Double
        
        p3Coord_x = snapshotValue["p3Coord_x"] as! Double
        p3Coord_y = snapshotValue["p3Coord_y"] as! Double
        
        p4Coord_x = snapshotValue["p4Coord_x"] as! Double
        p4Coord_y = snapshotValue["p4Coord_y"] as! Double
        
        p5Coord_x = snapshotValue["p5Coord_x"] as! Double
        p5Coord_y = snapshotValue["p5Coord_y"] as! Double
        
        p6Coord_x = snapshotValue["p6Coord_x"] as! Double
        p6Coord_y = snapshotValue["p6Coord_y"] as! Double
        
        p7Coord_x = snapshotValue["p7Coord_x"] as! Double
        p7Coord_y = snapshotValue["p7Coord_y"] as! Double
        
        p8Coord_x = snapshotValue["p8Coord_x"] as! Double
        p8Coord_y = snapshotValue["p8Coord_y"] as! Double
        
        p9Coord_x = snapshotValue["p9Coord_x"] as! Double
        p9Coord_y = snapshotValue["p9Coord_y"] as! Double
        
        p10Coord_x = snapshotValue["p10Coord_x"] as! Double
        p10Coord_y = snapshotValue["p10Coord_y"] as! Double
        
        p11Coord_x = snapshotValue["p11Coord_x"] as! Double
        p11Coord_y = snapshotValue["p11Coord_y"] as! Double
        
        aURL = snapshotValue["aURL"] as! String
        
        ref = snapshot.ref
    }
    
    func toAny() -> Any {
        return [
            
            "tacticName": tacticName,
            "date": date,
            
            "gkCoord_x": gkCoord_x,
            "gkCoord_y": gkCoord_y,
            
            "p2Coord_x": p2Coord_x,
            "p2Coord_y": p2Coord_y,
            
            "p3Coord_x": p3Coord_x,
            "p3Coord_y": p3Coord_y,
            
            "p4Coord_x": p4Coord_x,
            "p4Coord_y": p4Coord_y,
            
            "p5Coord_x": p5Coord_x,
            "p5Coord_y": p5Coord_y,
            
            "p6Coord_x": p6Coord_x,
            "p6Coord_y": p6Coord_y,
            
            "p7Coord_x": p7Coord_x,
            "p7Coord_y": p7Coord_y,
            
            "p8Coord_x": p8Coord_x,
            "p8Coord_y": p8Coord_y,
            
            "p9Coord_x": p9Coord_x,
            "p9Coord_y": p9Coord_y,
            
            "p10Coord_x": p10Coord_x,
            "p10Coord_y": p10Coord_y,
            
            "p11Coord_x": p11Coord_x,
            "p11Coord_y": p11Coord_y,
            
            "aURL": aURL
        ]
    }
    
    
    
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self as Date)
    }
}
