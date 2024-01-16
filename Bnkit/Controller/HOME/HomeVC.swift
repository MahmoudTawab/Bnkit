
//
//  HomeVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/4/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController  {
    
    var Company:CompanyInfo?
    var SettIngs:SettIngsVC?
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    NotificationCenter.default.addObserver(self, selector: #selector(ifUserConnected), name: LogInController.NotificationSignOut , object: nil)

    SetUpItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    ifUserConnected()
    }
    
    @objc func ifUserConnected() {
    if GetUserObject().phone == nil {
    HomeLabel.text = "HOME".localizable
    HomeLabel.textColor = LabelForeground
    loginButton.setTitle("LOGIN".localizable, for: .normal)
    tabBarController?.tabBar.isHidden = true
    ViewScroll.updateContentViewSize(ControlWidth(30))
    do {
    try Auth.auth().signOut()
    }catch let signOutErr {
    print("Failed to sign out:",signOutErr.localizedDescription)
    }
    }else{
    if let first = GetUserObject().firsName , let last = GetUserObject().lastName {
    HomeLabel.textColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
    HomeLabel.text = "\("WELCOME".localizable),\n\(first.uppercased()),\(last.uppercased())"
    loginButton.setTitle("PROFILE".localizable, for: .normal)
    tabBarController?.tabBar.isHidden = false
    ViewScroll.updateContentViewSize(ControlWidth(40))
    }
    }
        
        
    LoadCompanyInfo()
    // MARK: - ViewScroll contentSize height
    }
    
    fileprivate func SetUpItems() {
        
    let Space = ControlX(5)
    view.addSubview(HomeLabel)
        
    view.addSubview(ViewScroll)
    ViewScroll.frame = CGRect(x: 0, y: ControlY(105), width: view.frame.width, height: view.frame.height - ControlHeight(90))
    
    ViewScroll.addSubview(loginButton)
    ViewScroll.addSubview(RequestFinanceButton)
    ViewScroll.addSubview(OffersButton)
    ViewScroll.addSubview(FullWebsiteButton)
    ViewScroll.addSubview(ProductsServicesButton)
    ViewScroll.addSubview(CalculatorButton)
    ViewScroll.addSubview(AboutUsButton)
    ViewScroll.addSubview(InvestmentLoanButton)
        
    ViewScroll.addSubview(NewsUpdatesButton)
    ViewScroll.addSubview(MobadraButton)
        
    HomeLabel.frame = CGRect(x: ControlX(25), y: ControlY(15), width: view.frame.width - ControlWidth(50), height: ControlHeight(95))
        
    loginButton.frame = CGRect(x: 0, y: 0, width: (view.frame.width / 3) - (Space / 2), height: ControlWidth(242))
            
    RequestFinanceButton.frame = CGRect(x: loginButton.frame.maxX + Space, y: 0, width: loginButton.frame.width, height: ControlWidth(118))

    OffersButton.frame = CGRect(x: RequestFinanceButton.frame.maxX + Space, y: 0, width: loginButton.frame.width, height: RequestFinanceButton.frame.height)

    FullWebsiteButton.frame = CGRect(x: loginButton.frame.maxX + Space, y: loginButton.frame.maxY - RequestFinanceButton.frame.height, width: (loginButton.frame.width * 2) + Space, height: RequestFinanceButton.frame.height)
        
    ProductsServicesButton.frame = CGRect(x: 0, y: loginButton.frame.maxY + Space, width: (loginButton.frame.width * 2) + Space, height: RequestFinanceButton.frame.height)
        
    CalculatorButton.frame = CGRect(x: ProductsServicesButton.frame.maxX + Space, y: ProductsServicesButton.frame.minY , width: loginButton.frame.width, height: RequestFinanceButton.frame.height)
        
    AboutUsButton.frame = CGRect(x: 0, y: CalculatorButton.frame.maxY + Space, width: loginButton.frame.width, height: RequestFinanceButton.frame.height)
        
    InvestmentLoanButton.frame = CGRect(x: AboutUsButton.frame.maxX + Space, y: AboutUsButton.frame.minY, width: (loginButton.frame.width * 2) + Space, height: RequestFinanceButton.frame.height)
    
    NewsUpdatesButton.frame = CGRect(x: 0, y: AboutUsButton.frame.maxY + Space, width: ProductsServicesButton.frame.width , height: RequestFinanceButton.frame.height)
        
    MobadraButton.frame = CGRect(x: NewsUpdatesButton.frame.maxX + Space, y: NewsUpdatesButton.frame.minY, width: loginButton.frame.width, height: RequestFinanceButton.frame.height)
    }
    
    
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.backgroundColor = .clear
        Scroll.showsVerticalScrollIndicator = false
        return Scroll
    }()

    lazy var HomeLabel : UILabel = {
    let Label = UILabel()
    Label.numberOfLines = 2
    Label.textAlignment = .left
    Label.backgroundColor = .clear
    Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(25))
    return Label
    }()
        
    lazy var loginButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home1", Title:"")
    Button.addTarget(self, action: #selector(self.ActionLogin), for: .touchUpInside)
    return Button
    }()
        

    @objc func ActionLogin() {
    if GetUserObject().phone == nil {
    PresentByNavigation(ViewController: self, ToViewController: LogInController())
    }else{
    PresentByNavigation(ViewController: self, ToViewController: ProfIleVC())
    }
    }
        

    lazy var RequestFinanceButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home2", Title:"REQUESTFINANCE".localizable)
    Button.addTarget(self, action: #selector(ActionRequestFinance), for: .touchUpInside)
    return Button
    }()
        

    @objc func ActionRequestFinance() {
    let Controller = RequestFlnanceVC()
    Controller.Home = self
    Controller.TopBackView.text = "REQUESTFINANCE".localizable
    Controller.TopBackView.textColor = #colorLiteral(red: 0.628772974, green: 0.8329839706, blue: 0.7395899296, alpha: 1)
    PresentByNavigation(ViewController: self, ToViewController: Controller)
    }

    lazy var OffersButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home3", Title:"OFFERS".localizable)
    Button.addTarget(self, action: #selector(ActionOffers), for: .touchUpInside)
    return Button
    }()
        
    @objc func ActionOffers() {
    PresentByNavigation(ViewController: self, ToViewController: OffersVC())
    }
    
    lazy var FullWebsiteButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home4", Title: "FULLWEBSITE".localizable)
    Button.addTarget(self, action: #selector(ActionFullWebsite), for: .touchUpInside)
    return Button
    }()
        

    @objc func ActionFullWebsite() {
    let OurWebsiet = OurWebsietVC()
    OurWebsiet.modalPresentationStyle = .overFullScreen
    OurWebsiet.modalTransitionStyle = .coverVertical
    present(OurWebsiet, animated: true)
    }
 
    lazy var ProductsServicesButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home5", Title: "PRODUCTS & SERVICES".localizable)
    Button.addTarget(self, action: #selector(ActionProductsServices), for: .touchUpInside)
    return Button
    }()
        
    @objc func ActionProductsServices() {
    PresentByNavigation(ViewController: self, ToViewController: ProductsServicesVC())
    }
        
    lazy var CalculatorButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home6", Title: "INSTALLMENTCALCULATOR".localizable)
    Button.addTarget(self, action: #selector(ActionCalculator), for: .touchUpInside)
    return Button
    }()
        
    @objc func ActionCalculator() {
    PresentByNavigation(ViewController: self, ToViewController: CalculatorVC())
    }
        
    lazy var AboutUsButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home7", Title: "ABOUTUS".localizable)
    Button.addTarget(self, action: #selector(ActionAboutUs), for: .touchUpInside)
    return Button
    }()
        

    @objc func ActionAboutUs() {
    PresentByNavigation(ViewController: self, ToViewController: AboutUsVC())
    }
        
        
    lazy var InvestmentLoanButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home8", Title: "INVESTMENTOPPORTUNITIES".localizable)
    Button.addTarget(self, action: #selector(ActionCurrencyRate), for: .touchUpInside)
    return Button
    }()
        

    @objc func ActionCurrencyRate() {
    PresentByNavigation(ViewController: self, ToViewController: InvestmentOpportunitiesVC())
    }
    
    lazy var NewsUpdatesButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home9", Title: "NEWSUPDATES".localizable)
    Button.addTarget(self, action: #selector(ActionNewsUpdates), for: .touchUpInside)
    return Button
    }()
        

    @objc func ActionNewsUpdates() {
    PresentByNavigation(ViewController: self, ToViewController: NewsUpdatesVC())
    }

    lazy var MobadraButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "Home10", Title: "MOBADRA".localizable)
    Button.addTarget(self, action: #selector(ActionMobadra), for: .touchUpInside)
    return Button
    }()
        

    @objc func ActionMobadra() {
    if GetUserObject().uid != nil {
    let Mobadra = MobadraVC()
    Mobadra.reqId = 0
    Mobadra.isUpdate = false
    PresentByNavigation(ViewController: self, ToViewController: Mobadra)
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
    
    func SetUpButton(button:UIButton,Background:String,Title:String) {
    button.setTitleColor(.white, for: .normal)
    button.contentHorizontalAlignment = .left
    button.contentVerticalAlignment = .bottom
    button.titleLabel?.numberOfLines = 0
    button.layoutIfNeeded()
    button.setTitle(Title, for: .normal)
    button.subviews.first?.contentMode = .scaleToFill
    button.backgroundColor = .clear
    button.setBackgroundImage(UIImage(named: Background), for: .normal)
    button.titleLabel?.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(10.5))
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: button.frame.height + 10, right: 0)
    }
    
    
    }


///----------------------------------------------
/// MARK: GET DATA BY API
///----------------------------------------------
extension HomeVC {
    
    func LoadCompanyInfo() {
    guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + CompanyInfoDetails)"
        
    AlamofireCall(Url: api, HTTP: .get, parameters: nil, Success: {}, Array: {_ in}) { json in
    self.Company = CompanyInfo(json: json)
    let facebook = self.Company?.facebook
    let phone = self.Company?.phone
    let website = self.Company?.website
    let ArAgreement = self.Company?.ArAgreement
    let EnAgreement = self.Company?.EnAgreement
    let lat = self.Company?.lat ?? ""
    let long = self.Company?.long ?? ""
    let Adders = self.Company?.Adders
                        
    if defaults.string(forKey: "faceBookPage") == facebook && defaults.string(forKey: "phone") == phone && defaults.string(forKey: "website") == website && defaults.string(forKey: "arAgreement") == ArAgreement && defaults.string(forKey: "enAgreement") == EnAgreement && defaults.double(forKey: "lat") == Double(lat) && defaults.double(forKey: "long") == Double(long) && defaults.string(forKey: "adders") == Adders {
    return
    }else {
    defaults.set(facebook, forKey: "faceBookPage")
    defaults.set(phone, forKey: "phone")
    defaults.set(website, forKey: "website")
    defaults.set(ArAgreement, forKey: "arAgreement")
    defaults.set(EnAgreement, forKey: "enAgreement")
    defaults.set(Double(lat), forKey: "lat")
    defaults.set(Double(long), forKey: "long")
    defaults.set(Adders, forKey: "adders")
    }
    } Err: { _ in}
    }
    
}
