//
//  PersonalVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/15/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class PersonalVC: UIViewController, UIScrollViewDelegate  {
    
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpAllButton()
    }

    func SetUpAllButton() {
    
    view.addSubview(TopBackView)
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlWidth(20), height: ControlHeight(50))
        
    view.addSubview(ViewScroll)
    ViewScroll.frame = CGRect(x: 0, y: ControlY(100), width: view.frame.width , height: view.frame.height - ControlHeight(100))
        
     let Space = ControlX(5)
     ViewScroll.addSubview(CashLoanButton)
     ViewScroll.addSubview(NewCarButton)
     ViewScroll.addSubview(USEDCarButton)
     ViewScroll.addSubview(EstateLoanButton)
     ViewScroll.addSubview(WeddingDayButton)
     ViewScroll.addSubview(EstateFinishingsButton)
     ViewScroll.addSubview(MedicalServicesButton)
     ViewScroll.addSubview(TourismAirlineButton)
     ViewScroll.addSubview(DoctorLoanButton)
     ViewScroll.addSubview(ClubMembershipButton)
     ViewScroll.addSubview(EducationLoanButton)
     ViewScroll.addSubview(LeasingButton)
     ViewScroll.addSubview(DurableGoodsButton)
     ViewScroll.addSubview(CreditCardsButton)
     ViewScroll.addSubview(AccountDepositButton)
     ViewScroll.addSubview(OverdraftButton)
     ViewScroll.addSubview(InsurancePolicyButton)
        
    CashLoanButton.frame = CGRect(x: 0, y: ControlX(20), width: (view.frame.width / 3) - (Space / 2), height: ControlWidth(125))
        
    NewCarButton.frame = CGRect(x: CashLoanButton.frame.maxX + Space, y: ControlX(20), width: CashLoanButton.frame.width, height: ControlWidth(256))
        
    USEDCarButton.frame = CGRect(x: NewCarButton.frame.maxX + Space, y: ControlX(20), width: CashLoanButton.frame.width, height: CashLoanButton.frame.height)
        
    EstateLoanButton.frame = CGRect(x: 0, y: CashLoanButton.frame.maxY + Space, width: CashLoanButton.frame.width, height: CashLoanButton.frame.height)
        
    WeddingDayButton.frame = CGRect(x: NewCarButton.frame.maxX + Space, y: USEDCarButton.frame.maxY + Space, width: CashLoanButton.frame.width, height: CashLoanButton.frame.height)
        
    EstateFinishingsButton.frame = CGRect(x: 0, y: EstateLoanButton.frame.maxY + Space, width: CashLoanButton.frame.width, height: NewCarButton.frame.height)
        
    MedicalServicesButton.frame = CGRect(x: EstateFinishingsButton.frame.maxX + Space, y: EstateFinishingsButton.frame.minY, width: (CashLoanButton.frame.width * 2) + Space, height: CashLoanButton.frame.height)
        
    TourismAirlineButton.frame =  CGRect(x: EstateFinishingsButton.frame.maxX + Space, y: MedicalServicesButton.frame.maxY + Space, width: CashLoanButton.frame.width, height: CashLoanButton.frame.height)
        
    DoctorLoanButton.frame = CGRect(x: TourismAirlineButton.frame.maxX + Space, y: MedicalServicesButton.frame.maxY + Space, width: CashLoanButton.frame.width, height: CashLoanButton.frame.height)
        
    ClubMembershipButton.frame = CGRect(x: 0, y: EstateFinishingsButton.frame.maxY + Space, width: MedicalServicesButton.frame.width, height: CashLoanButton.frame.height)
        
    EducationLoanButton.frame = CGRect(x: ClubMembershipButton.frame.maxX + Space, y: ClubMembershipButton.frame.minY, width: CashLoanButton.frame.width, height: CashLoanButton.frame.height)
        
    LeasingButton.frame = CGRect(x: 0, y: ClubMembershipButton.frame.maxY + Space, width: CashLoanButton.frame.width, height: NewCarButton.frame.height)

   DurableGoodsButton.frame = CGRect(x: LeasingButton.frame.maxX + Space, y: LeasingButton.frame.minY, width: CashLoanButton.frame.width, height: CashLoanButton.frame.height)
        
   CreditCardsButton.frame = CGRect(x: DurableGoodsButton.frame.maxX + Space, y: LeasingButton.frame.minY, width: CashLoanButton.frame.width, height: CashLoanButton.frame.height)
        
   AccountDepositButton.frame = CGRect(x: LeasingButton.frame.maxX + Space, y: DurableGoodsButton.frame.maxY + Space, width: CashLoanButton.frame.width, height: CashLoanButton.frame.height)
        
   OverdraftButton.frame = CGRect(x: 0, y: LeasingButton.frame.maxY + Space, width: MedicalServicesButton.frame.width, height: CashLoanButton.frame.height)
        
   InsurancePolicyButton.frame = CGRect(x: AccountDepositButton.frame.maxX + Space, y: AccountDepositButton.frame.minY, width: CashLoanButton.frame.width, height: NewCarButton.frame.height)
    
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(ControlWidth(30))
   }

    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.Space = 0
        View.textColor = #colorLiteral(red: 0.7453938127, green: 0.8536149859, blue: 0.9157326818, alpha: 1)
        View.FontSize = ControlWidth(30)
        View.text = "PERSONAL".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.backgroundColor = .clear
        Scroll.showsVerticalScrollIndicator = false
        Scroll.delegate = self
        Scroll.translatesAutoresizingMaskIntoConstraints = false
        Scroll.bounces = true
        return Scroll
    }()
    
    lazy var CashLoanButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 1
       SetUpButton(button: Button, Background: "Personal1", Title: "CASHLOAN".localizable)
       return Button
       }()

       lazy var NewCarButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 2
       SetUpButton(button: Button, Background: "Personal2", Title: "NEWCARLOAN".localizable)
       return Button
       }()
          
    
       lazy var USEDCarButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 3
       SetUpButton(button: Button, Background: "Personal3", Title: "USEDCARLOAN".localizable)
       return Button
       }()
           
       
       lazy var EstateLoanButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 4
       SetUpButton(button: Button, Background: "Personal4", Title: "REALESTATELOAN".localizable)
       return Button
       }()
           
    
       lazy var WeddingDayButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 5
       SetUpButton(button: Button, Background: "Personal5", Title: "WEDDINGDAY".localizable)
       return Button
       }()


       lazy var EstateFinishingsButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 6
       SetUpButton(button: Button, Background: "Personal6", Title: "REALESTATEFINISHINGS".localizable)
       return Button
       }()
           
    
       lazy var MedicalServicesButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 7
        SetUpButton(button: Button, Background: "Personal7", Title: "MEDICALSERVICES".localizable)
       return Button
       }()
 
    
      lazy var TourismAirlineButton : UIButton = {
      let Button = UIButton(type: .system)
        Button.tag = 8
      SetUpButton(button: Button, Background: "Personal8", Title: "TOURISMAIRLINETICKETS".localizable)
      return Button
      }()
          

       lazy var DoctorLoanButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 9
       SetUpButton(button: Button, Background: "Personal9", Title: "DOCTORLOAN".localizable)
       return Button
       }()
 
       lazy var ClubMembershipButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 10
       SetUpButton(button: Button, Background: "Personal10", Title: "CLUBMEMBERSHIP".localizable)
       return Button
       }()


       lazy var EducationLoanButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 11
       SetUpButton(button: Button, Background: "Personal11", Title: "EDUCATIONLOAN".localizable)
       return Button
       }()
           
    
       lazy var LeasingButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 12
       SetUpButton(button: Button, Background: "Personal12", Title: "LEASING".localizable)
       return Button
       }()
           
    
       lazy var DurableGoodsButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 13
       SetUpButton(button: Button, Background: "Personal13", Title: "DURABLEGOODS".localizable)
       return Button
       }()
            

       lazy var CreditCardsButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 14
       SetUpButton(button: Button, Background: "Personal14", Title: "CREDITCARDS".localizable)
       return Button
       }()
           
    
       lazy var AccountDepositButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 15
       SetUpButton(button: Button, Background: "Group6", Title: "ACCOUNTS&DEPOSIT".localizable)
       return Button
       }()
             
       lazy var InsurancePolicyButton : UIButton = {
       let Button = UIButton(type: .system)
        Button.tag = 16
       SetUpButton(button: Button, Background: "Personal17", Title: "INSURANCEPOLICY".localizable)
       return Button
       }()
    
      lazy var OverdraftButton : UIButton = {
      let Button = UIButton(type: .system)
        Button.tag = 17
      SetUpButton(button: Button, Background: "Personal16", Title: "OVERDRAFT".localizable)
      return Button
      }()

    
    func SetUpButton(button:UIButton,Background:String,Title:String) {
       button.setTitleColor(.white, for: .normal)
       button.contentHorizontalAlignment = .left
       button.contentVerticalAlignment = .top
       button.titleLabel?.numberOfLines = 0
       button.setTitle(Title, for: .normal)
       button.backgroundColor = .clear
       button.setBackgroundImage(UIImage(named: Background), for: .normal)
       button.titleLabel?.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(11.5))
       button.contentEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 0, right: 0)
       button.layoutIfNeeded()
       button.subviews.first?.contentMode = .scaleAspectFill
       button.addTarget(self, action: #selector(ActionAllButton(_:)), for: .touchUpInside)
    }
    

    @objc func ActionAllButton(_ button:UIButton) {
        let PersonalDetails = PersonalDetailsVC()
        guard let Text  = button.titleLabel?.text else {return}
        PersonalDetails.TopBackView.text = Text
        let new = Text.replacingOccurrences(of: "\n", with: " ")
        PersonalDetails.TopButton.setTitle("⇡\(new)⇡", for: .normal)
        PersonalDetails.Id = button.tag
        PresentByNavigation(ViewController: self, ToViewController: PersonalDetails)
    }
}

