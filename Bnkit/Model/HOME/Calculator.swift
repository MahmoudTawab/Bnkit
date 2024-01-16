//
//  Calculator.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 4/19/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import Foundation

class Calculator {

    var numberofPayments:Int?
    var monthlyPayment:Double?
    var loanAmount:Double?
    var totalCostOfLoan: Double?
    var totalInterest: Double?
    var details: [[String:Any]]?
    
    init(json:[String:Any]) {
    numberofPayments = json["numberofPayments"] as? Int
    monthlyPayment = json["monthlyPayment"] as? Double
    loanAmount = json["loanAmount"] as? Double
    totalCostOfLoan = json["totalCostOfLoan"] as? Double
    totalInterest = json["totalInterest"] as? Double
    details = json["details"] as? [[String:Any]]
    }
    
}
