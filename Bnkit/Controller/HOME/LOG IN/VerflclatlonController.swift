//
//  VerflclatlonController.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseStorage
import FirebaseAuth
import CoreData

class VerflclatlonController: UIViewController {

    var SizeFont = CGFloat()
    var TFTop = CGFloat()
    var SignUp:SignUpController?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpItems()
        StartTimer()
    }
    

    func SetUpItems() {
            
    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)
    
    ViewScroll.addSubview(VerflclatlonLabel)
    ViewScroll.addSubview(VerflclatlonTF)
    ViewScroll.addSubview(Labeltimer)
    ViewScroll.addSubview(LeftButton)
    ViewScroll.addSubview(RightButton)
        
    VerflclatlonLabel.frame = CGRect(x: ControlX(20), y: ControlY(10),width: view.frame.width - ControlX(40), height: ControlWidth(42))
        
    LeftButton.frame = CGRect(x: ControlX(20), y: view.frame.maxY - ControlWidth(120), width: ControlWidth(45), height: ControlWidth(60))
        
    VerflclatlonTF.frame = CGRect(x: ControlX(20),y: VerflclatlonLabel.frame.maxY + ControlY(80),width: view.frame.width - ControlX(40), height: ControlWidth(50))
        
    Labeltimer.frame = CGRect(x: ControlX(40), y: VerflclatlonTF.frame.maxY + ControlY(120), width: view.frame.width - ControlX(80), height: ControlWidth(20))
        
    RightButton.frame = CGRect(x: view.frame.maxX - ControlWidth(65), y: LeftButton.frame.minY, width: ControlWidth(45), height: ControlWidth(60))
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
        
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(0)
    }
    
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.backgroundColor = .clear
        Scroll.bounces = true
        Scroll.keyboardDismissMode = .interactive
        return Scroll
    }()
    
    lazy var VerflclatlonLabel : UILabel = {
        let Label = UILabel()
        Label.text = "VERFICIATION".localizable
        Label.backgroundColor = .clear
        Label.textColor = LabelForeground
        Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(29))
        return Label
    }()

    lazy var VerflclatlonTF : UITextField = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "VERFICIATION".localizable.capitalized, attributes:[.foregroundColor: LabelForeground])
        tf.keyboardType = .numberPad
        return tf
    }()
    

    lazy var Labeltimer : UILabel = {
        let Label = UILabel()
        Label.backgroundColor = .clear
        Label.isUserInteractionEnabled = false
        Label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LabelTimerAction)))
        return Label
    }()
    
    @objc func LabelTimerAction() {
    ReSendSms()
    }

    var timer = Timer()
    var newTimer = 120
    @objc func ActionLabeltimer()  {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
        
    let Timer = "lang".localizable == "en" ? "\(timeFormatted(newTimer))" : "\(timeFormatted(newTimer))".NumAR()
    let Text = "Wait".localizable + " " + Timer + " " + "Secs to Resend SMS".localizable
    newTimer -= 1
    
    let attributedString = NSMutableAttributedString(string: Text, attributes: [
    .font: UIFont(name: "Campton-Light", size: ControlWidth(16)) ?? UIFont.systemFont(ofSize: ControlWidth(16)),
    .foregroundColor: LabelForeground,
    .paragraphStyle:style,
    .underlineStyle: NSUnderlineStyle.single.rawValue
    ])

    Labeltimer.attributedText = attributedString
    Labeltimer.isUserInteractionEnabled = false
    if newTimer < -1 {
        
    let Text = "ResendCode".localizable
    let attributedString = NSMutableAttributedString(string: Text, attributes: [
    .font: UIFont(name: "Campton-Light", size: ControlWidth(16)) ?? UIFont.systemFont(ofSize: ControlWidth(16)),
    .foregroundColor: LabelForeground,
    .paragraphStyle:style,
    .underlineStyle: NSUnderlineStyle.single.rawValue
    ])

    Labeltimer.attributedText = attributedString
    Labeltimer.isUserInteractionEnabled = true
    timer.invalidate()
    }
    }
    

    
    func StartTimer() {
    newTimer = 120
    timer = Timer.scheduledTimer(timeInterval: 1 , target: self , selector:  #selector(ActionLabeltimer) , userInfo: nil , repeats:  true)
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
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
    
    lazy var LeftButton : UIButton = {
        let Button = UIButton(type: .custom)
        let image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        Button.tintColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.backgroundColor = .clear
        Button.setBackgroundImage(image, for: .normal)
        Button.addTarget(self, action: #selector(ActionLeft), for: .touchUpInside)
        return Button
    }()
    

    @objc func ActionLeft() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var RightButton : UIButton = {
        let Button = UIButton(type: .custom)
        let image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        Button.tintColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.backgroundColor = .clear
        Button.setBackgroundImage(image, for: .normal)
        Button.transform = CGAffineTransform(rotationAngle: .pi)
        Button.addTarget(self, action: #selector(ActionRight), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionRight() {

    guard let SignUp = SignUp else{return}
    guard let Phone = SignUp.PhoneNoTF.text else{return}
    let PhoneNew = Phone.replacingOccurrences(of: " ", with: "")

    if VerflclatlonTF.text != SignUp.verification {
    self.Error(Err: "ErrorVerification".localizable)
    return
    }else{
        
    self.Alert.SetIndicator(Style: .load)
    if SignUp.FrontIdImage.image?.pngData() == nil && SignUp.BackIdImage.image?.pngData() == nil {
    Create(frontId: "", backId: "")
    return
    }else if SignUp.FrontIdImage.image?.pngData() != nil && SignUp.BackIdImage.image?.pngData() == nil {
    if let front = SignUp.FrontIdImage.image?.pngData() {
    Storag(child: ["DataUser",PhoneNew,"Front"], image: front) { (url) in
    self.Create(frontId: url, backId: "")
    } Err: { (Err) in
    self.Error(Err: Err)
    }
    }
    return
    }else if SignUp.BackIdImage.image?.pngData() != nil && SignUp.FrontIdImage.image?.pngData() == nil {
    if let back = SignUp.BackIdImage.image?.pngData() {
    Storag(child: ["DataUser",PhoneNew,"Back"], image: back) { (url) in
    self.Create(frontId: "", backId: url)
    } Err: { (Err) in
    self.Error(Err: Err)
    }
    }
    return
    }else{
    if let back = SignUp.BackIdImage.image?.pngData() , let front = SignUp.FrontIdImage.image?.pngData() {
    Storag(child: ["DataUser",PhoneNew,"Front"], image: front) { (frontUrl) in
    Storag(child: ["DataUser",PhoneNew,"Back"], image: back) { (backUrl) in
    self.Create(frontId: frontUrl, backId: backUrl)
    } Err: { (Err) in
    self.Error(Err: Err)
    }
    } Err: { (Err) in
    self.Error(Err: Err)
    }
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
extension VerflclatlonController {
    
    func ReSendSms() {
    self.Alert.SetIndicator(Style: .load)
    guard let url = defaults.string(forKey: "API") else{return}
    guard let SignUp = SignUp else{return}
    guard let Phone = SignUp.PhoneNoTF.text else {return}
    let PhoneNew = Phone.replacingOccurrences(of: " ", with: "")
    let api = "\(url + ReSendSmsAsync)"
        
    guard let Url = URL(string:api) else {return}
    var components = URLComponents(url: Url, resolvingAgainstBaseURL: false)!
    components.queryItems = [URLQueryItem(name: "sysToken", value: SysTokenReSendSms),
                             URLQueryItem(name: "phone", value: PhoneNew),
                             URLQueryItem(name: "verification", value: SignUp.verification)]
        
    guard let ComponentsUrl = components.url?.absoluteString else {return}
    AlamofireCall(Url: ComponentsUrl, HTTP: .get, parameters: nil) {
    self.Alert.SetIndicator(Style: .success)
    self.StartTimer()
    } Err: { error in
    self.Error(Err:error)
    }
    }
    
    
    func Create(frontId:String,backId:String)  {
    guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + CreateAccount)"

    guard let SignUp = SignUp else{return}
    guard let Phone = SignUp.PhoneNoTF.text else {return}
    let PhoneNew = Phone.replacingOccurrences(of: " ", with: "")
    guard let firstName = SignUp.FirstNameTF.text else {return}
    guard let lastName = SignUp.LastNameTF.text else {return}
    guard let email = SignUp.EmailTF.text else {return}
    guard let password = SignUp.PasswordTF.text else {return}
    guard let id = SignUp.IDNoTF.text else {return}
    let dateformat = DateFormatter()
    dateformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
    let parameters: [String: Any] = [
    "sysToken": SysTokenCreateAccount,
    "email": email,
    "password": password,
    "phone": PhoneNew,
    "firsName": firstName,
    "lastName": lastName,
    "personalId": id,
    "frontIdPpath": frontId,
    "backIdPath": backId,
    "photoPath": "",
    "birth": dateformat.string(from: Date()),
    "lang": Locale.current.languageCode ?? "en"
    ]
      
    AlamofireCall(Url: api, HTTP: .post, parameters: parameters,encoding: JSONEncoding.default, Success: {}, Array: {_ in}) { (data) in
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: data)
    defaults.set(encodedData, forKey: "User")
    defaults.synchronize()
        
    Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
    if let err = err {
        
    self.Error(Err: err.localizedDescription)
    return
    }
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {Success()}
    }
    } Err: { (err) in
    self.Error(Err: err)
    }
    }
    
}
