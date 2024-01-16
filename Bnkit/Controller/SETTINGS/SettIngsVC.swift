//
//  SettIngsVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import FirebaseAuth

class SettIngsVC: UIViewController,UITableViewDelegate,UITableViewDataSource,SettIngsCelldelegate {

    let cellId = "cellId"
    var language = String()
    var SettIngArray = [String]()
    var SettIngImage = [String]()
    override func viewDidLoad() {
    super.viewDidLoad()
    SettIngArray = ["MyAccount".localizable,"","Share".localizable,"AboutUS".localizable,"HELP".localizable,"SignOut".localizable]
    SetUpTableView()
    }


    fileprivate func SetUpTableView() {
    language = "lang".localizable == "en" ? "EN" : "AR"

    view.backgroundColor = BackgroundColor
        
    view.addSubview(SettIngsLabel)
    SettIngsLabel.frame = CGRect(x: ControlX(25), y: ControlY(35), width: view.frame.width - ControlX(50), height: ControlHeight(35))

    view.addSubview(tableView)
    tableView.frame = CGRect(x: 0, y: SettIngsLabel.frame.maxY + ControlY(10), width: view.frame.width , height: view.frame.height - ControlHeight(80))

    for i in 1...6 {
    SettIngImage.append("Settings\(i)")
    }
    }

    lazy var SettIngsLabel : UILabel = {
    let Label = UILabel()
    Label.backgroundColor = .clear
    Label.textColor = LabelForeground
    Label.text = "Settings".localizable
    Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(25))
    return Label
    }()

    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.register(SettIngsCell.self, forCellReuseIdentifier: cellId)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.separatorColor = .clear
        tv.isScrollEnabled = false
        tv.rowHeight = ControlHeight(60)
        tv.showsVerticalScrollIndicator = false
        return tv
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return SettIngArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettIngsCell

    cell.SettIngsLabel.text = SettIngArray[indexPath.row]
    cell.SettIngsLabel.font = UIFont(name: "Campton-Medium", size: ControlWidth(15))

    cell.LogoImageView.image = UIImage(named: SettIngImage[indexPath.row])
    cell.LogoImageView.widthAnchor.constraint(equalToConstant: ControlHeight(28)).isActive = true
    cell.LogoImageView.heightAnchor.constraint(equalToConstant: ControlHeight(28)).isActive = true
    cell.delegate = self

    switch indexPath.row {
    case 0:
    cell.ViewTopLine.alpha = 1
    case 1:
    cell.LanguageIcon.alpha = 1
    if let Font1:UIFont = UIFont(name: "Campton-Medium", size: ControlWidth(15)) ,  let Font2:UIFont = UIFont(name: "Campton-Light", size: ControlWidth(11)) {
    let postsAttributedText = NSMutableAttributedString(string: "Language".localizable, attributes: [NSAttributedString.Key.font: Font1,NSAttributedString.Key.foregroundColor:LabelForeground])
    postsAttributedText.append(NSAttributedString(string: language, attributes: [NSAttributedString.Key.font: Font2,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6041838753, green: 0.6041838753, blue: 0.6041838753, alpha: 1)]))
    cell.SettIngsLabel.attributedText = postsAttributedText
    }
    default: break}

    return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
    PresentByNavigation(ViewController: self, ToViewController: ProfIleVC())
    case 1:
    didLanguage()
    case 2:
    share()
    case 3:
    PresentByNavigation(ViewController: self, ToViewController: AboutUsVC())
    case 4:
    PresentByNavigation(ViewController: self, ToViewController: HelpVC())
    case 5:
    ActionLogout()
    default: break}
    tableView.deselectRow(at: indexPath, animated: true)
    }


    var PopUp = PopUpLanguageView()
    func didLanguage() {
    PopUp.SetLanguageView()
    PopUp.DismissButton.addTarget(self, action: #selector(PopUpDismiss), for: .touchUpInside)
    PopUp.OkeyButton.addTarget(self, action: #selector(PopUpOkey), for: .touchUpInside)
    PopUp.SettIngs = self
    if "lang".localizable == "en" {
    PopUp.EnglishButton.isOn = true
    PopUp.ArabicButton.isOn = false
    }else{
    PopUp.ArabicButton.isOn = true
    PopUp.EnglishButton.isOn = false
    }
    Present(ViewController: self, ToViewController: PopUp)
    }

    @objc func PopUpDismiss() {
    dismiss(animated: true)
    }

    @objc func PopUpOkey() {
    if PopUp.EnglishButton.isOn == true {
    if "lang".localizable != "en" {
    MOLH.setLanguageTo("en")
    MOLH.reset()
    lang(lang: "en")
    }
    }else{
    if "lang".localizable == "en" {
    MOLH.setLanguageTo("ar")
    MOLH.reset()
    lang(lang: "ar")
    }
    }
    DispatchQueue.main.async {
    self.tableView.reloadData()
    self.dismiss(animated: true)
    }
    }


    func share() {
    if let string = defaults.string(forKey: "website") {
    if let logo = UIImage(named: "logo"), let websiteURL = URL(string: string) {
    let objectsToShare = [logo,"BnkitApp".localizable, websiteURL] as [Any]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    if let popoverController = activityVC.popoverPresentationController {
    popoverController.sourceView = self.view
    popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    }
    present(activityVC, animated: true)
    }
    }
    }

    func ActionLogout() {
    let alertStyle = UIDevice.current.userInterfaceIdiom == .pad ? UIAlertController.Style.alert:UIAlertController.Style.actionSheet
    let alertController = UIAlertController(title: "LOGOUT".localizable, message: nil, preferredStyle: alertStyle)
    alertController.addAction(UIAlertAction(title:"LOGOUT".localizable, style: .destructive , handler: { (_) in
    do {
    try Auth.auth().signOut()
    DispatchQueue.main.async {
    self.clearDeepObjectEntity()
    }
    }catch let signOutErr {
    print("Failed to sign out:",signOutErr.localizedDescription)
    }
    }))
    alertController.addAction(UIAlertAction(title: "Cancel".localizable, style: .cancel, handler: nil))
    alertController.view.tintColor = LabelForeground
    present(alertController, animated: true, completion: nil)
    }

    func clearDeepObjectEntity() {
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
    if key != "API" {
    defaults.removeObject(forKey: key)
    }
    }
        
    self.tabBarController?.selectedIndex = 2
    NotificationCenter.default.post(name: LogInController.NotificationSignOut, object: nil)
    }

}


///----------------------------------------------
/// MARK: GET DATA BY API
///----------------------------------------------
extension SettIngsVC {
    
    
    func lang(lang:String) {
    guard let url = defaults.string(forKey: "API") else{return}
    let UpdateLang = "\(url + PhoneUpdateLang)"
    guard let uid = GetUserObject().uid else{return}
    guard let sysToken = GetUserObject().sysToken else{return}

    let parameters  = ["uid": uid,
                       "sysToken": sysToken,
                       "lang": lang]

    AlamofireCall(Url: UpdateLang, HTTP: .put, parameters: parameters,encoding: JSONEncoding.default) {
    defaults.set(lang, forKey: "lang")
    } Err: { _ in}
    }
    
}
