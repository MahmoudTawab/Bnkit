//
//  User.swift
//  Bnkit
//
//  Created by Emojiios on 08/06/2022.
//  Copyright © 2022 Mahmoud Tawab. All rights reserved.
//

import Foundation

class User {

    var clientId : Int?
    var uid : String?
    var sysToken : String?
    var firsName : String?
    var lastName : String?
    var phone : String?
    var email : String?
    var personalId : String?
    var frontIdPpath : String?
    var backIdPath : String?
    var photoPath : String?
    var birth : String?
    var lang : String?
    var sta : Bool?
    var salary : String?
    var utility : String?
    var bankStatement : String?
    var hrletter : String?

    init(json:[String:Any]) {
        clientId = json["clientId"] as? Int
        uid = json["uid"] as? String
        sysToken = json["sysToken"] as? String
        firsName = json["firsName"] as? String
        lastName = json["lastName"] as? String
        phone = json["phone"] as? String
        email = json["email"] as? String
        personalId = json["personalId"] as? String
        frontIdPpath = json["frontIdPpath"] as? String
        backIdPath = json["backIdPath"] as? String
        photoPath = json["photoPath"] as? String
        birth = json["birth"] as? String
        lang = json["lang"] as? String
        sta = json["sta"] as? Bool
        salary = json["salary"] as? String
        utility = json["utility"] as? String
        bankStatement = json["bankStatement"] as? String
        hrletter = json["hrletter"] as? String
    }
}
        
func GetUserObject() -> User {
let UserData = User(json: [String:Any]())
if let data = defaults.object(forKey: "User") as? Data {
if let decodedPeople = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any] {
let user = User(json: decodedPeople)
return user
}
}
return UserData
}
