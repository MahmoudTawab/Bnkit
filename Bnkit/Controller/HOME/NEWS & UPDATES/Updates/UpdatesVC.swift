//
//  UpdatesVC.swift
//  PagingMenuControllerDemo
//
//  Created by Yusuke Kita on 5/10/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

class UpdatesVC: UIViewController , UITableViewDelegate , UITableViewDataSource  {
    
    
    var skip = 0
    let UpdatesId = "cellOne"
    var fetchingMore = false
    var DataUpdates = [NewsAndUpdates]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpTableView()
        lodData(animate: true)
        
        
        view.addSubview(NullData)
        NullData.frame = CGRect(x: 0, y: ControlY(100), width: view.frame.width, height: view.frame.height - ControlHeight(200))
        
        view.addSubview(Alert)
        Alert.frame = view.bounds
        Alert.backgroundColor = .clear
        Alert.SetIndicator(Style: .load)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Alert.isShow {
        Alert.Indicator.startAnimating()
        }
    }
    
    init(title: String) {
      super.init(nibName: nil, bundle: nil)
      self.title = title
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
        
    fileprivate func SetUpTableView() {
    view.addSubview(TableView)
    TableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - ControlHeight(110))
        
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = LabelForeground
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    TableView.refreshControl = refreshControl
    }
            
    @objc func refresh() {
    skip = 0
    lodData(animate: true, removeAll: true)
    }
    
    
    lazy var TableView : UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.alwaysBounceVertical = false
        tv.separatorStyle = .none
        tv.rowHeight = ControlHeight(260)
        tv.register(NewsAndUpdateCell.self, forCellReuseIdentifier: UpdatesId)
        tv.contentInset = UIEdgeInsets(top: ControlX(5), left: 0, bottom: ControlX(10), right: 0)
        return tv
    }()
    
    func SetUpIndicatorView() {
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: TableView.frame.width, height: ControlHeight(90)))
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.hidesWhenStopped = true
    aiv.isHidden = true
    aiv.color = LabelForeground
    aiv.startAnimating()
    aiv.translatesAutoresizingMaskIntoConstraints = false

    customView.addSubview(aiv)
    aiv.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
    aiv.centerXAnchor.constraint(equalTo: customView.centerXAnchor).isActive = true
    aiv.widthAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true
    aiv.heightAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true

    TableView.tableFooterView = customView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DataUpdates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UpdatesId, for: indexPath) as! NewsAndUpdateCell
    let Updates = DataUpdates[indexPath.row]
    cell.selectionStyle = .none
    cell.setValues(Updates)
    SetupCell(cell,Updates)
    return cell
    }
    
    private func SetupCell(_ cell:NewsAndUpdateCell ,_ Updates:NewsAndUpdates) {
    cell.BodyLabel.text = "lang".localizable == "en" ? Updates.enDetail : Updates.arDetail
    cell.TitleLabel.text = "lang".localizable == "en" ? Updates.enTitle : Updates.arTitle
    if let OffColor = Updates.offColor {
    cell.ViewColor.backgroundColor = hexStringToUIColor(hex:OffColor)
    }
    if let fontColor = Updates.fontColor {
    cell.BodyLabel.textColor = hexStringToUIColor(hex:fontColor)
    cell.TitleLabel.textColor = hexStringToUIColor(hex:fontColor)
    }
        
    if let ImageUrl = Updates.mediaUrl {
    cell.ImageView.sd_setImage(with: URL(string: ImageUrl)) { Image, _, _, _ in
    cell.ImageView.image = Image
    }
    }
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
        return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let Updates = DataUpdates[indexPath.row]
    let controller = NewsAndUpdateDetalls()
    controller.TextTi = "lang".localizable == "en" ? Updates.enTitle : Updates.arTitle
    controller.TextDe = "lang".localizable == "en" ? Updates.enDetail : Updates.arDetail
    controller.IsVedio = Updates.isVedio
    controller.ImageUrl = Updates.mediaUrl
    controller.VedioUrl = Updates.youtubeCode
    controller.NewsAndUpdateId = Updates.newsId
    PresentByNavigation(ViewController: self, ToViewController: controller)
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    cell.contentView.alpha = 0.3
    cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    UIView.animate(withDuration: 0.5) {
    cell.contentView.alpha = 1
    cell.transform = .identity
    }
        
    if !fetchingMore && tableView.isDragging {
    tableView.addLoading(indexPath) {
    self.SetUpIndicatorView()
    self.lodData(animate: false)
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    UIView.animate(withDuration: 0.5) {
    self.TableView.beginUpdates()
    self.TableView.tableFooterView = nil
    self.TableView.endUpdates()
    }
    }
    }
    }
    }
    
    func SetUpPopUp(text:String) {
    let PopUp = PopUpView()
    PopUp.text = text
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUp)
    }
    
    func IfDataNull() {
    if self.DataUpdates.count == 0 {
    TableView.isHidden = true
    NullData.isHidden = false
    }else{
    TableView.isHidden = false
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
extension UpdatesVC {
    
    
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
    let api = "\(url + PhoneGetUpdates)"

    let parameters = ["skip": "\(skip)","take": "10"]
    AlamofireCall(Url: api, HTTP: .get, parameters: parameters ,Success: {}) { (jsons) in
    if removeAll {
    self.DataUpdates.removeAll()
    self.TableView.reloadData()
    }
            
    for json in jsons {
    self.DataUpdates.append(NewsAndUpdates(json: json))
    self.skip += 1
    self.TableView.beginUpdates()
    self.TableView.insertRows(at: [IndexPath(row: self.DataUpdates.count - 1, section: 0)], with: .bottom)
    self.TableView.endUpdates()
    self.fetchingMore = false
    }
            
    self.IfDataNull()
    self.TableView.refreshControl?.endRefreshing()
            
    if animate {
    self.Alert.SetIndicator(Style: .Hidden)
    self.TableView.animateTable()
    }
        
    } Err: { (err) in
    self.Alert.SetIndicator(Style: .error)
    self.TableView.refreshControl?.endRefreshing()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
    self.SetUpPopUp(text: err)
    self.IfDataNull()
    })
    }
    }
    }
        
    
}
