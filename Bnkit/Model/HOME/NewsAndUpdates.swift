//
//  NewsAndUpdates.swift
//  NewsAndUpdates
//
//  Created by Emoji Technology on 17/10/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import Foundation

class NewsAndUpdates {

    let newsId: Int?
    let isNews: Bool?
    let offColor: String?
    let fontColor: String?
    let mediaUrl: String?
    let isVedio: Bool?
    let detailMediaUrl: String?
    let arTitle: String?
    let enTitle: String?
    let arDetail: String?
    let enDetail: String?
    let showCount: Int?
    let lastShow: String?
    let endIn: String?
    let sta: Bool?
    let createdIn: String?
    let createdBy: Int?
    let updateIn: String?
    let updatedBy: Int?
    let youtubeCode: String?
  
    init(json:[String:Any]) {
      
        newsId = json["newsId"] as? Int
        isNews = json["isNews"] as? Bool
        offColor = json["offColor"] as? String
        fontColor = json["fontColor"] as? String
        mediaUrl = json["mediaUrl"] as? String
        isVedio = json["isVedio"] as? Bool
        detailMediaUrl = json["detailMediaUrl"] as? String
        arTitle = json["arTitle"] as? String
        enTitle = json["enTitle"] as? String
        arDetail = json["arDetail"] as? String
        enDetail = json["enDetail"] as? String
        showCount = json["showCount"] as? Int
        
        lastShow = json["lastShow"] as? String
        
        endIn = json["endIn"] as? String
        sta = json["sta"] as? Bool
        createdIn = json["createdIn"] as? String
        createdBy = json["createdBy"] as? Int
        updateIn = json["updateIn"] as? String
        updatedBy = json["updatedBy"] as? Int
        youtubeCode = json["youtubeCode"] as? String
        
    }
    
}
