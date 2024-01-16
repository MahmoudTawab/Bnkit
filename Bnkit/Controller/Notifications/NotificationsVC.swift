//
//  NotificationsVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import SwipeCellKit

class NotificationsVC: UIViewController , UITableViewDelegate , UITableViewDataSource ,SwipeTableViewCellDelegate {
    
    let cellId = "cellId"
    var skip = 0
    var Id = Int()
    var fetchingMore = false
    var IsReadable = [Bool]()
    var DataNotification = [Notifications]()
    var indexPath = IndexPath(item: 0, section: 0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUpTableView()
        lodData(animate: true)
        view.backgroundColor = BackgroundColor
        
        view.addSubview(NullData)
        NullData.frame = view.bounds
        
        view.addSubview(Alert)
        Alert.frame = view.bounds
        Alert.backgroundColor = .clear
        self.Alert.SetIndicator(Style: .load)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Alert.isShow {
        Alert.Indicator.startAnimating()
        }
    }
    
    fileprivate func SetUpTableView() {

    view.addSubview(NotificationsLabel)
    NotificationsLabel.frame = CGRect(x: ControlX(25), y: ControlY(35), width: view.frame.width - ControlWidth(150), height: ControlHeight(35))

    view.addSubview(tableView)
    tableView.frame = CGRect(x: 0, y: NotificationsLabel.frame.maxY + ControlY(10), width: view.frame.width , height: view.frame.height - ControlHeight(80))
        
    view.addSubview(ActivityIndicator)
    NSLayoutConstraint.activate([
    ActivityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: ControlX(-15)),
    ActivityIndicator.centerYAnchor.constraint(equalTo: NotificationsLabel.centerYAnchor),
    ActivityIndicator.heightAnchor.constraint(equalToConstant: ControlHeight(35)),
    ActivityIndicator.widthAnchor.constraint(equalTo: ActivityIndicator.heightAnchor)])
        
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = LabelForeground
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.refreshControl = refreshControl
    NotificationCenter.default.addObserver(self, selector: #selector(Post), name: AppDelegate.PostNotification , object: nil)
    }
    
    
    lazy var NotificationsLabel : UILabel = {
    let Label = UILabel()
    Label.backgroundColor = .clear
    Label.textColor = LabelForeground
    Label.text = "NOTIFICATIONS".localizable
    Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(25))
    return Label
    }()
    
    let ActivityIndicator:UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .white)
    aiv.hidesWhenStopped = true
    aiv.isHidden = true
    aiv.color = LabelForeground
    aiv.translatesAutoresizingMaskIntoConstraints = false
    return aiv
    }()
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = BackgroundColor
        tv.separatorStyle = .none
        tv.alwaysBounceVertical = false
        tv.rowHeight = ControlHeight(60)
        tv.register(NotificationsCell.self, forCellReuseIdentifier: cellId)
        tv.contentInset = UIEdgeInsets(top: ControlHeight(10), left: 0, bottom: ControlHeight(10), right: 0)
        return tv
    }()
    
    @objc func Post() {
    lodData(animate: false)
    }
        
    @objc func refresh() {
    skip = 0
    lodData(animate: true, removeAll: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !fetchingMore && tableView.isDragging {
        tableView.addLoading(indexPath) {
        self.ActivityIndicator.startAnimating()
        self.lodData(animate: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.ActivityIndicator.stopAnimating()
        }
        }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NotificationsCell
    let Notification = DataNotification[indexPath.row]
        
    cell.delegate = self
    cell.selectionStyle = .none
            
    if indexPath.row == 0 {
    cell.ViewTopLine.alpha = 1
    }else{
    cell.ViewTopLine.alpha = 0
    }
    setupCell(cell: cell, Notification: Notification)
    return cell
    }
    
    func setupCell(cell:NotificationsCell ,Notification:Notifications) {
    if let TopFont:UIFont = UIFont(name: "Campton-Medium", size: ControlWidth(15)) , let bottomFont:UIFont = UIFont(name: "Campton-Light", size: ControlWidth(10)) {
    if let Title = "lang".localizable == "en" ? Notification.enNotTitle : Notification.arNotTitle , let readable = Notification.readable {
    let postsAttributedText = NSMutableAttributedString(string: "\(Title)\n", attributes: [NSAttributedString.Key.font: TopFont])
    let Text = readable ? "MessageRead".localizable : "NewMessage".localizable
    postsAttributedText.append(NSAttributedString(string: Text, attributes: [NSAttributedString.Key.font: bottomFont]))
    cell.NotificationsView.isHidden = readable
    cell.TitleLabel.textColor = !readable ? NotifNew:NotifReadable
    cell.TitleLabel.attributedText = postsAttributedText
    }
    }
        
    if let Time = Notification.createdIn {
    let time = Formatter(date: Time, Format: "hh:mm a\nyy/MM/dd")
    cell.DetaLabel.text = time
    cell.DetaLabel.font = UIFont(name: "Campton-Light", size: ControlWidth(10))
    }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    if "lang".localizable == "en" {
    guard orientation == .right else { return nil }
    }else{
    guard orientation == .left else { return nil }
    }

    let deleteAction = SwipeAction(style: .destructive, title: "Delete".localizable) { action, indexPath in
    let Notification = self.DataNotification[indexPath.row]
    if let relId = Notification.relId {
    self.Id = relId
    self.indexPath = indexPath
    }
    self.SetUpPopUpByDelete()
    }

    deleteAction.image = UIImage(named: "group269")
    deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.6832912404, blue: 0.6953821782, alpha: 1)
    return [deleteAction]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let Notification = DataNotification[indexPath.row]
    if let enNotBody = Notification.enNotBody , let arNotBody = Notification.arNotBody , let relId = Notification.relId {
    let text = "lang".localizable == "en" ? enNotBody : arNotBody
        
    if Notification.readable == false {
    UpdateShowNotifi(relId: relId)
    }
        
    Notification.readable = true
    tableView.reloadData()
    SetUpPopUp(text:text)
    }
    }
    
    func SetUpPopUp(text:String) {
    PopUp.text = text
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUp)
    }
    

    
    let PopUp = PopUpView()
    func SetUpPopUpByDelete() {
    if let TopFont:UIFont = UIFont(name: "Campton-SemiBold", size: ControlWidth(15)) , let bottomFont:UIFont = UIFont(name: "Campton-Light", size: ControlWidth(12)) {
    let postsAttributedText = NSMutableAttributedString(string: "DELETENOTIFICATION".localizable, attributes: [NSAttributedString.Key.font: TopFont])
        postsAttributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: ControlWidth(14))]))
    postsAttributedText.append(NSAttributedString(string: "MassageNotification".localizable, attributes: [NSAttributedString.Key.font: bottomFont]))
        
    PopUp.font = ControlWidth(8)
    PopUp.TextView.attributedText = postsAttributedText
    PopUp.TextView.textAlignment = .center
    PopUp.TextView.textColor = LabelForeground

    PopUp.OkeyButton.isHidden = false
    PopUp.OkeyButton.addTarget(self, action: #selector(DeleteNotifi), for: .touchUpInside)
    Present(ViewController: self, ToViewController: PopUp)
    }
    }
    
    
    func IfDataNull() {
    ActivityIndicator.stopAnimating()
    if self.DataNotification.count == 0 {
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
      View.TryAgain.addTarget(self, action: #selector(ActionNullData), for: .touchUpInside)
      return View
    }()
    
    @objc func ActionNullData() {
        self.Alert.SetIndicator(Style: .load)
        lodData(animate: true)
    }
    
    var IsRead = Int()
    func IfDeleteOrShow() {
    IsRead -= 1
    BadgeValue()
    }
    
    func BadgeValue() {
        DispatchQueue.main.async {
        if self.IsRead == 0 {
        self.tabBarController?.viewControllers?[0].tabBarItem.badgeValue = nil
        }else{
        if let tabItems = self.tabBarController?.tabBar.items {
        let tabItem = tabItems[0]
        tabItem.badgeValue = "\(self.IsRead)"
        tabItem.badgeColor = #colorLiteral(red: 0.9439466596, green: 0.6406636238, blue: 0.6592981219, alpha: 1)
        }
        }
        }
    }
    
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
extension NotificationsVC {
    
    
    func UpdateShowNotifi(relId:Int) {
    guard let url = defaults.string(forKey: "API") else{return}
    let PutNotifications = "\(url + PhonePutNotifications)"

    guard let uid = GetUserObject().uid else { return }
    guard let sysToken = GetUserObject().sysToken else { return }

    guard let Url = URL(string: PutNotifications) else {return}
    var components = URLComponents(url: Url, resolvingAgainstBaseURL: false)!

    components.queryItems = [URLQueryItem(name: "uid", value: uid)
                                    ,URLQueryItem(name: "sysToken", value: sysToken)
                                    ,URLQueryItem(name: "RelId", value: "\(relId)")]

    if let Api = components.url?.absoluteString {
    AlamofireCall(Url: Api, HTTP: .put, parameters: nil) {
    self.IfDeleteOrShow()
    } Err: { _ in}
    }
    }
    
    
    @objc func DeleteNotifi() {
    self.Alert.SetIndicator(Style: .load)
    let Notification = DataNotification[indexPath.row]
    guard let url = defaults.string(forKey: "API") else{return}
    let Delete = "\(url + PhoneDeleteNotifications)"
        
    guard let uid = GetUserObject().uid else { return }
    guard let sysToken = GetUserObject().sysToken else { return }
        
    guard let Url = URL(string:Delete) else {return}
    var components = URLComponents(url: Url, resolvingAgainstBaseURL: false)!

    components.queryItems = [URLQueryItem(name: "uid", value: uid)
                                ,URLQueryItem(name: "sysToken", value: sysToken)
                                ,URLQueryItem(name: "Id", value: "\(Id)")]

    if let Api = components.url?.absoluteString {
    AlamofireCall(Url: Api, HTTP: .delete, parameters: nil) {
    self.tableView.beginUpdates()
    self.DataNotification.remove(at: self.indexPath.item)
    self.tableView.deleteRows(at: [self.indexPath], with: .right)
    self.tableView.endUpdates()
    self.IfDataNull()
    self.Alert.SetIndicator(Style: .success)
    if Notification.readable == false {
    self.IfDeleteOrShow()
    }
    } Err: { err in
    self.Alert.SetIndicator(Style: .error)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    self.SetUpPopUp(text:err)
    }
    }
    }
    }
    
    
    @objc func lodData(animate:Bool ,removeAll:Bool = false) {
    if !Reachability.isConnectedToNetwork() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
    self.Alert.SetIndicator(Style: .Hidden)
    self.SetUpPopUp(text: "InternetNotAvailable".localizable)
    self.IfDataNull()
    })
    }else{
    fetchingMore = true
    guard let url = defaults.string(forKey: "API") else{return}
    let Notification = "\(url + GetNotifications)"
        
    guard let uid = GetUserObject().uid else { return }
    guard let sysToken = GetUserObject().sysToken else { return }
        
    let parameters = ["uid": uid,"sysToken": sysToken,"skip": "\(skip)","take": "20"]
    AlamofireCall(Url: Notification, HTTP: .get, parameters: parameters ,Success: {
    self.IfDataNull()
    self.Alert.SetIndicator(Style: .Hidden)
    }) { (jsons) in
    if removeAll {
    self.IsRead = 0
    self.IsReadable.removeAll()
    self.DataNotification.removeAll()
    self.tableView.reloadData()
    }
                
    for json in jsons {
    if let readable = json["readable"] as? Bool {
    if !readable {
    self.IsRead += 1
    self.BadgeValue()
    }
    }
                
    self.DataNotification.append(Notifications(json: json))
    self.skip += 1
        
    self.tableView.beginUpdates()
    self.tableView.insertRows(at: [IndexPath(row: self.DataNotification.count - 1, section: 0)], with: .bottom)
    self.tableView.endUpdates()
    self.fetchingMore = false
    }
         
    self.IfDataNull()
    self.tableView.refreshControl?.endRefreshing()

    if animate {
    self.Alert.SetIndicator(Style: .Hidden)
    self.tableView.animateTable()}
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
}
