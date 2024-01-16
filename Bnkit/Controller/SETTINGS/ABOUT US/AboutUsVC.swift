//
//  AboutUsVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/11/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    

    let cellId = "cellId"
    var AboutData = [About]()
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    LodData()
    SetUpTableView()
        
    view.addSubview(NullData)
    NullData.frame = CGRect(x: 0, y: ControlY(100), width: view.frame.width, height: view.frame.height - ControlHeight(200))
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
    self.Alert.SetIndicator(Style: .load)
    }
    
        
    fileprivate func SetUpTableView() {
    view.addSubview(TopBackView)
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlX(20), height: ControlHeight(50))
    
    view.addSubview(TableView)
    TableView.frame = CGRect(x: 0, y: ControlY(100), width: view.frame.width, height: view.frame.height - ControlHeight(100))
        
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = LabelForeground
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    TableView.refreshControl = refreshControl
    }
            
    @objc func refresh() {
    LodData()
    }
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.Space = 0
        View.textColor = LabelForeground
        View.FontSize = ControlWidth(30)
        View.text = "ABOUTUS".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var TableView : UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.estimatedRowHeight = 100
        tv.rowHeight = UITableView.automaticDimension
        tv.backgroundColor = .clear
        tv.alwaysBounceVertical = false
        tv.register(AboutCell.self, forCellReuseIdentifier: cellId)
        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0)
        return tv
    }()

    
    
    func SetUpPopUp(text:String) {
    let PopUp = PopUpView()
    PopUp.text = text
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUp)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AboutData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AboutCell
        let About = AboutData[indexPath.row]
        cell.selectionStyle = .none
        setValues(cell, About)
        return cell
    }

    func setValues(_ cell: AboutCell ,_ About: About ) {
    
    let Title = "lang".localizable == "en" ? About.enTitle : About.arTitle
    cell.TheTitle.text = Title
    cell.TheTitle.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(27))
        
    cell.TheDetails.font = UIFont(name: "Campton-Light" ,size: ControlWidth(16))
    cell.TheDetails.text = "lang".localizable == "en" ? About.enBody : About.arBody
    let AboutShow = About.AboutShow
    cell.TheDetails.alpha = 0
    cell.TheDetails.isHidden = !AboutShow
    UIView.animate(withDuration: 0.6) {
    cell.TheDetails.alpha = 1
    }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let About = AboutData[indexPath.row]
    let AboutShow = AboutData[indexPath.row].AboutShow
    About.AboutShow = !AboutShow
    tableView.reloadRows(at: [indexPath], with: .fade)
    }
        
    func IfDataNull() {
    if self.AboutData.count == 0 {
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
    LodData()
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
extension AboutUsVC {
    
    @objc func LodData() {
    if !Reachability.isConnectedToNetwork() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
    self.Alert.SetIndicator(Style: .Hidden)
    self.SetUpPopUp(text: "InternetNotAvailable".localizable)
    self.IfDataNull()
    })
    }else{
    guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + AboutUsInfo)"
        
    AlamofireCall(Url: api, HTTP: .get, parameters: nil , Success: {}) { jsons in
    self.AboutData.removeAll()

    for json in jsons {
    self.AboutData.append(About(json: json))
    }

    DispatchQueue.main.async {
    self.IfDataNull()
    self.Alert.SetIndicator(Style: .Hidden)
    self.TableView.reloadData()
    self.TableView.animateTable()
    self.NullData.removeFromSuperview()
    self.TableView.refreshControl?.endRefreshing()
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
