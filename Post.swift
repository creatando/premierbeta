//
//  Post.swift
//  PFCM
//
//  Created by Thomas Anderson on 11/04/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    let postID: String
    let caption: String
    let imageURL: String
    let userID: String
    let likes: Int
    let timestamp: Any
    let reference: FIRDatabaseReference?
    
    
    init (postID: String, userID: String, caption: String, imageURL: String, likes: Int, timestamp: Any) {
        
        self.postID = postID
        self.userID = userID
        self.caption = caption
        self.imageURL = imageURL
        self.likes = likes
        self.timestamp = timestamp
        
        reference = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        postID = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        
        userID = snapshotValue["userID"] as! String
        caption = snapshotValue["caption"] as! String
        imageURL = snapshotValue["imageURL"] as! String
        likes = snapshotValue["likes"] as! Int
        timestamp = snapshotValue["timestamp"] as Any
        
        reference = snapshot.ref
        
    }
    
    func toAny() -> Any {
        return [
            "userID": userID,
            "caption": caption,
            "imageURL": imageURL,
            "likes": likes,
            "timestamp": timestamp
        ]
    }
}

