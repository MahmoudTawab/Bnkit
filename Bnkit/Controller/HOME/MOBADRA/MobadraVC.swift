//
//  MobadraVC.swift
//  MobadraVC
//
//  Created by Emoji Technology on 29/09/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth

class MobadraVC: UIViewController , UITextFieldDelegate {
        
    var reqId = Int()
    var isUpdate = Bool()

    var Emp = Int()
    var Mobadra = Int()
    var EmpId = [Int]()
    var EmpName = [String]()
    var MobadraId = [Int]()
    var MobadraName = [String]()
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    SetUpTFData()
    }
    

    func SetUpItems() {
        
    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)
    
        
    let StackVertical = UIStackView(arrangedSubviews: [MonthlyIncomeTF,RequestedAmountTF,IslamicView,LengthOfBusiness,OtherProductsInterestedTF,CommentsTF])
    StackVertical.axis = .vertical
    StackVertical.spacing = ControlHeight(40)
    StackVertical.distribution = .fillEqually
    StackVertical.backgroundColor = .clear

    ViewScroll.addSubview(TopBackView)

    ViewScroll.addSubview(TextView)
    ViewScroll.addSubview(StackVertical)
    ViewScroll.addSubview(MobadraType)
    ViewScroll.addSubview(Employment)
//    ViewScroll.addSubview(CheckboxButton)
//    ViewScroll.addSubview(UserAgreementLabel)
    ViewScroll.addSubview(SubmitButton)
        
    TopBackView.frame = CGRect(x: ControlX(5), y: ControlY(20), width: view.frame.width - ControlX(10), height: ControlHeight(50))
            
    TextView.frame = CGRect(x: ControlX(20), y: ControlY(80), width: view.frame.width - ControlX(40), height: ControlHeight(90))
        
    Employment.frame = CGRect(x: ControlX(20), y: ControlY(190), width: view.frame.width - ControlX(40), height: ControlHeight(26))
        
    MobadraType.frame = CGRect(x: ControlX(20), y: ControlY(260), width: view.frame.width - ControlX(40), height: ControlHeight(26))
        
    StackVertical.frame = CGRect(x: ControlX(20), y: ControlY(325), width:view.frame.width - ControlX(40), height: ControlHeight(380))
        
//    CheckboxButton.frame = CGRect(x: ControlX(15), y: ControlY(840), width: ControlHeight(35), height: ControlHeight(35))
//
//    UserAgreementLabel.frame = CGRect(x: ControlX(55), y: ControlY(850), width: view.frame.width - ControlX(110), height: ControlHeight(20))

    SubmitButton.frame = CGRect(x: view.center.x - ControlWidth(60), y: ControlY(750), width: ControlWidth(120), height: ControlHeight(40))

    SubmitButton.layer.cornerRadius = SubmitButton.frame.height / 2
        
    MonthlyIncomeTF.delegate = self
    RequestedAmountTF.delegate = self
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
        
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(0)
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
    return false
    }
    return true
    }
    
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.bounces = true
        Scroll.backgroundColor = .clear
        Scroll.keyboardDismissMode = .interactive
        return Scroll
    }()
    
    lazy var  TextView : UILabel = {
        let Label = UILabel()
        Label.text = "Mobadra".localizable
        Label.backgroundColor = .clear
        Label.textColor = HistoryTxet
        Label.numberOfLines = 3
        Label.font = UIFont(name: "Campton-Light", size: ControlWidth(15))
        return Label
    }()
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.backgroundColor = .clear
        View.textColor = LabelForeground
        View.Space = ControlHeight(3)
        View.FontSize = ControlWidth(30)
        View.text = "MOBADRA".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }

    lazy var Employment : DropDown = {
        let drop = DropDown()
        drop.backgroundColor = .clear
        SetUpDropDown(Drop: drop, Placeholder: "EmploymentType".localizable)
        return drop
    }()
    
    lazy var MobadraType : DropDown = {
        let drop = DropDown()
        SetUpDropDown(Drop: drop, Placeholder: "MobadraType".localizable)
        return drop
    }()
    
    lazy var MonthlyIncomeTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "MonthlyIncome".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.keyboardType = .numberPad
        return tf
    }()
    
    lazy var RequestedAmountTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "RequestedAmount".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.keyboardType = .numberPad
        return tf
    }()
    
   
    func SetUpDropDown(Drop:DropDown , Placeholder:String)  {
        Drop.rowHeight = ControlHeight(40)
        Drop.listHeight = ControlHeight(200)
        Drop.rowBackgroundColor = BackgroundColor
        Drop.selectedRowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        Drop.Holder = Placeholder
        Drop.TitleColor = LabelForeground
        Drop.SeparatorColor = LabelForeground
        Drop.SelectedTitleColor = HistoryTxet
        Drop.FontSize = ControlWidth(13)
        
        Drop.setTitle(Placeholder, for: .normal)
        Drop.contentEdgeInsets = "lang".localizable == "en" ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ControlWidth(40)):UIEdgeInsets(top: 0, left: ControlWidth(40), bottom: 0, right: 0)
        
        let border = UIView()
        border.backgroundColor = LabelForeground
        border.translatesAutoresizingMaskIntoConstraints = false
        Drop.addSubview(border)
        border.widthAnchor.constraint(equalTo: Drop.widthAnchor).isActive = true
        border.bottomAnchor.constraint(equalTo: Drop.bottomAnchor ,constant: ControlY(3)).isActive = true
        border.heightAnchor.constraint(equalToConstant: ControlHeight(1)).isActive = true
    }
    

    
    lazy var IslamicView : SPRadioButton = {
        let View = SPRadioButton()
        View.TextYes = "Yes".localizable
        View.TextNo = "No".localizable
        View.TextTitle = "Islamic".localizable
        return View
    }()
    
    lazy var LengthOfBusiness : UITextField = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "LengthOfBusiness".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var  OtherProductsInterestedTF : UITextField = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "OtherProductsInterestedIn".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var CommentsTF : UITextField = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "Comments".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var CheckboxButton : Checkbox = {
        let Button = Checkbox(type: .system)
        Button.backgroundColor = .clear
        return Button
    }()

    lazy var UserAgreementLabel : UILabel = {
        let Label = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "IAgreeTo".localizable, attributes: [
            .font: UIFont(name: "Campton-Light", size: ControlWidth(16)) ?? UIFont.systemFont(ofSize: ControlWidth(16)),
            .foregroundColor: LabelForeground
        ])
    
        
        attributedString.append(NSAttributedString(string: "UserAgreement".localizable, attributes: [
            .font: UIFont(name: "Campton-Light", size: ControlWidth(16)) ?? UIFont.systemFont(ofSize: ControlWidth(16)),
            .foregroundColor: LabelForeground ,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        
        Label.backgroundColor = .clear
        Label.attributedText = attributedString
        return Label
    }()
    
    lazy var SubmitButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.titleLabel?.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(18))
        Button.setTitle("SUBMIT".localizable, for: .normal)
        Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.addTarget(self, action: #selector(ActionSubmit), for: .touchUpInside)
        return Button
    }()

    
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
extension MobadraVC {
    
    func SetUpTFData() {
    guard let url = defaults.string(forKey: "API") else{return}
    let EmploymentType = "\(url + PhoneEmploymentType)"
        
    AlamofireCall(Url: EmploymentType, HTTP: .get, parameters: nil, Success: {}) { (jsons) in
    for json in jsons {
    if let Employ = "lang".localizable == "en" ? json["enEmpName"] as? String : json["arEmpName"] as? String , let empId = json["empTypeId"] as? Int {
    self.EmpName.append(Employ)
    self.EmpId.append(empId)
    self.Employment.optionIds = self.EmpId
    self.Employment.optionArray = self.EmpName
    }
        
    if self.EmpName.count == jsons.count {
    if let Emp = self.EmpId.firstIndex(of: self.Emp) {
    self.Employment.selectedIndex = Emp
    self.Employment.ActionTF()
    self.Employment.table.reloadData()
    self.Employment.setTitle("\(self.EmpName[Emp])", for: .normal)
    }
    }
        
    }
    } Err: { _ in}
    Employment.didSelect{(selectedText , index ,id) in
    self.Employment.setTitle("\(selectedText)", for: .normal)
    self.Emp = id
    }
    
    let Mobadra = "\(url + PhoneMobadraTypes)"
    AlamofireCall(Url: Mobadra, HTTP: .get, parameters: nil, Success: {}) { (jsons) in
    for json in jsons {
    if let Service = "lang".localizable == "en" ? json["enMoName"] as? String : json["arMoName"] as? String ,let provider = json["moTypeId"] as? Int {
    self.MobadraName.append(Service)
    self.MobadraId.append(provider)
    self.MobadraType.optionIds = self.MobadraId
    self.MobadraType.optionArray = self.MobadraName
    }
        
    if self.MobadraName.count == jsons.count {
    if let mobadra = self.MobadraId.firstIndex(of: self.Mobadra) {
    self.MobadraType.selectedIndex = mobadra
    self.MobadraType.ActionTF()
    self.MobadraType.table.reloadData()
    self.MobadraType.setTitle("\(self.MobadraName[mobadra])", for: .normal)
    }
    }
        
    }
    } Err: { _ in}
    MobadraType.didSelect{(selectedText , index ,id) in
    self.MobadraType.setTitle("\(selectedText)", for: .normal)
    self.Mobadra = id
    }
    }
    
    @objc func ActionSubmit() {
    if Auth.auth().currentUser?.uid == nil {
    Error(Err: "ErrorLogIn".localizable)
    return
    }
        
     guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + PhoneMobadraRequest)"

    guard let uid = GetUserObject().uid else { return }
    guard let sysToken = GetUserObject().sysToken else { return }
    guard let MonthlyIncome = MonthlyIncomeTF.text else {return}
    guard let RequestedAmount = RequestedAmountTF.text else {return}
    
    let Islamic = IslamicView.YesButton.isOn
    let lengthOfBusiness = LengthOfBusiness.text ?? ""
    let OtherProducts = OtherProductsInterestedTF.text ?? ""
    let Comments = CommentsTF.text ?? ""
    
    if Emp == 0 || Mobadra == 0 || MonthlyIncome.TextNull() == false || RequestedAmount.TextNull() == false {
    Error(Err: "FillInInformationCorrectly".localizable)
    return
    }
    
//    if CheckboxButton.Button.tag == 0 {
//    Error(Err: "ErrorUserAgreement".localizable)
//    return
//    }
    
    let parameters: [String: Any] = [
    "isUpdate": isUpdate,
    "reqId": reqId,
    "uid": uid,
    "sysToken": sysToken,
    "projectSectorTypId": 10,
    "empTypID": Emp,
    "mobadraTypeID": Mobadra,
    "monthlyIncome": MonthlyIncome,
    "reqAmount": RequestedAmount,
    "islamic": Islamic,
    "lengthofBusines": lengthOfBusiness,
    "othrProInterestedIn": OtherProducts,
    "comments": Comments
    ]
        
    self.Alert.SetIndicator(Style: .load)
    AlamofireCall(Url: api, HTTP: .post, parameters: parameters,encoding: JSONEncoding.default) {
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {Success()}
    } Err: { (err) in
    self.Error(Err: err)
    }
        
    }
}
