//
//  IScoreVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 2/11/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FlagPhoneNumber

class IScoreVC: UIViewController , UITextFieldDelegate ,FPNTextFieldDelegate {

    var reqId = Int()
    var isUpdate = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpItems()
    }
    
    
    func SetUpItems() {
        
    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)
        
    ViewScroll.addSubview(TopBackView)
    TopBackView.frame =  CGRect(x: ControlX(5), y: ControlY(20), width: view.frame.width - ControlX(10), height: ControlHeight(50))
        
    let StackVertical = UIStackView(arrangedSubviews: [EmailTF,FullNameTF,MobileTF,LengthOfBusinessTF,CommentsTF])
    StackVertical.axis = .vertical
    StackVertical.spacing = ControlHeight(45)
    StackVertical.distribution = .fillEqually
    StackVertical.alignment = .fill
    StackVertical.backgroundColor = .clear
    ViewScroll.addSubview(StackVertical)
        
    StackVertical.frame = CGRect(x: ControlX(20), y: ControlY(120), width: view.frame.width - ControlX(40), height: ControlHeight(300))

//    ViewScroll.addSubview(CheckboxButton)
//    ViewScroll.addSubview(UserAgreementLabel)
    ViewScroll.addSubview(SubmitButton)
        
//    CheckboxButton.frame = CGRect(x: ControlX(15), y: ControlY(500), width: ControlHeight(35), height: ControlHeight(35))
//
//    UserAgreementLabel.frame = CGRect(x: ControlX(55), y: ControlY(510), width: view.frame.width - ControlX(110), height: ControlHeight(20))

    SubmitButton.frame = CGRect(x: view.center.x - ControlWidth(60), y: ControlY(490), width: ControlWidth(120), height: ControlHeight(40))
    SubmitButton.layer.cornerRadius = SubmitButton.frame.height / 2
        
    MobileTF.delegate = self
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
        
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(0)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
    return false
    }
    return true
    }
    
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.backgroundColor = .clear
        Scroll.showsVerticalScrollIndicator = false
        Scroll.bounces = true
        Scroll.keyboardDismissMode = .interactive
        return Scroll
    }()

    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = LabelForeground
        View.Space = ControlHeight(3)
        View.FontSize = ControlWidth(30)
        View.text = "I-SCORE".localizable
        View.Button.tintColor = View.textColor
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var EmailTF : UITextField = {
        let tf = FloatingTF()
        tf.keyboardType = .emailAddress
        tf.attributedPlaceholder = NSAttributedString(string: "E-mail*".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var FullNameTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "FullName".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
        
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    var repository: FPNCountryRepository = FPNCountryRepository()
    let bottomLine = UIView()
    let PhoneLabel = UILabel()
    lazy var MobileTF : FPNTextField = {
        let tf = FPNTextField()
        tf.displayMode = .list
        tf.delegate = self
        tf.textColor = LabelForeground
        tf.attributedPlaceholder = NSAttributedString(string: "MobileNo".localizable, attributes:[.foregroundColor: LabelForeground])
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
    listController.setup(repository: MobileTF.countryRepository)
    listController.didSelect = { [weak self] country in
    self?.MobileTF.setFlag(countryCode: country.code)
    }
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
    print(name, dialCode, code)
    }
    
    var isValidNumber = Bool()
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
    
    lazy var LengthOfBusinessTF : UITextField = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "LengthOfBusiness".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var CommentsTF : UITextField = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "Comments".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var CheckboxButton : Checkbox = {
        let Button = Checkbox(type: .system)
        Button.backgroundColor = .clear
        return Button
    }()

    lazy var UserAgreementLabel : UILabel = {
        let Label = UILabel()
                
        let attributedString = NSMutableAttributedString(string: "IAgreeTo".localizable, attributes: [
            .font: UIFont(name: "Campton-Light", size: ControlWidth(16)) ?? UIFont.systemFont(ofSize: ControlWidth(16)),
            .foregroundColor: LabelForeground
        ])
    
        
        attributedString.append(NSAttributedString(string: "UserAgreement".localizable, attributes: [
            .font: UIFont(name: "Campton-Light", size: ControlWidth(16)) ?? UIFont.systemFont(ofSize: ControlWidth(16)),
            .foregroundColor: LabelForeground ,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        
        Label.backgroundColor = .clear
        Label.attributedText = attributedString
        return Label
    }()

    lazy var SubmitButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.titleLabel?.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(18))
        Button.setTitle("SUBMIT".localizable, for: .normal)
        Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.titleLabel?.textAlignment = .center
        Button.addTarget(self, action: #selector(ActionSubmit), for: .touchUpInside)
        return Button
    }()
    

        
    func Error(Err:String) {
    self.Alert.SetIndicator(Style: .error)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
    self.SetUpPopUp(text: Err)
    }
    }
    
    func SetUpPopUp(text:String) {
    let PopUp = PopUpView()
    PopUp.text = text
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUp)
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
extension IScoreVC {
    
    @objc func ActionSubmit() {
        
    if Auth.auth().currentUser?.uid == nil {
    Error(Err: "ErrorLogIn".localizable)
    return
    }
        
     guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + PhoneIScoreRequest)"
        
    guard let uid = GetUserObject().uid else{return}
    guard let sysToken = GetUserObject().sysToken else{return}
        
    guard let email = EmailTF.text else {return}
    guard let FullName = FullNameTF.text else {return}
    guard let Mobile = MobileTF.text else {return}
    let PhoneNew = Mobile.replacingOccurrences(of: " ", with: "")
    let LengthOfBusiness = LengthOfBusinessTF.text ?? ""
    let Comments = CommentsTF.text ?? ""
        
        
    if email.TextNull() == false || FullName.TextNull() == false {
    Error(Err: "FillInInformationCorrectly".localizable)
    return
    }else if isValidEmail(emailID: email) == false {
    Error(Err: "ErrorEmail".localizable)
    return
//    }else if CheckboxButton.Button.tag == 0 {
//    Error(Err: "ErrorUserAgreement".localizable)
//    return
    }else if isValidNumber == false {
    Error(Err: "ErrorPhone".localizable)
    return
    }
        
    let parameters: [String: Any] = [
        "isUpdate": isUpdate,
        "reqId": reqId,
        "uid": uid,
        "sysToken": sysToken,
        "projectSectorTypId": 5,
        "email": email,
        "fullName": FullName,
        "mobile": PhoneNew,
        "lengthofBusines": LengthOfBusiness,
        "comments": Comments
        ]
          
    self.Alert.SetIndicator(Style: .load)
    AlamofireCall(Url: api, HTTP: .post, parameters: parameters,encoding: JSONEncoding.default) {
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {Success()}
    } Err: { (err) in
    self.Error(Err: err)
    }
    }
    
}
