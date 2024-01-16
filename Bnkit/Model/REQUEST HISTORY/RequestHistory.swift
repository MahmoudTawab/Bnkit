//
//  RequestHistory.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 2/22/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Foundation

class Request {
    
    var requestId:Int?
    var requestTypeId:Int?
    var requestNameAr:String?
    var requestNameEn:String?
    var requestStatusAr:String?
    var requestStatusEn:String?
    var dateOfRequest:String?
    var note:String?
    var canUpdate:Bool?
    var details: RequestDetails?
      
    init(json:[String:Any]) {
    requestId = json["requestId"] as? Int
    requestTypeId = json["requestTypeId"] as? Int
    requestNameAr = json["requestNameAr"] as? String
    requestNameEn = json["requestNameEn"] as? String
    requestStatusAr = json["requestStatusAr"] as? String
    requestStatusEn = json["requestStatusEn"] as? String
    dateOfRequest = json["dateOfRequest"] as? String
    note = json["note"] as? String
    canUpdate = json["canUpdate"] as? Bool
        
    if let Details = json["details"] as? [String:Any] {
    details = RequestDetails(json: Details)
    }
    }
}


class RequestDetails {
    
    var proId:Int?
    var reqId:Int?
    var empTypeId:Int?
    var monthlyIncome:Int?
    var amount:Int?
    var provId:Int?
    var islamic:Bool?
    var comments:String?
    var productInterested:String?
    var proTypeId:Int?
    var email:String?
    var fullName:String?
    var mobileNo:String?
    var lengthOfBusiness:String?
    var projectBrief:String?
    var startUp:Bool?
    var partnership:String?
    var investmentInterestedIn:String?
    var serviceType:Bool?
    var preferredCompany:Int?
    var corporate:Bool?
    var prefBankCompany:String?
    var uplodedFileUrl:String?
    var uploedImageUrl:String?
    var mobadraTypeID:Int?
    var investmentBudget:Int?
    
    init(json:[String:Any]) {
        proId = json["proId"] as? Int
        reqId = json["reqId"] as? Int
        empTypeId = json["empTypeId"] as? Int
        monthlyIncome = json["monthlyIncome"] as? Int
        amount = json["amount"] as? Int
        provId = json["provId"] as? Int
        islamic = json["islamic"] as? Bool
        comments = json["comments"] as? String
        productInterested = json["productInterested"] as? String
        proTypeId = json["proTypeId"] as? Int
        email = json["email"] as? String
        fullName = json["fullName"] as? String
        mobileNo = json["mobileNo"] as? String
        lengthOfBusiness = json["lengthOfBusiness"] as? String
        projectBrief = json["projectBrief"] as? String
        startUp = json["startUp"] as? Bool
        partnership = json["partnership"] as? String
        investmentInterestedIn = json["investmentInterestedIn"] as? String
        serviceType = json["serviceType"] as? Bool
        preferredCompany = json["preferredCompany"] as? Int
        corporate = json["corporate"] as? Bool
        prefBankCompany = json["prefBankCompany"] as? String
        uplodedFileUrl = json["uplodedFileUrl"] as? String
        uploedImageUrl = json["uploedImageUrl"] as? String
        mobadraTypeID = json["mobadraTypeID"] as? Int
        investmentBudget = json["investmentBudget"] as? Int
    }
}

class History {
    
    var Info:basicInfo?
    var RequestInfo:InfoRequest?
    
    init(json:[String:Any]) {
    if let info = json["basicInfo"] as? [String:Any] {
    Info = basicInfo(json: info)
    }
     
    if let info = json["info"] as? [String:Any] {
    RequestInfo = InfoRequest(json: info)
    }
    }
}


class basicInfo {

    var requestId:Int?
    var requestNameEn: String?
    var requestNameAr: String?
    var requestStatusEn: String?
    var requestStatusAr: String?
    var dateOfRequest: String?
    var note: String?
    
    init(json:[String:Any]) {
        requestId = json["requestId"] as? Int
        requestNameEn = json["requestNameEn"] as? String
        requestNameAr = json["requestNameAr"] as? String
        requestStatusEn = json["requestStatusEn"] as? String
        requestStatusAr = json["requestStatusAr"] as? String
        dateOfRequest = json["dateOfRequest"] as? String
        note = json["note"] as? String
    }
}

class InfoRequest {
    
    var brief: String?
    var monthlyIncome:Int?
    var serviceType: Bool?
    var startUp: Bool?
    var lengthOfBusiness: String?
    var comments: String?
    
    var employmentTypeEn: String?
    var employmentTypeAr: String?
    
    var preferredCompanyEn: String?
    var preferredCompanyAr: String?
    
    var mobadraTypeEn: String?
    var mobadraTypeAr: String?
    
    var coverageAmount: Int?
    var corporate: Bool?
    var interestedIn: String?
    var partnership: String?
    var investmentBudget:Int?
    var requestedAmount:Int?
    var islamic: Bool?
    var investmentAmount: Int?
    var email: String?
    var fullName: String?
    var mobileNo: String?
    var productInterested: String?
    
    init(json:[String:Any]) {
        brief = json["brief"] as? String
        monthlyIncome = json["monthlyIncome"] as? Int
        
        serviceType = json["serviceType"] as? Bool
        startUp = json["startUp"] as? Bool
        
        lengthOfBusiness = json["lengthOfBusiness"] as? String
        comments = json["comments"] as? String
    
        employmentTypeEn = json["employmentTypeEn"] as? String
        employmentTypeAr = json["employmentTypeAr"] as? String
        
        preferredCompanyEn = json["preferredCompanyEn"] as? String
        preferredCompanyAr = json["preferredCompanyAr"] as? String
        
        mobadraTypeEn = json["mobadraTypeEn"] as? String
        mobadraTypeAr = json["mobadraTypeAr"] as? String
        
        coverageAmount = json["coverageAmount"] as? Int
        corporate = json["corporate"] as? Bool
        
        interestedIn = json["interestedIn"] as? String
        partnership = json["partnership"] as? String
        
        investmentBudget = json["investmentBudget"] as? Int
        requestedAmount = json["requestedAmount"] as? Int

        islamic = json["islamic"] as? Bool
        investmentAmount = json["investmentAmount"] as? Int
        
        email = json["email"] as? String
        fullName = json["fullName"] as? String

        mobileNo = json["mobileNo"] as? String
        productInterested = json["productInterested"] as? String
    }
}
