//
//  Notifications.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 2/10/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import Foundation

class Notifications {
        
  var relId:Int?
  var notId:Int?
  var readable:Bool?
  var arNotTitle: String?
  var enNotTitle: String?
  var arNotBody: String?
  var enNotBody: String?
  var createdIn: String?
  var iconPath: String?
      
  init(json:[String:Any]) {
  relId = json["relId"] as? Int
  readable = json["readable"] as? Bool
  notId = json["notId"] as? Int
  iconPath = json["iconPath"] as? String
  arNotTitle = json["arNotTitle"] as? String
  enNotTitle = json["enNotTitle"] as? String
  arNotBody = json["arNotBody"] as? String
  enNotBody = json["enNotBody"] as? String
  createdIn = json["createdIn"] as? String
  }
}
