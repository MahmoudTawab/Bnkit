//
//  CompanyInfo.swift
//  Bnkit
//
//  Created by Emojiios on 06/06/2022.
//  Copyright © 2022 Mahmoud Tawab. All rights reserved.
//

import Foundation

class CompanyInfo {

    var facebook : String?
    var phone : String?
    var website : String?
    var ArAgreement : String?
    var EnAgreement : String?
    var lat : String?
    var long : String?
    var Adders : String?
    
    init(json:[String:Any]) {
    facebook = json["faceBookPage"] as? String
    phone = json["phone"] as? String
    website = json["website"] as? String
    ArAgreement = json["arAgreement"] as? String
    EnAgreement = json["enAgreement"] as? String
    lat = json["lat"] as? String
    long = json["long"] as? String
    Adders = json["adders"] as? String
    }
}
