//
//  RequestHistoryVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import SwipeCellKit

class RequestHistoryVC: UIViewController , UITableViewDelegate , UITableViewDataSource ,SwipeTableViewCellDelegate {

    var Id = Int()
    let cellId = "cellId"
    var request = [Request]()
    var indexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpTableView()
    lodRequest()

    view.addSubview(NullData)
    NullData.frame = view.bounds
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
    Alert.backgroundColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Alert.isShow {
        Alert.Indicator.startAnimating()
        }
    }
    
    func SetUpTableView() {
        
    view.addSubview(HistoryLabel)
    HistoryLabel.frame = CGRect(x: ControlX(25), y: ControlY(35), width: view.frame.width - ControlWidth(50), height: ControlHeight(35))

    view.addSubview(tableView)
    tableView.frame = CGRect(x: 0, y: HistoryLabel.frame.maxY + ControlY(10), width: view.frame.width , height: view.frame.height - ControlHeight(80))

    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = LabelForeground
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.refreshControl = refreshControl
    }
    
    lazy var HistoryLabel : UILabel = {
    let Label = UILabel()
    Label.backgroundColor = .clear
    Label.textColor = LabelForeground
    Label.text = "REQUESTHISTORY".localizable
    Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(25))
    return Label
    }()
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = BackgroundColor
        tv.alwaysBounceVertical = false
        tv.separatorStyle = .none
        tv.rowHeight = ControlHeight(126)
        tv.contentInset = UIEdgeInsets(top: ControlHeight(10), left: 0, bottom: ControlHeight(10), right: 0)
        tv.register(RequestHistoryCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    
    
    @objc func refresh() {
    lodRequest(ShowProgress: false)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return request.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RequestHistoryCell
        let Request = request[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = .none
        setupCell(cell: cell, Request: Request)
        return cell
    }
    
    private func setupCell(cell:RequestHistoryCell ,Request:Request) {
        
    let date = Formatter(date: Request.dateOfRequest ?? "", Format: "dd/MM/yy")
    cell.DateRequesLabel.text = "lang".localizable == "en" ? "Date of Request :    \(date)" : "تاريخ الطلب :    \(date)"
    cell.RequestNameLabel.text = "lang".localizable == "en" ? Request.requestNameEn : Request.requestNameAr
        
    if let enSta = Request.requestStatusEn , let arSta = Request.requestStatusAr {
    cell.RequestStatusLabel.text = "lang".localizable == "en" ? "Request Status :     \(enSta)" : "حالة الطلب :    \(arSta)"
    }
        
    cell.NoteLabel.text = "\("NOTE".localizable). \(Request.note ?? "")"
    cell.RequestNameLabel.font = UIFont(name: "Campton-Medium" ,size: ControlWidth(15))
    cell.DateRequesLabel.font = UIFont(name: "Campton-Light" ,size: ControlWidth(10))
    cell.RequestStatusLabel.font = UIFont(name: "Campton-Light" ,size: ControlWidth(10))
    cell.NoteLabel.font = UIFont(name: "Campton-Light" ,size: ControlWidth(10))
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if "lang".localizable == "en" {
        guard orientation == .right else { return nil }
        }else{
        guard orientation == .left else { return nil }
        }

        let delete = SwipeAction(style: .destructive, title: "Delete".localizable) { action, indexPath in

        let Request = self.request[indexPath.row]
        if let relId = Request.requestId {
        self.Id = relId
        self.indexPath = indexPath
        }
        self.SetUpPopUpByDelete()
        }

        delete.hidesWhenSelected = true
        delete.image = UIImage(named: "group269")
        delete.backgroundColor = BackgroundColor
        delete.textColor = #colorLiteral(red: 1, green: 0.6832912404, blue: 0.6953821782, alpha: 1)
        
        let edit = SwipeAction(style: .destructive, title: "Edit".localizable) { action, indexPath in
        let Request = self.request[indexPath.row]
        if Request.canUpdate == true {
            
        switch Request.requestTypeId {
        case 1:
            
        if let reqId = Request.requestId  {
        let AddRequest = AddRequestPersonal()
        AddRequest.reqId = reqId
        
        if Request.details?.uplodedFileUrl != "" {
        AddRequest.FileURL = Request.details?.uplodedFileUrl
        AddRequest.UploadFiles.IsUpload(true, 0.5)
        }
                
        if Request.details?.uploedImageUrl != "" {
        AddRequest.uploedImageUrl = Request.details?.uploedImageUrl
        AddRequest.UploadImage.IsUpload(true, 0.5)
        }
            
        AddRequest.isUpdate = true
        AddRequest.Emp = Request.details?.empTypeId ?? 0
        AddRequest.Provider = Request.details?.provId ?? 0
        AddRequest.MonthlyIncomeTF.text = "\(Request.details?.monthlyIncome ?? 0)"
        AddRequest.CoverageAmountTF.text = "\(Request.details?.amount ?? 0)"
        AddRequest.CorporateView.YesButton.isOn = Request.details?.corporate ?? false
        AddRequest.CorporateView.NoButton.isOn = !(Request.details?.corporate ?? false)
        AddRequest.ProductsInterested.text = Request.details?.productInterested
        AddRequest.LengthOfBusiness.text = Request.details?.lengthOfBusiness
        AddRequest.CommentsTF.text = Request.details?.comments
        
        PresentByNavigation(ViewController: self, ToViewController: AddRequest)
        }
            
            
        case 3:
        if let reqId = Request.requestId  {
        let RequestSme = AddRequestSme()
        RequestSme.reqId = reqId
            
        if Request.details?.uplodedFileUrl != "" {
        RequestSme.FileURL = Request.details?.uplodedFileUrl
        RequestSme.UploadFiles.IsUpload(true, 0.5)
        }

        RequestSme.isUpdate = true
        RequestSme.IdAdd = Request.details?.proId ?? 0
        RequestSme.Provider = Request.details?.provId ?? 0 
        RequestSme.MonthlyIncomeTF.text = "\(Request.details?.monthlyIncome ?? 0)"
        RequestSme.RequestedAmount.text = "\(Request.details?.amount ?? 0)"
        RequestSme.StartUpView.YesButton.isOn = Request.details?.startUp ?? false
        RequestSme.StartUpView.NoButton.isOn = !(Request.details?.startUp ?? false)
        RequestSme.IslamicView.YesButton.isOn = Request.details?.islamic ?? false
        RequestSme.IslamicView.NoButton.isOn = !(Request.details?.islamic ?? false)
        RequestSme.LengthOfBusiness.text = Request.details?.lengthOfBusiness
        RequestSme.CommentsTF.text = Request.details?.comments
        PresentByNavigation(ViewController: self, ToViewController: RequestSme)
        }
            
        case 4:
        if let reqId = Request.requestId  {
        let Pos = PosVC()
            
        Pos.reqId = reqId
        Pos.isUpdate = true
        Pos.isValidNumber = true
        Pos.EmailTF.text = Request.details?.email
        Pos.FullNameTF.text = Request.details?.fullName
        Pos.MobileTF.text = Request.details?.mobileNo
        Pos.CommentsTF.text = Request.details?.comments
        Pos.ProductInterestedTF.text = Request.details?.productInterested
        Pos.LengthOfBusinessTF.text = Request.details?.lengthOfBusiness
        PresentByNavigation(ViewController: self, ToViewController: Pos)
        }
            
        case 5:
        if let reqId = Request.requestId  {
        let IScore = IScoreVC()
            
        IScore.reqId = reqId
        IScore.isUpdate = true
        IScore.isValidNumber = true
        IScore.EmailTF.text = Request.details?.email
        IScore.FullNameTF.text = Request.details?.fullName
        IScore.MobileTF.text = Request.details?.mobileNo
        IScore.CommentsTF.text = Request.details?.comments
        IScore.LengthOfBusinessTF.text = Request.details?.lengthOfBusiness
        PresentByNavigation(ViewController: self, ToViewController: IScore)
        }
            
        case 2,6:
            
        if let reqId = Request.requestId , let requestTypeId = Request.requestTypeId {
        let Investor = InvestorVC()
        Investor.reqId = reqId
        if Request.details?.uplodedFileUrl != "" {
        Investor.FileURL = Request.details?.uplodedFileUrl
        Investor.UploadFiles.IsUpload(true, 0.5)
        }
            
        Investor.isUpdate = true
        Investor.SectorTypId = requestTypeId
        Investor.IdAdd = Request.details?.proId ?? 0
        Investor.ProjectBrief.text = Request.details?.projectBrief
        Investor.Partnership.text = Request.details?.partnership
        Investor.InvestmentBudget.text = "\(Request.details?.investmentBudget ?? 0)"
        Investor.InvestmentInterestedIn.text = Request.details?.investmentInterestedIn
        Investor.StartUpView.YesButton.isOn = Request.details?.startUp ?? false
        Investor.StartUpView.NoButton.isOn = !(Request.details?.startUp ?? false)
        Investor.LengthOfBusiness.text = Request.details?.lengthOfBusiness
        Investor.CommentsTF.text = Request.details?.comments
        Investor.TopBackView.text = "lang".localizable == "en" ? Request.requestNameEn ?? "back".localizable : Request.requestNameAr ?? "back".localizable
        PresentByNavigation(ViewController: self, ToViewController: Investor)
        }
            
        case 7:
        if let reqId = Request.requestId  {
        let PartnershipApplicant = PartnershipApplicantVC()
        PartnershipApplicant.reqId = reqId
            
        if Request.details?.uplodedFileUrl != "" {
        PartnershipApplicant.FileURL = Request.details?.uplodedFileUrl
        PartnershipApplicant.UploadFiles.IsUpload(true, 0.5)
        }

        PartnershipApplicant.isUpdate = true
        PartnershipApplicant.ProjectBrief.text = Request.details?.projectBrief
        PartnershipApplicant.MonthlyIncome.text = "\(Request.details?.monthlyIncome ?? 0)"
        PartnershipApplicant.InvestmentAmount.text = "\(Request.details?.amount ?? 0)"
        PartnershipApplicant.StartUpView.YesButton.isOn = Request.details?.startUp ?? false
        PartnershipApplicant.StartUpView.NoButton.isOn = !(Request.details?.startUp ?? false)
        PartnershipApplicant.LengthOfBusiness.text = Request.details?.lengthOfBusiness
        PartnershipApplicant.CommentsTF.text = Request.details?.comments
        PresentByNavigation(ViewController: self, ToViewController: PartnershipApplicant)
        }
            
        case 8:
        if let reqId = Request.requestId  {
        let AcquisitionApplicant = AcquisitionApplicantVC()
        AcquisitionApplicant.reqId = reqId
            
        if Request.details?.uplodedFileUrl != "" {
        AcquisitionApplicant.FileURL = Request.details?.uplodedFileUrl
        AcquisitionApplicant.UploadFiles.IsUpload(true, 0.5)
        }

        AcquisitionApplicant.isUpdate = true
        AcquisitionApplicant.ProjectBrief.text = Request.details?.projectBrief
        AcquisitionApplicant.MonthlyIncome.text = "\(Request.details?.monthlyIncome ?? 0)"
        AcquisitionApplicant.InvestmentAmount.text = "\(Request.details?.amount ?? 0)"
        AcquisitionApplicant.StartUpView.YesButton.isOn = Request.details?.startUp ?? false
        AcquisitionApplicant.StartUpView.NoButton.isOn = !(Request.details?.startUp ?? false)
        AcquisitionApplicant.LengthOfBusiness.text = Request.details?.lengthOfBusiness
        AcquisitionApplicant.CommentsTF.text = Request.details?.comments
        PresentByNavigation(ViewController: self, ToViewController: AcquisitionApplicant)
        }
            
        case 9:
        if let reqId = Request.requestId  {
        let Legal = LegalVC()
        Legal.reqId = reqId
            
        if Request.details?.uplodedFileUrl != "" {
        Legal.FileURL = Request.details?.uplodedFileUrl
        Legal.UploadFiles.IsUpload(true, 0.5)
        }

        Legal.isUpdate = true
        Legal.ProjectBrief.text = Request.details?.projectBrief
        Legal.MonthlyIncome.text = "\(Request.details?.monthlyIncome ?? 0)"
        Legal.ServiceTypeView.YesButton.isOn = Request.details?.serviceType ?? false
        Legal.ServiceTypeView.NoButton.isOn = !(Request.details?.serviceType ?? false)
        Legal.LengthOfBusiness.text = Request.details?.lengthOfBusiness
        Legal.CommentsTF.text = Request.details?.comments
        PresentByNavigation(ViewController: self, ToViewController: Legal)
        }
            
        case 10:
        if let reqId = Request.requestId  {
        let Mobadra = MobadraVC()
        
        Mobadra.reqId = reqId
        Mobadra.isUpdate = true
        Mobadra.Emp = Request.details?.empTypeId ?? 0
        Mobadra.Mobadra = Request.details?.mobadraTypeID ?? 0
        Mobadra.MonthlyIncomeTF.text = "\(Request.details?.monthlyIncome ?? 0)"
        Mobadra.RequestedAmountTF.text = "\(Request.details?.amount ?? 0)"
        Mobadra.IslamicView.YesButton.isOn = Request.details?.islamic ?? false
        Mobadra.IslamicView.NoButton.isOn = !(Request.details?.islamic ?? false)
        Mobadra.OtherProductsInterestedTF.text = Request.details?.productInterested
        Mobadra.LengthOfBusiness.text = Request.details?.lengthOfBusiness
        Mobadra.CommentsTF.text = Request.details?.comments
        PresentByNavigation(ViewController: self, ToViewController: Mobadra)
        }
            
        default:
        break
        }

        }else{
        self.SetUpPopUp(text: "This request cannot be modified".localizable)
        }
        }

        edit.image = UIImage(named: "edit")
        edit.backgroundColor = BackgroundColor
        edit.textColor = #colorLiteral(red: 1, green: 0.6832912404, blue: 0.6953821782, alpha: 1)
        return [edit,delete]
    }
    
    var defaultOptions = SwipeOptions()
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        if "lang".localizable == "en" {
        options.expansionStyle = orientation == .right ? .selection : .destructive
        }else{
        options.expansionStyle = orientation == .left ? .selection : .destructive
        }
        options.transitionStyle = defaultOptions.transitionStyle
        options.backgroundColor = BackgroundColor
        return options
    }
    
    func SetUpPopUp(text:String) {
    PopUpDelete.text = text
    PopUpDelete.font = ControlWidth(16)
    PopUpDelete.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUpDelete)
    }
    
    let PopUpDelete = PopUpView()
    func SetUpPopUpByDelete() {
    if let TopFont:UIFont = UIFont(name: "Campton-SemiBold", size: ControlWidth(15)) , let bottomFont:UIFont = UIFont(name: "Campton-Light", size: ControlWidth(12)) {
    let postsAttributedText = NSMutableAttributedString(string: "DELETEREQUEST".localizable, attributes: [NSAttributedString.Key.font: TopFont])
    postsAttributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: ControlWidth(14))]))
    postsAttributedText.append(NSAttributedString(string: "MassageRequest".localizable, attributes: [NSAttributedString.Key.font: bottomFont]))
            
    PopUpDelete.font = ControlWidth(8)
    PopUpDelete.TextView.attributedText = postsAttributedText
    PopUpDelete.TextView.textAlignment = .center
    PopUpDelete.TextView.textColor = LabelForeground
        
    PopUpDelete.OkeyButton.isHidden = false
    PopUpDelete.OkeyButton.addTarget(self, action: #selector(DeleteRequest), for: .touchUpInside)
    Present(ViewController: self, ToViewController: PopUpDelete)
    }
    }

    let PopUp = PopUpRequestView()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.Alert.SetIndicator(Style: .load)
    let Request = request[indexPath.row]
    if let reqId = Request.requestId {
    lodHistory(id: String(reqId))
    }
    }
    
    
    func IfDataNull() {
    if self.request.count == 0 {
    tableView.isHidden = true
    NullData.isHidden = false
    }else{
    tableView.isHidden = false
    NullData.isHidden = true
    }
    }
    
    lazy var NullData : ViewNullData = {
      let View = ViewNullData(frame: view.bounds)
      View.isHidden = true
      View.backgroundColor = .clear
      View.TryAgain.addTarget(self, action: #selector(lodRequest), for: .touchUpInside)
      return View
    }()

    lazy var Alert:AlertView = {
        let View = AlertView()
        View.alpha = 0
        View.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return View
    }()
}


///----------------------------------------------
/// MARK: GET DATA BY API
///----------------------------------------------
extension RequestHistoryVC {
    
    @objc func lodRequest(ShowProgress:Bool = true) {
    if !Reachability.isConnectedToNetwork() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
    self.Alert.SetIndicator(Style: .Hidden)
    self.SetUpPopUp(text: "InternetNotAvailable".localizable)
    self.IfDataNull()
    })
    }else{
    guard let url = defaults.string(forKey: "API") else{return}
    let RequestDetail = "\(url + PhoneAllRequests)"
            
    guard let uid = GetUserObject().uid else{return}
    guard let sysToken = GetUserObject().sysToken else{return}

    if ShowProgress {self.Alert.SetIndicator(Style: .load)}
    let parameters = ["uid": uid,"sysToken": sysToken]
    AlamofireCall(Url: RequestDetail, HTTP: .get, parameters: parameters ,Success: {
    self.IfDataNull()
    self.Alert.SetIndicator(Style: .Hidden)
    }) { (jsons) in
    self.request.removeAll()
                
    for json in jsons {
    self.request.append(Request(json:json))
    self.tableView.reloadData()
    }
        
    self.IfDataNull()
    self.tableView.animateTable()
    self.Alert.SetIndicator(Style: .Hidden)
    self.tableView.refreshControl?.endRefreshing()
    } Err: { err in
    self.Alert.SetIndicator(Style: .error)
    self.tableView.refreshControl?.endRefreshing()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
    self.SetUpPopUp(text: err)
    self.IfDataNull()
    })
    }
    }
    }
    
    
    @objc func DeleteRequest() {
    self.Alert.SetIndicator(Style: .load)
     guard let url = defaults.string(forKey: "API") else{return}
    let Delete = "\(url + PhoneDeleteRequest)"

    guard let uid = GetUserObject().uid else{return}
    guard let sysToken = GetUserObject().sysToken else{return}
        
    let parameters = ["uid": uid,"sysToken": sysToken,"Id": "\(Id)"]
    AlamofireCall(Url: Delete, HTTP: .delete, parameters: parameters) {
    self.tableView.beginUpdates()
    self.request.remove(at: self.indexPath.item)
    self.tableView.deleteRows(at: [self.indexPath], with: .right)
    self.tableView.endUpdates()
    self.IfDataNull()
    self.Alert.SetIndicator(Style: .success)
    } Err: { err in
    self.Alert.SetIndicator(Style: .error)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    self.PopUpDelete.text = err
    self.SetUpPopUp(text: err)
    }
    }
    }
    
    
    func lodHistory(id:String) {
    guard let url = defaults.string(forKey: "API") else{return}
    let RequestDetail = "\(url + PhoneRequestDetail)"
                
    guard let uid = GetUserObject().uid else{return}
    guard let sysToken = GetUserObject().sysToken else{return}
            
    let parameters = ["uid": uid,"sysToken": sysToken,"id": id]
    AlamofireCall(Url: RequestDetail, HTTP: .get, parameters: parameters, Success: {}, Array: {_ in }) { (json) in
    self.PopUp.History = History(json: json)
    self.PopUp.Request = self
    self.Alert.SetIndicator(Style: .Hidden)
    Present(ViewController: self, ToViewController: self.PopUp)
    } Err: { _ in
    self.Alert.SetIndicator(Style: .error)
    }
    }
    
}
