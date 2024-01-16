//
//  HelpVC.swift
//  Bnkit
//
//  Created by Mohamed Tawab on 05/02/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class HelpVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var skip = 0
    let cellId = "cellId"
    var DataHelp = [Help]()
    var fetchingMore = false
    
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
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlX(100), height: ControlHeight(50))
        
    TopBackView.addSubview(ActivityIndicator)
    ActivityIndicator.frame = CGRect(x: view.frame.maxX - ControlHeight(45), y: ControlY(10), width: ControlHeight(30), height: ControlHeight(30))
        
    view.addSubview(TableView)
    TableView.frame = CGRect(x: 0, y: ControlY(100), width: view.frame.width , height: view.frame.height - ControlHeight(100))
        
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
        View.text = "Help".localizable
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
        tv.backgroundColor = .clear
        tv.alwaysBounceVertical = false
        tv.rowHeight = UITableView.automaticDimension
        tv.register(HelpCell.self, forCellReuseIdentifier: cellId)
        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
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
        return DataHelp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HelpCell
        cell.selectionStyle = .none
        let Help = DataHelp[indexPath.row]
        cell.setValues(Help)
        if indexPath.row == 0 {
        cell.ViewTopLine.alpha = 1
        }else{
        cell.ViewTopLine.alpha = 0
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let Help = DataHelp[indexPath.row]
    let HelpShown = DataHelp[indexPath.row].HelpShow
    Help.HelpShow = !HelpShown
    self.TableView.reloadRows(at: [indexPath], with: .automatic)
    self.TableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
    
    
    func SetUpPopUp(text:String) {
    let PopUp = PopUpView()
    PopUp.text = text
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUp)
    }

    func IfDataNull() {
    ActivityIndicator.stopAnimating()
    if self.DataHelp.count == 0 {
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
extension HelpVC {
  
    
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
        let api = "\(url + help)"

        let parameters = ["skip": "\(skip)","take": "20"]
        
        AlamofireCall(Url: api, HTTP: .get, parameters: parameters ,Success: {}) { (jsons) in
                
        if removeAll {
        self.DataHelp.removeAll()
        self.TableView.reloadData()
        }
                    
        for json in jsons {
        self.DataHelp.append(Help(json: json))
        self.skip += 1
        self.TableView.beginUpdates()
        self.TableView.insertRows(at: [IndexPath(row: self.DataHelp.count - 1, section: 0)], with: .bottom)
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
