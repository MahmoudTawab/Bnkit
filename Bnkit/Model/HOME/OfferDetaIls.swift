//
//  OfferDetaIls.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 2/3/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class Offer {
    
    let arProName : String?
    let enProName : String?
    let proTypeId : Int?
    let offId : Int?
    let arProType : String?
    let enProType : String?
    let offColor : String?
    let fontColor : String?
    let photoPath : String?
    let arTitle : String?
    let enTitle : String?
    let arDetail : String?
    let enDetail : String?
    let detailPhotoPath : String?
    
    init(json:[String:Any]) {
    arProName = json["arProName"] as? String
    enProName = json["enProName"] as? String
    proTypeId = json["proTypeId"] as? Int
    offId = json["offId"] as? Int
    arProType = json["arProType"] as? String
    enProType = json["enProType"] as? String
    offColor = json["offColor"] as? String
    fontColor = json["fontColor"] as? String
    photoPath = json["photoPath"] as? String
    arTitle = json["arTitle"] as? String
    enTitle = json["enTitle"] as? String
    arDetail = json["arDetail"] as? String
    enDetail = json["enDetail"] as? String
    detailPhotoPath = json["detailPhotoPath"] as? String
    }
}
