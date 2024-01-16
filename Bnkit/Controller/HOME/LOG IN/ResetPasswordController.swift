//
//  ResetPasswordController.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordController: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    }
    

    func SetUpItems() {
    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)
    
        
    ViewScroll.addSubview(TopBackView)
    ViewScroll.addSubview(EMailTF)
    ViewScroll.addSubview(ResetButton)
        
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(20), width: view.frame.width - ControlX(20), height: ControlHeight(50))
    EMailTF.frame = CGRect(x: ControlX(25), y: ControlY(200), width: view.frame.width - ControlX(50), height: ControlWidth(50))
    ResetButton.frame = CGRect(x: view.center.x - ControlWidth(60) , y: view.frame.maxY - ControlY(105), width: ControlWidth(120), height: ControlWidth(40))
    ResetButton.layer.cornerRadius = ResetButton.frame.height / 2
        
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
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.Space = 0
        View.textColor = LabelForeground
        View.FontSize = ControlWidth(30)
        View.text = "RESETPASSWORD".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var EMailTF : UITextField = {
        let tf = FloatingTF()
        tf.keyboardType = .emailAddress
        tf.attributedPlaceholder = NSAttributedString(string:"E-Mail".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
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
    self.Alert.SetIndicator(Style: .load)
    guard let email = EMailTF.text else {return}
    if isValidEmail(emailID: email) == false {
    Error(Err: "ErrorEmail".localizable)
    return
    }else{
    Auth.auth().sendPasswordReset(withEmail: email) { (err) in
    if let err = err {
    self.Error(Err: err.localizedDescription)
    return
    }else{
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    self.SetUpPopUp(text: "PleaseCheckYourEmail".localizable)
    self.EMailTF.text = ""
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
