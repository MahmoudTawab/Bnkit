
//
//  SMEVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/13/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class SMEVC: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    }
           

    fileprivate func SetUpItems() {
            
    let Space = ControlX(5)
    view.addSubview(TopBackView)
    view.addSubview(SmallLoanButton)
    view.addSubview(BusinessLoanButton)
    view.addSubview(WorkingFinanceButton)
    view.addSubview(LeasingButton)
    view.addSubview(InsurancePolicyButton)
    view.addSubview(AccountDepositButton)
        
    TopBackView.frame =  CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlWidth(20), height: ControlHeight(50))
        
    SmallLoanButton.frame =  CGRect(x: 0, y: ControlY(170), width: (view.frame.width / 3) - (Space / 2), height: ControlWidth(250))
        
    BusinessLoanButton.frame = CGRect(x: SmallLoanButton.frame.maxX + Space, y: SmallLoanButton.frame.minY , width: SmallLoanButton.frame.width, height: ControlWidth(122))

    WorkingFinanceButton.frame = CGRect(x: BusinessLoanButton.frame.maxX + Space, y: SmallLoanButton.frame.minY , width: SmallLoanButton.frame.width, height: BusinessLoanButton.frame.height)

    LeasingButton.frame = CGRect(x: SmallLoanButton.frame.maxX + Space, y: BusinessLoanButton.frame.maxY + Space, width: (SmallLoanButton.frame.width * 2) + Space, height: BusinessLoanButton.frame.height)

    InsurancePolicyButton.frame = CGRect(x: 0, y: LeasingButton.frame.maxY + Space, width: LeasingButton.frame.width , height: BusinessLoanButton.frame.height)

    AccountDepositButton.frame = CGRect(x: InsurancePolicyButton.frame.maxX + Space, y: InsurancePolicyButton.frame.minY, width: SmallLoanButton.frame.width, height: BusinessLoanButton.frame.height)
        
    }
           
       lazy var TopBackView: TopView = {
           let View = TopView()
           View.textColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
           View.Space = ControlHeight(3)
           View.FontSize = ControlWidth(30)
           View.text = "SME&MICRO".localizable
           View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
           return View
       }()
       
       @objc func ButtonAction() {
        self.navigationController?.popViewController(animated: true)
       }
           
       lazy var SmallLoanButton : UIButton = {
       let Button = UIButton(type: .system)
       Button.tag = 26
       SetUpButton(button: Button, Background: "Group1", Title: "SMALLBUSINESS".localizable)
       return Button
       }()
        
       lazy var BusinessLoanButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 27
       SetUpButton(button: Button, Background: "Group2", Title: "SMALLBUSINESSOWNER".localizable)
       return Button
       }()

       lazy var WorkingFinanceButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 28
       SetUpButton(button: Button, Background: "Group3", Title: "WORKINGCAPITALFINANCE".localizable)
       return Button
       }()
       
       lazy var LeasingButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 29
       SetUpButton(button: Button, Background: "Group4", Title: "LEASING".localizable)
       return Button
       }()
    
       lazy var InsurancePolicyButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 30
       SetUpButton(button: Button, Background: "Group5", Title: "INSURANCEPOLICY".localizable)
       return Button
       }()

       lazy var AccountDepositButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 31
       SetUpButton(button: Button, Background: "Group6", Title: "ACCOUNTS&DEPOSIT".localizable)
       return Button
       }()
    
       func SetUpButton(button:UIButton,Background:String,Title:String) {
       button.setTitleColor(.white, for: .normal)
       button.contentHorizontalAlignment = .left
       button.contentVerticalAlignment = .top
       button.titleLabel?.numberOfLines = 0
       button.layoutIfNeeded()
       button.setTitle(Title, for: .normal)
       button.backgroundColor = .clear
       button.subviews.first?.contentMode = .scaleAspectFill
       button.setBackgroundImage(UIImage(named: Background), for: .normal)
       button.titleLabel?.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(11.5))
       button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 13, bottom: 0, right: 0)
       button.addTarget(self, action: #selector(ActionAllButton(_:)), for: .touchUpInside)
       }
    
       @objc func ActionAllButton(_ button:UIButton) {
        if GetUserObject().uid != nil {
        let RequestSme = AddRequestSme()
        RequestSme.IdAdd = button.tag
        RequestSme.reqId = 0
        RequestSme.isUpdate = false
        PresentByNavigation(ViewController: self, ToViewController: RequestSme)
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
}
