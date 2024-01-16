//
//  ChangePasswordVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/9/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth

class ChangePasswordVC: UIViewController, UIScrollViewDelegate {
    
    var SizeFont = CGFloat()
    var ResetButtonY = CGFloat()
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
    }
    

    func SetUpItems() {
        
    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)
        
    ViewScroll.addSubview(TopBackView)
    ViewScroll.addSubview(ResetButton)
        
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(20), width: view.frame.width - ControlX(20), height: ControlHeight(50))
        
    let StackVertical = UIStackView(arrangedSubviews: [OldPasswordTF,NewPasswordTF,ConfirmPasswordTF])
    StackVertical.axis = .vertical
    StackVertical.spacing = ControlHeight(45)
    StackVertical.distribution = .fillEqually
    StackVertical.backgroundColor = .clear
    ViewScroll.addSubview(StackVertical)
    StackVertical.frame = CGRect(x: ControlX(25), y: TopBackView.frame.maxY + ControlY(75), width: view.frame.width - ControlX(50), height: ControlWidth(210))
        
        
    ResetButton.frame = CGRect(x: view.center.x - ControlWidth(60), y: view.frame.height - ControlWidth(90), width: ControlWidth(120), height: ControlWidth(40))
    ResetButton.layer.cornerRadius = ResetButton.frame.height / 2
        
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(0)
    }
    
    
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.backgroundColor = .clear
        Scroll.delegate = self
        Scroll.bounces = true
        Scroll.keyboardDismissMode = .interactive
        return Scroll
    }()
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = LabelForeground
        View.Space = ControlHeight(4)
        View.FontSize = ControlWidth(30)
        View.text = "CHANGEPASSWORD".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var OldPasswordTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "OldPassword".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var NewPasswordTF : UITextField = {
        let tf = FloatingTF()
        tf.isSecureTextEntry = true
        tf.attributedPlaceholder = NSAttributedString(string: "NewPassword".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var ConfirmPasswordTF : FloatingTF = {
        let tf = FloatingTF()
        tf.isSecureTextEntry = true
        tf.attributedPlaceholder = NSAttributedString(string: "ConfirmNewPassword".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.clearButtonMode = .never
        tf.addTarget(self, action: #selector(PasswordConfirm), for: .editingChanged)
        return tf
    }()
    
    var Successfully = false
    let image1 = UIImage(named: "group272")?.withInset(UIEdgeInsets(top: ControlY(2), left: ControlX(4), bottom: ControlY(2), right: ControlX(4)))
        
    let image2 = UIImage(named: "group269")?.withInset(UIEdgeInsets(top: ControlY(2), left: ControlX(4), bottom: ControlY(2), right: ControlX(4)))
    @objc func PasswordConfirm() {
    if (ConfirmPasswordTF.text?.count)! > 0 {
    ConfirmPasswordTF.SetUpIcon(LeftOrRight: false)
    if ConfirmPasswordTF.text == NewPasswordTF.text {
    ConfirmPasswordTF.Icon.setBackgroundImage(image1, for: .normal)
    Successfully = true
    }else{
    ConfirmPasswordTF.Icon.setBackgroundImage(image2, for: .normal)
    Successfully = false
    }
    ConfirmPasswordTF.Icon.transform = .identity
    }else{
    ConfirmPasswordTF.Icon.removeFromSuperview()
    }
    }

    lazy var ResetButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.titleLabel?.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(18))
        Button.setTitle("RESET".localizable, for: .normal)
        Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.titleLabel?.textAlignment = .center
        Button.addTarget(self, action: #selector(ActionReset), for: .touchUpInside)
        return Button
    }()
    
    
    @objc func ActionReset() {
    guard let OldPassword = self.OldPasswordTF.text else {return}
    guard let NewPassword = self.NewPasswordTF.text else {return}
    guard let ConfirmPassword = self.ConfirmPasswordTF.text else {return}
    guard let email = Auth.auth().currentUser?.email else {return}
    let user = Auth.auth().currentUser
    
    if NewPassword.count < 6 || ConfirmPassword.count < 6 || Successfully == false {
    self.SetUpPopUp(text: "ErrorPasswordCorrectly".localizable)
    return
    }else{
    self.Alert.SetIndicator(Style: .load)
    }
        
    let credential = EmailAuthProvider.credential(withEmail: email, password: OldPassword)
    user?.reauthenticate(with: credential, completion: { (Auth, err) in
    if let err = err {
    self.Error(Err: err.localizedDescription)
    return
    }
        
    user?.updatePassword(to: ConfirmPassword, completion: { (err) in
    if let err = err {
    self.Error(Err: err.localizedDescription)
    return
    }
        
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {Success()}
    })
    })
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
    
    lazy var Alert:AlertView = {
        let View = AlertView()
        View.alpha = 0
        View.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return View
    }()
}
