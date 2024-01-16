//
//  Personal.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/15/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
 
class Personal {
    
  var proTypeId: Int?
  var arProName:String?
  var enProName: String?
  var rat: CGFloat?
  var photoPath: String?
  var arAbout: String?
  var enAbout: String?
  var arRequiredDoc: String?
  var enRequiredDoc: String?
  var arProvider: String?
  var enProvider: String?
  var arAgreement: String?
  var enAgreement: String?
  var expectedDay: Int?
  var loanMax: Int?
  var loanMin: Int?
    
  var ShowPersonal = true
    
  init(json:[String:Any]) {
  proTypeId = json["proTypeId"] as? Int
  arProName = json["arProName"] as? String
  enProName = json["enProName"] as? String
        
  rat = json["rat"] as? CGFloat
  photoPath = json["photoPath"] as? String
  arAbout = json["arAbout"] as? String
  enAbout = json["enAbout"] as? String
  arRequiredDoc = json["arRequiredDoc"] as? String
        
  enRequiredDoc = json["enRequiredDoc"] as? String
  arProvider = json["arProvider"] as? String
  enProvider = json["enProvider"] as? String
  arAgreement = json["arAgreement"] as? String
  enAgreement = json["enAgreement"] as? String
    
  expectedDay = json["expectedDay"] as? Int
  loanMax = json["loanMax"] as? Int
  loanMin = json["loanMin"] as? Int
  }
}
