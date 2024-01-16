//
//  PersonalDetailsVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/15/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class PersonalDetailsVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
        
    var headerHeightConstraint: NSLayoutConstraint!
    var titleTopConstraint: NSLayoutConstraint!
    let maxHeaderHeight: CGFloat = ControlHeight(130)
    let minHeaderHeight: CGFloat = ControlHeight(60)
    var previousScrollOffset: CGFloat = 0
    var previousScrollViewHeight: CGFloat = 0
    var personal = [Personal]()
    let CellOne = "CellOne"
    var Value = [Any]()
    var Id = Int()
    
    override func viewDidLoad() {
       super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    lodProductDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    headerHeightConstraint.constant = maxHeaderHeight
    updateHeader()
    }

    
    func IfDataNull() {
    view.addSubview(NullData)
    NullData.frame = CGRect(x: 0, y: ControlY(130), width: view.frame.width, height: view.frame.height - ControlHeight(200))
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
    }
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.estimatedRowHeight = 80
        tv.rowHeight = UITableView.automaticDimension
        tv.backgroundColor = BackgroundColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(AboutCell.self, forCellReuseIdentifier: CellOne)
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return tv
    }()
    
    func SetUpItems() {

    previousScrollViewHeight = tableView.contentSize.height

    view.addSubview(ViewTop)
    headerHeightConstraint =  ViewTop.heightAnchor.constraint(equalToConstant: ControlHeight(130))
    headerHeightConstraint?.isActive = true
    ViewTop.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    ViewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    ViewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    ViewTop.addSubview(TopBackView)
    TopBackView.bottomAnchor.constraint(equalTo: ViewTop.bottomAnchor).isActive = true
    TopBackView.leadingAnchor.constraint(equalTo: ViewTop.leadingAnchor, constant: ControlX(6)).isActive = true
    TopBackView.trailingAnchor.constraint(equalTo: ViewTop.trailingAnchor, constant: ControlX(-20)).isActive = true
    TopBackView.heightAnchor.constraint(equalToConstant: ControlHeight(80)).isActive = true
            
    ViewTop.addSubview(TopButton)
    titleTopConstraint = TopButton.topAnchor.constraint(equalTo: ViewTop.topAnchor, constant: ControlY(15))
    titleTopConstraint?.isActive = true
    TopButton.leadingAnchor.constraint(equalTo: ViewTop.leadingAnchor, constant: ControlX(6)).isActive = true
    TopButton.trailingAnchor.constraint(equalTo: ViewTop.trailingAnchor, constant: ControlX(-6)).isActive = true
    TopButton.heightAnchor.constraint(equalToConstant: ControlHeight(50)).isActive = true
        
    view.addSubview(tableView)
    tableView.topAnchor.constraint(equalTo: ViewTop.bottomAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    lazy var ViewTop: UIView = {
        let View = UIView()
        View.backgroundColor = BackgroundColor
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()

    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = LabelForeground
        View.Space = ControlHeight(2)
        View.FontSize = ControlWidth(28)
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    
    lazy var TopButton : UIButton = {
        let Button = UIButton()
        Button.contentEdgeInsets = UIEdgeInsets(top: ControlY(45), left: 0, bottom: 0, right: 0)
        Button.setTitleColor(LabelForeground, for: .normal)
        Button.titleLabel?.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(20))
        Button.backgroundColor = .clear
        Button.contentVerticalAlignment = .center
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.addTarget(self, action: #selector(ScrollTop), for: .touchUpInside)
        return Button
    }()
    
    @objc func ScrollTop() {
    expandHeader()
    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        defer {
        self.previousScrollViewHeight = scrollView.contentSize.height
        self.previousScrollOffset = scrollView.contentOffset.y
        }

        let heightDiff = scrollView.contentSize.height - self.previousScrollViewHeight
        let scrollDiff = (scrollView.contentOffset.y - self.previousScrollOffset)
        guard heightDiff == 0 else { return }

        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;

        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom

        if canAnimateHeader(scrollView) {
        var newHeight = self.headerHeightConstraint.constant
        if isScrollingDown {
        newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
        newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
        }
        if newHeight != self.headerHeightConstraint.constant {
        self.headerHeightConstraint.constant = newHeight
        self.updateHeader()
        self.setScrollPosition(self.previousScrollOffset)
        }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }

    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)

        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }

    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }

    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }

    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }

    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }

    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        self.titleTopConstraint.constant = -openAmount - ControlHeight(10)
        self.TopBackView.alpha = percentage
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Value.count / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellOne, for: indexPath) as! AboutCell
        let Personal = personal[indexPath.row]
        setValues(cell, Personal, indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func SetUpButton() {
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: ControlHeight(90)))
    let Button = UIButton(type: .system)
    Button.setTitle("ADDREQUEST".localizable, for: .normal)
    Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
    Button.layer.cornerRadius = ControlHeight(20)
    Button.translatesAutoresizingMaskIntoConstraints = false
    Button.titleLabel?.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(14))
    Button.addTarget(self, action: #selector(didRequest), for: .touchUpInside)

    customView.addSubview(Button)
    Button.topAnchor.constraint(equalTo: customView.topAnchor, constant: ControlY(25)).isActive = true
    Button.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: ControlY(-25)).isActive = true
    Button.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
    Button.widthAnchor.constraint(equalToConstant: ControlHeight(157)).isActive = true
    Button.heightAnchor.constraint(equalToConstant: ControlHeight(40)).isActive = true

    tableView.tableFooterView = customView
    }
    
    @objc func didRequest() {
    if GetUserObject().uid != nil {
    let AddRequest = AddRequestPersonal()
    AddRequest.IdAdd = Id
    AddRequest.reqId = 0
    AddRequest.isUpdate = false
    PresentByNavigation(ViewController: self, ToViewController: AddRequest)
    }else{
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = false
    PopUp.text = "ErrorLogIn".localizable
    PopUp.OkeyButton.addTarget(self, action: #selector(GoToLogin), for: .touchUpInside)
    Present(ViewController: self, ToViewController: PopUp)
    }
    }
    
    @objc func GoToLogin() {
    PresentByNavigation(ViewController: self, ToViewController: LogInController())
    }

    func setValues(_ cell: AboutCell ,_ personal: Personal ,_ indexPath:IndexPath) {
        
        cell.TheTitle.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(18))
        cell.TheDetails.font = UIFont(name: "Campton-Light" ,size: ControlWidth(17))
        cell.StackVertical.arrangedSubviews[0].heightAnchor.constraint(equalToConstant: ControlHeight(32)).isActive = true
        
        let PersonalShow = personal.ShowPersonal
        switch indexPath.row {
        case 0:
        if let Rat = personal.rat {
        cell.TheDetails.isHidden = false
        cell.TheTitle.text = "Rating".localizable
        cell.TheDetails.text = "lang".localizable == "en" ? "\(Rat)" : "\(Rat)".NumAR()
        }
        case 1:
        if let Day = personal.expectedDay {
        cell.TheDetails.isHidden = false
        cell.TheTitle.text = "ExpectedDay".localizable
        cell.TheDetails.text = "lang".localizable == "en" ? "\(Day)" : "\(Day)".NumAR()
        }
        case 2:
        if let Max = personal.loanMax {
        cell.TheDetails.isHidden = false
        cell.TheTitle.text = "LoanMax".localizable
        cell.TheDetails.text = "lang".localizable == "en" ? "\(Max)" : "\(Max)".NumAR()
        }
        case 3:
        if let Min = personal.loanMin {
        cell.TheDetails.isHidden = false
        cell.TheTitle.text = "LoanMin".localizable
        cell.TheDetails.text = "lang".localizable == "en" ? "\(Min)" : "\(Min)".NumAR()
        }
        case 4:
        if let EnProvider = personal.enProvider , let ArProvider = personal.arProvider  {
        cell.TheDetails.isHidden = !PersonalShow
        cell.TheTitle.text = "Provider".localizable
        cell.TheDetails.text = "lang".localizable == "en" ? EnProvider : ArProvider
        }
        case 5:
        if let EnAbout = personal.enAbout , let ArAbout = personal.arAbout  {
        cell.TheDetails.isHidden = !PersonalShow
        cell.TheTitle.text = "About".localizable
        cell.TheDetails.text = "lang".localizable == "en" ? EnAbout : ArAbout
        }
        case 6:
        if let EnRequiredDoc = personal.enRequiredDoc , let ArRequiredDoc = personal.arRequiredDoc  {
        cell.TheDetails.isHidden = !PersonalShow
        cell.TheTitle.text = "Required".localizable
        cell.TheDetails.text = "lang".localizable == "en" ? EnRequiredDoc : ArRequiredDoc
        }
        case 7:
        if let EnAgreement = personal.enAgreement , let ArAgreement = personal.arAgreement {
        cell.TheDetails.isHidden = !PersonalShow
        cell.TheTitle.text = "Agreement".localizable
        cell.TheDetails.text = "lang".localizable == "en" ? EnAgreement : ArAgreement
        }
        default:break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let Personal = personal[indexPath.row]
    let ShowPersonal = personal[indexPath.row].ShowPersonal
    Personal.ShowPersonal = !ShowPersonal
    tableView.reloadRows(at: [indexPath], with: .automatic)
    if !personal[4].ShowPersonal && !personal[5].ShowPersonal && !personal[6].ShowPersonal && !personal[7].ShowPersonal {
    ScrollTop()
    }
    }
    

    
    let PopUp = PopUpView()
    func SetUpPopUp(text:String) {
    PopUp.text = text
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUp)
    }
    

    lazy var NullData : ViewNullData = {
        let View = ViewNullData()
        View.backgroundColor = .clear
        View.TryAgain.addTarget(self, action: #selector(lodProductDetail), for: .touchUpInside)
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
extension PersonalDetailsVC {
    
    
    @objc func lodProductDetail() {
    self.Alert.SetIndicator(Style: .load)
    if !Reachability.isConnectedToNetwork() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
    self.Alert.SetIndicator(Style: .Hidden)
    self.SetUpPopUp(text: "InternetNotAvailable".localizable)
    self.IfDataNull()
    })
    }else{
    guard let url = defaults.string(forKey: "API") else{return}
    let ProductDetail = "\(url + PhoneProductDetail)"

    let parameters = ["id": "0\(Id)"]
        
    AlamofireCall(Url: ProductDetail, HTTP: .get, parameters: parameters, Success: {}, Array: {_ in}) { (json) in
    if json.count == 0 {
    self.IfDataNull()
    return
    }
    for (_ ,value) in json {
    self.personal.append(Personal(json: json))
    self.Value.append(value)
    }
    DispatchQueue.main.async {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    self.SetUpButton()
    }
    self.tableView.reloadData()
    self.tableView.animateTable()
    self.Alert.SetIndicator(Style: .Hidden)
    self.NullData.removeFromSuperview()
    }
    } Err: { (err) in
    self.Alert.SetIndicator(Style: .error)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
    self.SetUpPopUp(text: err)
    self.IfDataNull()
    })
    }
    }
    }
    
}
