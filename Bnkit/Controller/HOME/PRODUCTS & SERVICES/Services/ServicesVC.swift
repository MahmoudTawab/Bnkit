//
//  ServicesVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/24/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    }
                  

    func SetUpItems() {
    let Space = ControlX(5)
    view.addSubview(TopBackView)
    view.addSubview(InvestorButton)
    view.addSubview(StackVertical)
        
    TopBackView.frame =  CGRect(x: ControlX(10), y: ControlY(50), width: view.frame.width - ControlX(20), height: ControlHeight(50))
            
    let width = (view.frame.width / 3) - (Space / 2)
    InvestorButton.frame = CGRect(x: 0, y: TopBackView.frame.maxY + ControlY(100) , width: width, height: ControlWidth(380))
                    
    StackVertical.frame = CGRect(x: InvestorButton.frame.maxX + Space, y: InvestorButton.frame.minY, width: (view.frame.width - width) - Space, height: ControlWidth(380))
    }

    lazy var TopBackView: TopView = {
    let View = TopView()
    View.textColor = #colorLiteral(red: 0.7453938127, green: 0.8536149859, blue: 0.9157326818, alpha: 1)
    View.Space = ControlHeight(3)
    View.FontSize = ControlWidth(30)
    View.text = "SERVICES".localizable
    View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
    return View
    }()
        
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    

    lazy var InvestorButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2384", Title:"INVESTOR".localizable)
    Button.addTarget(self, action: #selector(ActionInvestor), for: .touchUpInside)
    return Button
    }()
    
    @objc func ActionInvestor() {
    if GetUserObject().uid != nil {
    let Investor = InvestorVC()
    Investor.TopBackView.text = "INVESTOR".localizable
    Investor.reqId = 0
    Investor.IdAdd = 0
    Investor.SectorTypId = 6
    Investor.isUpdate = false
    PresentByNavigation(ViewController: self, ToViewController: Investor)
    }else{
    Error(Err: "ErrorLogIn".localizable)
    }
    }
    
    lazy var PartnershipApplicant : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2272", Title: "PARTNERSHIPAPPLICANT".localizable)
    Button.addTarget(self, action: #selector(ActionPartnership), for: .touchUpInside)
    return Button
    }()
    
    @objc func ActionPartnership() {
    if GetUserObject().uid != nil {
    let PartnershipApplicant = PartnershipApplicantVC()
    PartnershipApplicant.reqId = 0
    PartnershipApplicant.isUpdate = false
    PresentByNavigation(ViewController: self, ToViewController: PartnershipApplicant)
    }else{
    Error(Err: "ErrorLogIn".localizable)
    }
    }

    lazy var AcquisitionApplicant : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2271", Title: "ACQUISITIONAPPLICANT".localizable)
    Button.addTarget(self, action: #selector(ActionAcquisition), for: .touchUpInside)
    return Button
    }()
    
    @objc func ActionAcquisition() {
    if GetUserObject().uid != nil {
    let AcquisitionApplicant = AcquisitionApplicantVC()
    AcquisitionApplicant.reqId = 0
    AcquisitionApplicant.isUpdate = false
    PresentByNavigation(ViewController: self, ToViewController: AcquisitionApplicant)
    }else{
    Error(Err: "ErrorLogIn".localizable)
    }
    }
    
    lazy var LegalFinancialButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2385", Title:"LEGALFINANCIALCONSULTANT".localizable)
    Button.addTarget(self, action: #selector(ActionLegalFinancial), for: .touchUpInside)
    return Button
    }()
    
    @objc func ActionLegalFinancial() {
    if GetUserObject().uid != nil {
    let Legal = LegalVC()
    Legal.reqId = 0
    Legal.isUpdate = false
    PresentByNavigation(ViewController: self, ToViewController: Legal)
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
        let Stack = UIStackView(arrangedSubviews: [PartnershipApplicant,AcquisitionApplicant,LegalFinancialButton])
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
