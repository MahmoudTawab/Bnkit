//
//  OffersVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 1/9/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class OffersVC: UIViewController , UITableViewDelegate , UITableViewDataSource  {
            
    var skip = 0
    let OffersId = "cellOne"
    var fetchingMore = false
    var DataOffer = [Offer]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpTableView()
        lodData(animate: true)
        
        view.addSubview(NullData)
        NullData.frame = CGRect(x: 0, y: ControlY(100), width: view.frame.width, height: view.frame.height - ControlHeight(200))
        
        view.addSubview(Alert)
        Alert.frame = view.bounds
        self.Alert.SetIndicator(Style: .load)
    }
        
    fileprivate func SetUpTableView() {

    view.addSubview(TopBackView)
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlWidth(20), height: ControlHeight(50))
        
    TopBackView.addSubview(ActivityIndicator)
    ActivityIndicator.frame = CGRect(x: view.frame.maxX - ControlHeight(45), y: ControlY(10), width: ControlHeight(30), height: ControlHeight(30))
        
    view.addSubview(TableView)
    TableView.frame = CGRect(x: 0, y: ControlY(100), width: view.frame.width, height: view.frame.height - ControlHeight(100))
        
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = LabelForeground
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    TableView.refreshControl = refreshControl
    }
        
    @objc func refresh() {
    skip = 0
    lodData(animate: true, removeAll: true)
    }
        
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.Space = 0
        View.textColor = LabelForeground
        View.FontSize = ControlWidth(30)
        View.text = "OFFERS".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
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
        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tv.register(OffersCell.self, forCellReuseIdentifier: OffersId)
        return tv
    }()
    
    let ActivityIndicator:UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .white)
    aiv.hidesWhenStopped = true
    aiv.isHidden = true
    aiv.color = LabelForeground
    return aiv
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return DataOffer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: OffersId, for: indexPath) as! OffersCell
    let Offer = DataOffer[indexPath.row]
    cell.selectionStyle = .none
    SetupCell(cell,Offer)
    return cell
    }
    
    private func SetupCell(_ cell:OffersCell ,_ offer:Offer) {
    cell.BodyLabel.text = "lang".localizable == "en" ? offer.enDetail : offer.arDetail
    cell.TitleLabel.text = "lang".localizable == "en" ? offer.enTitle : offer.arTitle
    if let OffColor = offer.offColor {
    cell.ViewColor.backgroundColor = hexStringToUIColor(hex:OffColor)
    }
    if let fontColor = offer.fontColor {
    cell.BodyLabel.textColor = hexStringToUIColor(hex:fontColor)
    cell.TitleLabel.textColor = hexStringToUIColor(hex:fontColor)
    }
    if let ImageUrl = offer.photoPath {
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
    let Offer = DataOffer[indexPath.row]
    let controller = OfferDetaIlsVC()
    controller.TextTi = "lang".localizable == "en" ? Offer.enTitle : Offer.arTitle
    controller.TextDe = "lang".localizable == "en" ? Offer.enDetail : Offer.arDetail
    controller.ImageUrl = Offer.detailPhotoPath
    controller.OffId = Offer.offId
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
    self.ActivityIndicator.startAnimating()
    self.lodData(animate: false)
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    self.ActivityIndicator.stopAnimating()
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
    ActivityIndicator.stopAnimating()
    if self.DataOffer.count == 0 {
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
extension OffersVC {
    
    
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
    let api = "\(url + Offers)"

    let parameters = ["skip": "\(skip)","take": "10"]
    AlamofireCall(Url: api, HTTP: .get, parameters: parameters ,Success: {}) { (jsons) in
    if removeAll {
    self.DataOffer.removeAll()
    self.TableView.reloadData()
    }
                    
    for json in jsons {
    self.DataOffer.append(Offer(json: json))
    self.skip += 1
    self.TableView.beginUpdates()
    self.TableView.insertRows(at: [IndexPath(row: self.DataOffer.count - 1, section: 0)], with: .bottom)
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
    self.SetUpPopUp(text:err)
    self.IfDataNull()
    })
    }
    }
    }
    
}
