//
//  PopUpRequestView.swift
//  Bnkit
//
//  Created by Emoji Technology on 20/11/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class PopUpRequestView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var Request:RequestHistoryVC?
    var History : History? {
    didSet {
    RequestView.reloadData()
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                
        view.addSubview(RequestView)
        RequestView.frame = CGRect(x: ControlX(20), y: ControlY(50), width: view.frame.width - ControlX(40), height: view.frame.height - ControlY(130))
        view.addSubview(CancelButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
        let height = (self.RequestView.contentSize.height + ControlHeight(25)) < (self.view.frame.height - ControlWidth(200)) ? (self.RequestView.contentSize.height + ControlHeight(25)) : (self.view.frame.height - ControlWidth(200))
            self.RequestView.frame = CGRect(x: ControlX(20), y: self.view.center.y - (height / 1.9), width: self.view.frame.width - ControlX(40), height: height)
            
        self.CancelButton.frame = CGRect(x: self.view.center.x - ControlWidth(31), y: self.RequestView.frame.maxY + ControlY(15), width: ControlWidth(62), height: ControlWidth(62))
        self.CancelButton.layer.cornerRadius = self.CancelButton.frame.height / 2
        self.RequestViewAnimate()
        self.RequestView.layoutIfNeeded()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    UIView.animate(withDuration: 0.5, animations: {
    self.RequestView.transform = CGAffineTransform(scaleX: 0.03, y: 0.3)
    }) { (End) in
    self.RequestView.transform = .identity
    }
    }
    
    func RequestViewAnimate() {
        RequestView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
        self.RequestView.transform = .identity
        })
    }
    
    let RequestId = "RequestId"
    lazy var RequestView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorColor = .clear
        tv.backgroundColor = TextViewForeground
        tv.layer.cornerRadius = ControlHeight(26)
        tv.rowHeight = UITableView.automaticDimension
        tv.register(PopUpRequestCell.self, forCellReuseIdentifier: RequestId)
        tv.contentInset = UIEdgeInsets(top: ControlX(10), left: 0, bottom: ControlX(10), right: 0)
        return tv
    }()


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RequestId, for: indexPath) as! PopUpRequestCell
        cell.selectionStyle = .none
        if let history = History {

        ///
        cell.RequestName.text = "lang".localizable == "en" ? history.Info?.requestNameEn : history.Info?.requestNameAr
            
        ///
        let Id = "lang".localizable == "en" ? "\(history.Info?.requestId ?? 0)" : "\(history.Info?.requestId ?? 0)".NumAR()
        cell.RequestId.rightLabel.text = Id
        cell.RequestId.leftLabel.text = "REQUESTID".localizable
         
        ///
        let Status = "lang".localizable == "en" ? history.Info?.requestStatusEn : history.Info?.requestStatusAr
        cell.RequestStatus.rightLabel.text = Status
        cell.RequestStatus.leftLabel.text = "REQUESTSTATUS".localizable
         
        ///
        let date = Formatter(date: history.Info?.dateOfRequest ?? "", Format: "dd/MM/yyyy hh:mm")
        cell.ResponseTime.rightLabel.text = date
        cell.ResponseTime.leftLabel.text = "RESPONSETIME".localizable
        
        ///
        if let note = history.Info?.note {
        cell.NotesTV.text = note
        cell.NotesTV.isHidden = false
        }
            
        ///
        if let Brief = history.RequestInfo?.brief {
            cell.Brief.isHidden = false
            cell.Brief.rightLabel.text = Brief
            cell.Brief.leftLabel.text = "BRIEF".localizable
        }else{
            cell.Brief.isHidden = true
        }
            
        ///
        if let MonthlyIncome = history.RequestInfo?.monthlyIncome {
            cell.MonthlyIncome.isHidden = false
            cell.MonthlyIncome.rightLabel.text = "\(MonthlyIncome)"
            cell.MonthlyIncome.leftLabel.text = "MONTHLYINCOME".localizable
        }else{
            cell.MonthlyIncome.isHidden = true
        }
            
        ///
        if let ServiceType = history.RequestInfo?.serviceType {
            cell.ServiceType.isHidden = false
            let Service = ServiceType == true ? "Legal".localizable : "Financial".localizable
            cell.ServiceType.rightLabel.text = Service
            cell.ServiceType.leftLabel.text = "SERVICETYPE".localizable
        }else{
            cell.ServiceType.isHidden = true
        }
            
        ///
        if let StartUp = history.RequestInfo?.startUp {
            cell.StartUp.isHidden = false
            let start = StartUp == true ? "Yes".localizable : "No".localizable
            cell.StartUp.rightLabel.text = start
            cell.StartUp.leftLabel.text = "STARTUP".localizable
        }else{
            cell.StartUp.isHidden = true
        }
            
        ///
        if let lengthOfBusiness = history.RequestInfo?.lengthOfBusiness {
            cell.lengthOfBusiness.isHidden = false
            cell.lengthOfBusiness.rightLabel.text = lengthOfBusiness
            cell.lengthOfBusiness.leftLabel.text = "LENGTHOFBUSINESS".localizable
        }else{
            cell.lengthOfBusiness.isHidden = true
        }
            
        ///
        if let comments = history.RequestInfo?.comments {
            cell.comments.isHidden = false
            cell.comments.rightLabel.text = comments
            cell.comments.leftLabel.text = "COMMENTS".localizable
        }else{
            cell.comments.isHidden = true
        }
        
        ///
        if let employmentTypeEn = history.RequestInfo?.employmentTypeEn , let employmentTypeAr = history.RequestInfo?.employmentTypeAr {
            cell.employmentType.isHidden = false
            cell.employmentType.leftLabel.text = "EMPLOYMENTTYPE".localizable
            cell.employmentType.rightLabel.text = "lang".localizable == "en" ? employmentTypeEn : employmentTypeAr
        }else{
            cell.employmentType.isHidden = true
        }
            
        ///
        if let preferredCompanyEn = history.RequestInfo?.preferredCompanyEn , let preferredCompanyAr = history.RequestInfo?.preferredCompanyAr {
            cell.preferredCompany.isHidden = false
            cell.preferredCompany.leftLabel.text = "PREFERREDCOMPANY".localizable
            cell.preferredCompany.rightLabel.text = "lang".localizable == "en" ? preferredCompanyEn : preferredCompanyAr
        }else{
            cell.preferredCompany.isHidden = true
        }
            
        ///
        if let mobadraTypeEn = history.RequestInfo?.mobadraTypeEn , let mobadraTypeAr = history.RequestInfo?.mobadraTypeAr {
            cell.mobadraType.isHidden = false
            cell.mobadraType.leftLabel.text = "MOBADRATYPE".localizable
            cell.mobadraType.rightLabel.text = "lang".localizable == "en" ? mobadraTypeEn : mobadraTypeAr
        }else{
            cell.mobadraType.isHidden = true
        }
            
        ///
        if let coverageAmount = history.RequestInfo?.coverageAmount {
            cell.coverageAmount.isHidden = false
            cell.coverageAmount.rightLabel.text = "\(coverageAmount)"
            cell.coverageAmount.leftLabel.text = "COVERAGEAMOUNT".localizable
        }else{
            cell.coverageAmount.isHidden = true
        }
            
        ///
        if let Corporate = history.RequestInfo?.corporate {
            cell.corporate.isHidden = false
            let corporate = Corporate == true ? "Yes".localizable : "No".localizable
            cell.corporate.rightLabel.text = corporate
            cell.corporate.leftLabel.text = "CORPORATE".localizable
        }else{
            cell.corporate.isHidden = true
        }
            
        ///
        if let interestedIn = history.RequestInfo?.interestedIn {
            cell.interestedIn.isHidden = false
            cell.interestedIn.rightLabel.text = interestedIn
            cell.interestedIn.leftLabel.text = "INTERESTEDIN".localizable
        }else{
            cell.interestedIn.isHidden = true
        }
            
        ///
        if let partnership = history.RequestInfo?.partnership {
            cell.partnership.isHidden = false
            cell.partnership.rightLabel.text = partnership
            cell.partnership.leftLabel.text = "PARTNERSHIP".localizable
        }else{
            cell.partnership.isHidden = true
        }
            
        ///
        if let investmentBudget = history.RequestInfo?.investmentBudget {
            cell.investmentBudget.isHidden = false
            cell.investmentBudget.rightLabel.text = "\(investmentBudget)"
            cell.investmentBudget.leftLabel.text = "INVESTMENTBUDGET".localizable
        }else{
            cell.investmentBudget.isHidden = true
        }
            
        ///
        if let requestedAmount = history.RequestInfo?.requestedAmount {
            cell.requestedAmount.isHidden = false
            cell.requestedAmount.rightLabel.text = "\(requestedAmount)"
            cell.requestedAmount.leftLabel.text = "REQUESTEDAMOUNT".localizable
        }else{
            cell.requestedAmount.isHidden = true
        }
            
        ///
        if let islamic = history.RequestInfo?.islamic {
            cell.islamic.isHidden = false
            let lamic = islamic == true ? "Yes".localizable : "No".localizable
            cell.islamic.rightLabel.text = lamic
            cell.islamic.leftLabel.text = "ISLAMIC".localizable
        }else{
            cell.islamic.isHidden = true
        }
            
        ///
        if let investmentAmount = history.RequestInfo?.investmentAmount {
            cell.investmentAmount.isHidden = false
            cell.investmentAmount.rightLabel.text = "\(investmentAmount)"
            cell.investmentAmount.leftLabel.text = "INVESTMENTAMOUNT".localizable
        }else{
            cell.investmentAmount.isHidden = true
        }
            
        ///
        if let email = history.RequestInfo?.email {
            cell.email.isHidden = false
            cell.email.rightLabel.text = email
            cell.email.leftLabel.text = "E-MAIL".localizable
        }else{
            cell.email.isHidden = true
        }
                
        ///
        if let fullName = history.RequestInfo?.fullName {
            cell.fullName.isHidden = false
            cell.fullName.rightLabel.text = fullName
            cell.fullName.leftLabel.text = "MOBILENO".localizable
        }else{
            cell.fullName.isHidden = true
        }
            
        ///
        if let mobileNo = history.RequestInfo?.mobileNo {
            cell.mobileNo.isHidden = false
            cell.mobileNo.rightLabel.text = mobileNo
            cell.mobileNo.leftLabel.text = "FULLNAME".localizable
        }else{
            cell.mobileNo.isHidden = true
        }
                
        ///
        if let productInterested = history.RequestInfo?.productInterested {
            cell.productInterested.isHidden = false
            cell.productInterested.rightLabel.text = productInterested
            cell.productInterested.leftLabel.text = "PRODUCTINTERESTED".localizable
        }else{
            cell.productInterested.isHidden = true
        }
            
        }
        return cell
    }
    
    lazy var CancelButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.tintColor = .white
        Button.setImage(UIImage(named: "group269"), for: .normal)
        Button.addTarget(self, action: #selector(Dismiss), for: .touchUpInside)
        return Button
    }()

    @objc func Dismiss() {
    dismiss(animated: true)
    }
}
