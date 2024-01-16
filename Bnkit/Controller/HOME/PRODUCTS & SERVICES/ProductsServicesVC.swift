//
//  ProductsServicesVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/24/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class ProductsServicesVC: UIViewController {
    
   override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpItems()
    }

    func SetUpItems() {
    let Space = ControlX(5)
    view.addSubview(TopBackView)
    view.addSubview(POSButton)
    view.addSubview(StackVertical)

        
    TopBackView.frame =  CGRect(x: ControlX(10), y: ControlY(50), width: view.frame.width - ControlX(20), height: ControlHeight(50))
        
    let width = (view.frame.width / 3) - (Space / 2)
    POSButton.frame = CGRect(x: view.frame.maxX - width, y: TopBackView.frame.maxY + ControlY(100), width: width, height: ControlWidth(380))
                
    StackVertical.frame = CGRect(x: 0, y:  POSButton.frame.minY , width: (view.frame.width - POSButton.frame.width) - Space, height: ControlWidth(380))
    }

    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = PersonalDetailText
        View.Button.tintColor = #colorLiteral(red: 0.6326062679, green: 0.8368911147, blue: 0.7435064912, alpha: 1)
        View.Space = ControlHeight(3)
        View.FontSize = ControlWidth(30)
        View.text = "PRODUCTS & SERVICES".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }

    lazy var ServicesButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2545", Title:"SERVICES".localizable)
    Button.addTarget(self, action: #selector(ActionServices), for: .touchUpInside)
    return Button
    }()
    
    @objc func ActionServices() {
    PresentByNavigation(ViewController: self, ToViewController: ServicesVC())
    }
    
    lazy var ProductsButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2546", Title:"PRODUCTS".localizable)
    Button.addTarget(self, action: #selector(ActionProducts), for: .touchUpInside)
    return Button
    }()
    
    @objc func ActionProducts() {
    let Controller = RequestFlnanceVC()
    Controller.ProductsServices = self
    Controller.TopBackView.text = "PRODUCTS".localizable
    Controller.TopBackView.textColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
    PresentByNavigation(ViewController: self, ToViewController: Controller)
    }
        
    
    lazy var IScoreButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2547", Title:"I-SCORE".localizable)
    Button.addTarget(self, action: #selector(ActionIScore), for: .touchUpInside)
    return Button
    }()
    
    @objc func ActionIScore() {
    if GetUserObject().uid != nil {
    let IScore = IScoreVC()
    IScore.reqId = 0
    IScore.isUpdate = false
    IScore.isValidNumber = false
    PresentByNavigation(ViewController: self, ToViewController: IScore)
    }else{
    Error(Err: "ErrorLogIn".localizable)
    }
    }
    
    lazy var POSButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2507", Title:"POS".localizable)
    Button.addTarget(self, action: #selector(ActionPOS), for: .touchUpInside)
    return Button
    }()
    
    @objc func ActionPOS() {
    if GetUserObject().uid != nil {
    let Pos = PosVC()
    Pos.reqId = 0
    Pos.isUpdate = false
    Pos.isValidNumber = false
    PresentByNavigation(ViewController: self, ToViewController: Pos)
    }else{
    Error(Err: "ErrorLogIn".localizable)
    }
    }
    
    func Error(Err:String) {
    let PopUp = PopUpView()
    PopUp.text = Err
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = false
    PopUp.OkeyButton.addTarget(self, action: #selector(GoToLogin), for: .touchUpInside)
    Present(ViewController: self, ToViewController: PopUp)
    }
    
    @objc func GoToLogin() {
    PresentByNavigation(ViewController: self, ToViewController: LogInController())
    }
    
    lazy var StackVertical : UIStackView = {
        let Stack = UIStackView(arrangedSubviews: [ServicesButton,ProductsButton,IScoreButton])
        Stack.axis = .vertical
        Stack.spacing = ControlX(5)
        Stack.distribution = .fillEqually
        Stack.alignment = .fill
        Stack.backgroundColor = .clear
        return Stack
    }()

    func SetUpButton(button:UIButton,Background:String,Title:String) {
    button.setTitleColor(.white, for: .normal)
    button.contentHorizontalAlignment = .left
    button.contentVerticalAlignment = .top
    button.titleLabel?.numberOfLines = 0
    button.layoutIfNeeded()
    button.backgroundColor = .clear
    button.setTitle(Title, for: .normal)
    button.subviews.first?.contentMode = .scaleAspectFill
    button.setBackgroundImage(UIImage(named: Background), for: .normal)
    button.titleLabel?.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(11.5))
    button.contentEdgeInsets = UIEdgeInsets(top: 13, left: 15, bottom: 0, right: 0)
    }

}
