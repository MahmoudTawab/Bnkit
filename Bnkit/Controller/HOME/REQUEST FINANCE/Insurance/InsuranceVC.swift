//
//  InsuranceVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/14/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class InsuranceVC: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    }
       
    fileprivate func SetUpItems() {
        
    let Space = ControlX(5)
    view.addSubview(TopBackView)
    view.addSubview(CarsButton)
    view.addSubview(lifeButton)
    view.addSubview(FirePropertyInsuranceButton)
    view.addSubview(MarinetransportButton)
    view.addSubview(MedicalButton)
    view.addSubview(SavingsNvestmentsButton)
    view.addSubview(AccidentHealthButton)
    view.addSubview(OtherButton)
        
    TopBackView.frame =  CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlWidth(20), height: ControlHeight(50))
                      
    CarsButton.frame = CGRect(x: 0, y: ControlY(170), width: (view.frame.width / 3) - (Space / 2), height: ControlWidth(122))
        
    lifeButton.frame = CGRect(x: CarsButton.frame.maxX + Space, y: CarsButton.frame.minY, width: CarsButton.frame.width, height: CarsButton.frame.height)

    FirePropertyInsuranceButton.frame = CGRect(x: lifeButton.frame.maxX + Space, y: CarsButton.frame.minY, width: CarsButton.frame.width, height: CarsButton.frame.height)
        
    MarinetransportButton.frame =  CGRect(x: 0, y: FirePropertyInsuranceButton.frame.maxY + Space, width: CarsButton.frame.width, height: CarsButton.frame.height)

    MedicalButton.frame =  CGRect(x: MarinetransportButton.frame.maxX + Space, y:  MarinetransportButton.frame.minY, width: CarsButton.frame.width, height: CarsButton.frame.height)

    AccidentHealthButton.frame = CGRect(x: 0, y: MarinetransportButton.frame.maxY + Space, width: CarsButton.frame.width, height: CarsButton.frame.height)
               
    OtherButton.frame = CGRect(x: AccidentHealthButton.frame.maxX + Space, y: AccidentHealthButton.frame.minY, width: CarsButton.frame.width, height: CarsButton.frame.height)
        
    SavingsNvestmentsButton.frame = CGRect(x: MedicalButton.frame.maxX + Space, y: MedicalButton.frame.minY, width: CarsButton.frame.width, height: ControlWidth(250))
    }
        
       lazy var TopBackView: TopView = {
           let View = TopView()
           View.textColor = #colorLiteral(red: 0.6638850226, green: 0.8910035829, blue: 0.8053803969, alpha: 1)
           View.Space = ControlHeight(3)
           View.FontSize = ControlWidth(30)
           View.text = "insurance".localizable
           View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
           return View
       }()
       
       @objc func ButtonAction() {
        self.navigationController?.popViewController(animated: true)
       }
           
       
       lazy var CarsButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 18
       SetUpButton(button: Button, Background: "group2367", Title: "Cars".localizable)
       return Button
       }()

       lazy var lifeButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 19
       SetUpButton(button: Button, Background: "group2368", Title: "life".localizable)
       return Button
       }()
    
       lazy var FirePropertyInsuranceButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 20
       SetUpButton(button: Button, Background: "group2369", Title: "FirePropertyInsurance".localizable)
       return Button
       }()
           
       lazy var MarinetransportButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 21
       SetUpButton(button: Button, Background: "group2370", Title: "marinetransport".localizable)
       return Button
       }()
        
       lazy var MedicalButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 22
       SetUpButton(button: Button, Background: "Group 2371", Title: "Medical".localizable)
       return Button
       }()

       lazy var SavingsNvestmentsButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 23
       SetUpButton(button: Button, Background: "group2372", Title: "SavingsNvestments".localizable)
       return Button
       }()
           
       lazy var AccidentHealthButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 24
       SetUpButton(button: Button, Background: "group2374", Title: "AccidentHealth".localizable)
       return Button
       }()

       lazy var OtherButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 25
       SetUpButton(button: Button, Background: "group2373", Title: "Other".localizable)
       return Button
       }()
       
       func SetUpButton(button:UIButton,Background:String,Title:String) {
       button.setTitleColor(.white, for: .normal)
       button.contentHorizontalAlignment = .left
       button.contentVerticalAlignment = .top
       button.titleLabel?.numberOfLines = 0
       button.layoutIfNeeded()
       button.setTitle(Title, for: .normal)
       button.subviews.first?.contentMode = .scaleAspectFill
       button.backgroundColor = .clear
       button.setBackgroundImage(UIImage(named: Background), for: .normal)
       button.titleLabel?.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(11.5))
       button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 15, bottom: 0, right: 0)
       button.addTarget(self, action: #selector(ActionAllButton(_:)), for: .touchUpInside)
       }

       @objc func ActionAllButton(_ button:UIButton) {
        if GetUserObject().uid != nil {
        let Investor = InvestorVC()
        guard let Text  = button.titleLabel?.text else {return}
        let new = Text.replacingOccurrences(of: "\n", with: " ")
        Investor.TopBackView.text = new
        Investor.IdAdd = button.tag
        Investor.reqId = 0
        Investor.SectorTypId = 2
        Investor.isUpdate = false
        PresentByNavigation(ViewController: self, ToViewController: Investor)
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
