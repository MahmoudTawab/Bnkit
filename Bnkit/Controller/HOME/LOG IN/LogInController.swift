//
//  LogInController.swift
//  Bnkit
//  Mohamed Abd El Tawab
//  Created by Mahmoud Tawab on 9/5/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import FirebaseAuth
import SDWebImage

class LogInController: UIViewController {

    var LogIn = false
    var Space = CGFloat()
    var SizeFont = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpItems()
    }
    
    func SetUpItems() {
    let TopHeight = UIApplication.shared.statusBarFrame.height
    ViewScroll.frame = CGRect(x: 0, y: -TopHeight, width: view.frame.width, height: view.frame.height + TopHeight)
    view.addSubview(ViewScroll)
    
    ViewScroll.addSubview(LogInImageView)
    ViewScroll.addSubview(LogInLabel)
    ViewScroll.addSubview(EmailTF)
    ViewScroll.addSubview(PasswordTF)
    ViewScroll.addSubview(loginButton)
    ViewScroll.addSubview(BackButton)
    ViewScroll.addSubview(ContactUsButton)
    ViewScroll.addSubview(ForgotPasswordButton)
    ViewScroll.addSubview(SignUpButton)
        
    LogInImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: ControlHeight(240))
        
    LogInLabel.frame = CGRect(x: ControlX(30), y: ControlY(270), width: view.frame.width - ControlX(60), height: ControlHeight(38))
        
    EmailTF.frame =  CGRect(x: ControlX(30), y: ControlY(330), width: view.frame.width - ControlX(60), height: ControlHeight(38))
        
    PasswordTF.frame = CGRect(x: ControlX(30), y: ControlY(410), width: view.frame.width - ControlX(60), height: ControlHeight(38))
        
    loginButton.frame = CGRect(x: view.center.x - ControlWidth(70), y: ControlY(480), width: ControlWidth(140), height: ControlHeight(38))
    loginButton.layer.cornerRadius = loginButton.frame.height / 2
        
    BackButton.frame = CGRect(x: view.center.x - ControlWidth(25), y: ControlY(545), width: ControlWidth(50), height: ControlWidth(50))
    BackButton.layer.cornerRadius = ControlWidth(25)
        
    ContactUsButton.frame = CGRect(x: ControlX(25), y: view.frame.height - ControlY(52), width: ControlWidth(80), height: ControlX(38))
    ForgotPasswordButton.frame = CGRect(x: view.center.x - ControlWidth(70), y: ContactUsButton.frame.minY, width: ControlWidth(140), height: ContactUsButton.frame.height)
    SignUpButton.frame = CGRect(x: (view.frame.maxX - ControlWidth(60)) - ControlX(25), y: ContactUsButton.frame.minY, width: ControlWidth(60), height: ContactUsButton.frame.height)
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
    }
    
        
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.backgroundColor = .clear
        Scroll.bounces = false
        Scroll.keyboardDismissMode = .interactive
        Scroll.contentSize = CGSize(width: view.frame.width, height: view.frame.height - ControlY(15))
        return Scroll
    }()
    
    lazy var LogInImageView:UIImageView = {
        let ImageView = UIImageView()
        ImageView.image = UIImage(named: "LogIn")
        ImageView.contentMode = .redraw
        return ImageView
    }()
    
    lazy var LogInLabel : UILabel = {
        let Label = UILabel()
        Label.textColor = LabelForeground
        Label.text = "WELCOME".localizable
        Label.textAlignment = .center
        Label.backgroundColor = .clear
        Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(27))
        return Label
    }()
    
    lazy var EmailTF : UITextField = {
        let tf = FloatingTF()
        tf.keyboardType = .emailAddress
        SetUpTF(tf: tf, Placeholder: "E-Mail".localizable)
        return tf
    }()
    

    lazy var PasswordTF : UITextField = {
        let tf = FloatingTF()
        tf.isSecureTextEntry = true
        SetUpTF(tf: tf, Placeholder: "Password".localizable)
        return tf
    }()
    

    func SetUpTF(tf:FloatingTF , Placeholder:String) {
        tf.tintColor = LogInColors
        tf.textColor = LogInColors
        tf.layer.cornerRadius = ControlHeight(19)
        tf.layer.borderWidth = ControlWidth(1)
        tf.layer.borderColor = #colorLiteral(red: 0.4233468771, green: 0.519071877, blue: 0.7063246369, alpha: 1)
        tf.Title.textColor = #colorLiteral(red: 0.4233468771, green: 0.519071877, blue: 0.7063246369, alpha: 1)
        tf.Title.textAlignment = .center
        tf.TitleError.textAlignment = .center
        tf.bottomLineLayer.isHidden = true
        tf.backgroundColor = BackgroundColor
        tf.textAlignment = .center
        tf.font = UIFont(name: "Campton-Light", size: ControlWidth(18))
        tf.attributedPlaceholder = NSAttributedString(string: Placeholder,
                                                      attributes: [NSAttributedString.Key.foregroundColor: LogInColors])
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: ControlWidth(15), height: tf.frame.height))
        tf.leftViewMode = .always
    }

    lazy var loginButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.titleLabel?.font = UIFont.init(name: "Campton-Light", size: ControlWidth(18))
        Button.setTitle("LOGIN".localizable.capitalized, for: .normal)
        Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.4233468771, green: 0.519071877, blue: 0.7063246369, alpha: 1)
        Button.contentHorizontalAlignment = .center
        Button.addTarget(self, action: #selector(ActionLogin), for: .touchUpInside)
        return Button
    }()

    static let NotificationSignOut = NSNotification.Name(rawValue: "SignOut")
    @objc func ActionLogin() {
    self.Alert.SetIndicator(Style: .load)

    guard let email = EmailTF.text else {return}
    guard let password = PasswordTF.text else {return}
    if email == "" && password == "" {
    self.Error(Err: "FillInInformationCorrectly".localizable)
    }else if isValidEmail(emailID: email) == false {
    self.Error(Err: "ErrorEmail".localizable)
    }else if (PasswordTF.text?.count)! < 6 {
    self.Error(Err: "ErrorPasswordCorrectly".localizable)
    }else{
            
    Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
    if let err = err {
    self.Error(Err: err.localizedDescription)
    return
    }
        
    if let uid = user?.user.uid {
    self.ActionLoginApi(uid: uid, email: email)
    }
    }
    }
    }
        
    
    @objc func TimeoutInterval() {
    if LogIn == false {
    do {
    try Auth.auth().signOut()
    self.Error(Err: "InternetNotAvailable".localizable)
    }catch let signOutErr {
    print("Failed to sign out:",signOutErr.localizedDescription)
    }
    }
    }
    
    func updateData(data:[String:Any]) {        
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: data)
    defaults.set(encodedData, forKey: "User")
    defaults.synchronize()
    
    self.EmailTF.text = ""
    self.PasswordTF.text = ""
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    self.navigationController?.popViewController(animated: true)
    NotificationCenter.default.post(name: LogInController.NotificationSignOut, object: nil)
    }
    }
    
    lazy var BackButton : UIButton = {
        let Button = UIButton(type: .system)
        let Image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: 15, left: 17, bottom: 15, right: 21))
        Button.setBackgroundImage(Image, for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.tintColor = .white
        Button.addTarget(self, action: #selector(ActionBack), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionBack() {
    self.navigationController?.popViewController(animated: true)
    }
    
    
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

    lazy var SignUpButton : UIButton = {
        let Button = UIButton(type: .system)
        AttributedString(AttributedString: NSAttributedString(string: "SignUp".localizable), button: Button)
        Button.addTarget(self, action: #selector(ActionSignUp), for: .touchUpInside)
        return Button
    }()

    @objc func ActionSignUp() {
    PresentByNavigation(ViewController: self , ToViewController: SignUpController())
    }
    
    lazy var ForgotPasswordButton : UIButton = {
        let Button = UIButton(type: .system)
        AttributedString(AttributedString: NSAttributedString(string: "ForgotPassword".localizable), button: Button)
        Button.addTarget(self, action: #selector(ActionForgotPassword), for: .touchUpInside)
        return Button
    }()

    @objc func ActionForgotPassword() {
    PresentByNavigation(ViewController: self, ToViewController: ResetPasswordController())
    }


    lazy var ContactUsButton : UIButton = {
        let Button = UIButton(type: .system)
        AttributedString(AttributedString: NSAttributedString(string: "CONTACTUS".localizable.capitalized), button: Button)
        Button.contentHorizontalAlignment = .left
        Button.addTarget(self, action: #selector(ActionContactUs), for: .touchUpInside)
        return Button
    }()


    @objc func ActionContactUs() {
    let Contact = ContactController()
    Contact.SignIn = false
    PresentByNavigation(ViewController: self, ToViewController: Contact)
    }
    
    private func AttributedString(AttributedString:NSAttributedString ,button:UIButton) {
    let textRange = NSMakeRange(0, AttributedString.length)
    let underlinedMessage = NSMutableAttributedString(attributedString: AttributedString)
    underlinedMessage.addAttribute(NSAttributedString.Key.underlineStyle,
    value:NSUnderlineStyle.single.rawValue, range: textRange)
    underlinedMessage.addAttributes([NSAttributedString.Key.foregroundColor: LogInColors], range: textRange)
    button.setAttributedTitle(underlinedMessage, for: .normal)
    button.titleLabel?.font = UIFont(name: "Campton-Light", size: ControlWidth(13))
    button.backgroundColor = .clear
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
extension LogInController {
    
    func ActionLoginApi(uid:String,email:String) {
    guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + GetLogInfo)"
    let lang = Locale.current.languageCode ?? ""
        
    let parameters = [
    "email": email,
    "uid": uid,
    "os": "IOS",
    "lang": lang
    ]
            
    perform(#selector(self.TimeoutInterval), with: self, afterDelay: 31)
    AlamofireCall(Url: api, HTTP: .put, parameters: parameters,encoding: JSONEncoding.default, Success: {}, Array: {_ in}) { (data) in
    self.LogIn = true
    self.updateData(data: data)
    } Err: { (err) in
    self.LogIn = false
    self.Error(Err: err)
    }
    }
    
}
