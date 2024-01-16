//
//  About.swift
//  Expandable-TableViewCell-StackView
//
//  Created by Akash Malhotra on 7/8/16.
//  Copyright © 2016 Akash Malhotra. All rights reserved.
//

import Foundation

class About {
    let recId: Int?
    
    let arTitle: String?
    let arBody: String?
    
    let enTitle: String?
    let enBody: String?
    
    var AboutShow = false
    
    init(json:[String:Any]) {
        recId = json["recId"] as? Int
        arTitle = json["arTitle"] as? String
        arBody = json["arBody"] as? String
        
        enTitle = json["enTitle"] as? String
        enBody = json["enBody"] as? String
    }
}
