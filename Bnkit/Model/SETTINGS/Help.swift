//
//  Help.swift
//  Bnkit
//
//  Created by Mohamed Tawab on 05/02/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import Foundation

class Help {
    
    var recId:Int?
    var arQuestion:String?
    var enQuestion:String?
    var arAnswer:String?
    var enAnswer:String?
    var youtubeCode:String?
    var requestCount:Int?
    var sta: Bool?
    var createdIn:String?
    var createdBy:Int?
    var updateIn: String?
    var updatedBy:Int?
    
    var HelpShow = false
    
    init(json:[String:Any]) {
        recId = json["recId"] as? Int
        arQuestion = json["arQuestion"] as? String
        enQuestion = json["enQuestion"] as? String
        arAnswer = json["arAnswer"] as? String
        enAnswer = json["enAnswer"] as? String
        youtubeCode = json["youtubeCode"] as? String
        requestCount = json["requestCount"] as? Int
        sta = json["sta"] as? Bool
        createdIn = json["createdIn"] as? String
        createdBy = json["createdBy"] as? Int
        updateIn = json["updateIn"] as? String
        updatedBy = json["updatedBy"] as? Int
    }
}

