//
//  LeaveMessageVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 10/26/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import FlagPhoneNumber

class LeaveMessageVC: UIViewController , UITextViewDelegate, UITextFieldDelegate ,FPNTextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    }
     

    func SetUpItems() {
    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)
        
    ViewScroll.addSubview(TopBackView)
    ViewScroll.addSubview(MessageTV)
    ViewScroll.addSubview(borderTV)
    ViewScroll.addSubview(SendButton)
            
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(20), width: view.frame.width - ControlX(20), height: ControlHeight(50))
        
    SendButton.frame = CGRect(x: view.center.x - ControlWidth(60), y: view.frame.height - ControlHeight(120), width: ControlWidth(120), height: ControlHeight(40))
    SendButton.layer.cornerRadius = SendButton.frame.height / 2
        
    let StackVertical = UIStackView(arrangedSubviews: [NameTF,PhoneTF,EmailTF])
    StackVertical.axis = .vertical
    StackVertical.spacing = ControlHeight(45)
    StackVertical.distribution = .fillEqually
    StackVertical.backgroundColor = .clear
    ViewScroll.addSubview(StackVertical)
    StackVertical.frame =  CGRect(x: ControlX(25), y: TopBackView.frame.maxY + ControlY(50), width: view.frame.width - ControlX(50), height: ControlHeight(200))
        
    MessageTV.delegate = self
    MessageTV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ControlX(25)).isActive = true
    MessageTV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ControlX(-25)).isActive = true
    MessageTV.topAnchor.constraint(equalTo: StackVertical.bottomAnchor, constant: ControlY(70)).isActive = true
    MessageTV.heightAnchor.constraint(equalToConstant: ControlHeight(140)).isActive = true

    borderTV.leadingAnchor.constraint(equalTo: MessageTV.leadingAnchor).isActive = true
    borderTV.trailingAnchor.constraint(equalTo: MessageTV.trailingAnchor).isActive = true
    borderTV.bottomAnchor.constraint(equalTo: MessageTV.bottomAnchor, constant: ControlY(5)).isActive = true
    borderTV.heightAnchor.constraint(equalToConstant: ControlHeight(1)).isActive = true
        
    PhoneTF.delegate = self
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
        
    SetUpPhoneNumber()
        
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(0)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
    return false
    }
    return true
    }
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.FontSize = ControlWidth(30)
        View.textColor = LabelForeground
        View.Space =  ControlWidth(3)
        View.text = "LEAVEAMESSAGE".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.backgroundColor = .clear
        Scroll.delegate = self
        Scroll.bounces = true
        Scroll.keyboardDismissMode = .interactive
        return Scroll
    }()
    
    lazy var NameTF : FloatingTF = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string:"Name".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    var repository: FPNCountryRepository = FPNCountryRepository()
    let bottomLine = UIView()
    let PhoneLabel = UILabel()
    lazy var PhoneTF : FPNTextField = {
        let tf = FPNTextField()
        tf.displayMode = .list
        tf.delegate = self
        tf.textColor = LabelForeground
        tf.attributedPlaceholder = NSAttributedString(string: "Phone".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.addTarget(self, action: #selector(PhoneEditingDidEnd), for: .editingDidEnd)
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = LabelForeground
        tf.addSubview(bottomLine)
        
        bottomLine.leftAnchor.constraint(equalTo: tf.leftAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: tf.rightAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: tf.bottomAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: ControlHeight(1)).isActive = true
        
        ///
        PhoneLabel.alpha = 0
        PhoneLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        PhoneLabel.backgroundColor = .clear
        PhoneLabel.text = "ErrorPhone".localizable
        PhoneLabel.translatesAutoresizingMaskIntoConstraints = false
        PhoneLabel.font = UIFont(name: "Campton-Light", size: ControlWidth(13))
        tf.addSubview(PhoneLabel)
        
        PhoneLabel.leftAnchor.constraint(equalTo: tf.leftAnchor).isActive = true
        PhoneLabel.rightAnchor.constraint(equalTo: tf.rightAnchor).isActive = true
        PhoneLabel.topAnchor.constraint(equalTo: tf.bottomAnchor , constant: ControlHeight(5)).isActive = true
        PhoneLabel.heightAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true
        return tf
    }()
    
    func SetUpPhoneNumber() {
    listController.setup(repository: PhoneTF.countryRepository)
    listController.didSelect = { [weak self] country in
    self?.PhoneTF.setFlag(countryCode: country.code)
    }
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
    print(name, dialCode, code)
    }
    
    var isValidNumber = false
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
    bottomLine.backgroundColor = isValid ?  LabelForeground : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    PhoneLabel.alpha = isValid ? 0 : 1
    isValidNumber = isValid
    }
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        listController.title = "Select your country".localizable
        listController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshCountries))
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissCountries))
        listController.navigationItem.rightBarButtonItem?.tintColor = LabelForeground
        listController.navigationItem.leftBarButtonItem?.tintColor = LabelForeground
        
        listController.searchController.searchBar.barTintColor = BackgroundColor
        listController.searchController.searchBar.backgroundColor = BackgroundColor
        
        Present(ViewController: self, ToViewController: navigationViewController)
    }
    
    @objc func refreshCountries() {
    listController.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    @objc func dismissCountries() {
    listController.dismiss(animated: true, completion: nil)
    }
    
    @objc func PhoneEditingDidEnd() {
    bottomLine.backgroundColor = LabelForeground
    PhoneLabel.alpha = 0
    }
    
    lazy var EmailTF : FloatingTF = {
        let tf = FloatingTF()
        tf.keyboardType = .emailAddress
        tf.attributedPlaceholder = NSAttributedString(string:"Email".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
        
    lazy var  MessageTV : GrowingTextView = {
    let TV = GrowingTextView()
    TV.placeholder = "YourMessageHere".localizable
    TV.minHeight = ControlHeight(20)
    TV.maxHeight = ControlHeight(140)
    TV.placeholderColor = LabelForeground
    TV.backgroundColor = .clear
    TV.tintColor = LabelForeground
    TV.textColor = LabelForeground
    TV.autocorrectionType = .no
    TV.font = UIFont(name: "Campton-Light", size:  ControlWidth(16))
    TV.textContainerInset = UIEdgeInsets(top: 5, left: -4, bottom: 0, right: 0)
    TV.translatesAutoresizingMaskIntoConstraints = false
    return TV
    }()
    
    
    lazy var borderTV : UIView = {
    let border = UIView()
    border.backgroundColor =  #colorLiteral(red: 0.3808627231, green: 0.3846336411, blue: 0.3846336411, alpha: 1)
    border.translatesAutoresizingMaskIntoConstraints = false
    return border
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    UIView.animate(withDuration: 0.2) {
    self.borderTV.backgroundColor =  LabelForeground
    }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    UIView.animate(withDuration: 0.2) {
    self.borderTV.backgroundColor =  #colorLiteral(red: 0.3808627231, green: 0.3846336411, blue: 0.3846336411, alpha: 1)
    }
    }
    
    
    lazy var SendButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.titleLabel?.font = UIFont(name: "Campton-SemiBold", size:  ControlWidth(18))
        Button.setTitle("SEND".localizable, for: .normal)
        Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.titleLabel?.textAlignment = .center
        Button.addTarget(self, action: #selector(ActionSend), for: .touchUpInside)
        return Button
    }()

    

    
    
    func SetUpPopUp(text:String) {
    let PopUp = PopUpView()
    PopUp.text = text
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUp)
    }
    
    func Error(Err:String) {
    self.Alert.SetIndicator(Style: .error)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
    self.SetUpPopUp(text: Err)
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
extension LeaveMessageVC {
    
    @objc func ActionSend() {
    self.Alert.SetIndicator(Style: .load)
        
     guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + LeaveAMessage)"
        
    guard let name = NameTF.text else {return}
    guard let phone = PhoneTF.text else {return}
    
    guard let email = EmailTF.text else {return}
    guard let message = MessageTV.text else {return}
        
    let PhoneNew = phone.replacingOccurrences(of: " ", with: "")
        
    if isValidEmail(emailID: email) == false {
    self.Error(Err: "ErrorEmail".localizable)
    return
    }
        
    if isValidNumber == false {
    self.Error(Err: "ErrorPhone".localizable)
    return
    }
        
    if name.TextNull() == false || message.TextNull() == false {
    self.Error(Err: "FillInInformationCorrectly".localizable)
    return
    }
        
    let parameters: [String: Any] = [
    "name": name,
    "phone": PhoneNew,
    "email": email,
    "body": message,
    "sendReplyMessage": false,
    "replyMessage": ""
    ]
        
    AlamofireCall(Url: api, HTTP: .post, parameters: parameters,encoding: JSONEncoding.default) {
    self.Alert.SetIndicator(Style: .success)
    self.NameTF.text = ""
    self.PhoneTF.text = ""
    self.EmailTF.text = ""
    self.MessageTV.text = ""
    } Err: { (err) in
    self.Error(Err: err)
    }
    }
    
    
}
