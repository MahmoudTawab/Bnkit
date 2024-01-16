//
//  SignUpError.swift
//  Bnkit
//
//  Created by Emojiios on 06/06/2022.
//  Copyright © 2022 Mahmoud Tawab. All rights reserved.
//

import Foundation

class SignUpError {

    var emailUsed : Bool?
    var phoneValid : Bool?
    var phoneUsed : Bool?
    var verification : Int?
    
    init(json:[String:Any]) {
    emailUsed = json["emailUsed"] as? Bool
    phoneValid = json["phoneValid"] as? Bool
    phoneUsed = json["phoneUsed"] as? Bool
    verification = json["verification"] as? Int
    }
}
