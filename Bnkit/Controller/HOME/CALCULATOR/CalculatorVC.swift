//
//  CalculatorVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 2/9/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController, UITextFieldDelegate , UIScrollViewDelegate {

    
    var Loan = Int()
    var LoanId = [Int]()
    var LoanName = [String]()
    
    var Income = Int()
    var IncomeId = [Int]()
    var IncomeName = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpItems()
        SetUpTFData()
    }
    
    
    func SetUpItems() {
                
    
        ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(ViewScroll)
        
        ViewScroll.addSubview(TopBackView)
        ViewScroll.addSubview(LoanPeriodTF)
        ViewScroll.addSubview(StackLoanPeriod)
        ViewScroll.addSubview(NetIncomeTF)
        ViewScroll.addSubview(CalculatorButton)
        ViewScroll.addSubview(LoanAmountTF)
        ViewScroll.addSubview(IncomeType)
        ViewScroll.addSubview(LoanType)
        
        NetIncomeTF.delegate = self
        LoanAmountTF.delegate = self
        
        TopBackView.frame =  CGRect(x: ControlX(10), y: ControlY(20), width: view.frame.width - ControlX(20), height: ControlHeight(50))
        
        LoanType.frame = CGRect(x: ControlX(25), y: ControlY(135), width: view.frame.width - ControlX(50), height: ControlWidth(45))
        
        LoanPeriodTF.frame = CGRect(x: ControlX(25), y: ControlY(230), width: view.frame.width - ControlX(50), height: ControlWidth(45))
        
        StackLoanPeriod.frame = CGRect(x: LoanPeriodTF.frame.maxX - ControlWidth(30), y: ControlY(235), width: ControlWidth(20), height: ControlWidth(35))
        
        IncomeType.frame = CGRect(x: ControlX(25), y: ControlY(320), width: view.frame.width - ControlX(50), height: ControlWidth(45))
        
        NetIncomeTF.frame = CGRect(x: ControlX(25), y: ControlY(410), width: view.frame.width - ControlX(50), height: ControlWidth(45))
        
        LoanAmountTF.frame = CGRect(x: ControlX(25), y: ControlY(510), width: view.frame.width - ControlX(50), height: ControlWidth(45))
        
        CalculatorButton.frame = CGRect(x: view.center.x - ControlWidth(80), y: ControlY(592), width: ControlWidth(160), height: ControlWidth(45))
        CalculatorButton.layer.cornerRadius = CalculatorButton.frame.height / 2
        
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
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = LabelForeground
        View.Space = ControlHeight(3)
        View.FontSize = ControlWidth(30)
        View.text = "CALCULATOR".localizable
        View.Button.tintColor = View.textColor
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var LoanType : DropDown = {
        let drop = DropDown()
        SetUpDropDown(Drop: drop, Placeholder: "LoanType".localizable)
        return drop
    }()
    
    var  Number = 1
    lazy var LoanPeriodTF : FloatingTF = {
        let tf = FloatingTF()
        SetUpTF(TF: tf)
        tf.attributedPlaceholder = NSAttributedString(string: "LoanPeriod".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.isEnabled = false
        return tf
    }()
    
    lazy var LoanPeriodUP : UIImageView = {
        let Image = UIImageView()
        let image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: ControlY(6), left: ControlX(6), bottom: ControlY(6), right: ControlX(6)))
        Image.image = image
        Image.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        Image.tintColor = LabelForeground
        Image.backgroundColor = .clear
        Image.contentMode = .scaleAspectFill
        Image.isUserInteractionEnabled = true
        Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ActionLoanPeriodUP)))
        return Image
    }()
    
    
    @objc func ActionLoanPeriodUP() {
    if Number > 0 && Number < 10 {
    Number+=1
    LoanPeriodTF.text =  "lang".localizable == "en" ? "\(Number)" : "\(Number)".NumAR()
    }
    }
    
    lazy var LoanPeriodDown : UIImageView = {
        let Image = UIImageView()
        let image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: ControlY(6), left: ControlX(6), bottom: ControlY(6), right: ControlX(6)))
        Image.image = image
        Image.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        Image.tintColor = LabelForeground
        Image.backgroundColor = .clear
        Image.contentMode = .scaleAspectFill
        Image.isUserInteractionEnabled = true
        Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ActionLoanPeriodDown)))
        return Image
    }()
    
    
    @objc func ActionLoanPeriodDown() {
    if Number > 1 {
    Number-=1
    LoanPeriodTF.text =  "lang".localizable == "en" ? "\(Number)" : "\(Number)".NumAR()
    }
    }
    
    lazy var StackLoanPeriod : UIStackView = {
        let Stack = UIStackView(arrangedSubviews: [LoanPeriodUP,LoanPeriodDown])
        Stack.axis = .vertical
        Stack.spacing = ControlX(5)
        Stack.distribution = .fillEqually
        Stack.alignment = .fill
        Stack.backgroundColor = .clear
        return Stack
    }()
    
    
    lazy var IncomeType : DropDown = {
        let drop = DropDown()
        SetUpDropDown(Drop: drop, Placeholder: "IncomeType".localizable)
        return drop
    }()
    
    lazy var NetIncomeTF : FloatingTF = {
        let tf = FloatingTF()
        SetUpTF(TF: tf)
        tf.attributedPlaceholder = NSAttributedString(string: "NetIncome".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var LoanAmountTF : FloatingTF = {
        let tf = FloatingTF()
        SetUpTF(TF: tf)
        tf.attributedPlaceholder = NSAttributedString(string: "LoanAmount".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    lazy var CalculatorButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.titleLabel?.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(18))
        Button.setTitle("CALCULAT".localizable, for: .normal)
        Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.titleLabel?.textAlignment = .center
        Button.addTarget(self, action: #selector(ActionCalculator), for: .touchUpInside)
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
    
    func SetUpDropDown(Drop:DropDown , Placeholder:String)  {
    Drop.rowHeight = ControlHeight(40)
    Drop.listHeight = ControlHeight(200)
    Drop.rowBackgroundColor = BackgroundColor
    Drop.selectedRowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    Drop.borderColor = #colorLiteral(red: 0.4233468771, green: 0.519071877, blue: 0.7063246369, alpha: 1)
    Drop.cornerRadius = ControlWidth(8)
    Drop.borderWidth = ControlWidth(1)
    Drop.Holder = Placeholder
    Drop.FontSize = ControlWidth(13)
    Drop.TitleColor = LabelForeground
    Drop.SelectedTitleColor = LogInColors
    Drop.SeparatorColor = LogInColors
        
    Drop.setTitle(Placeholder, for: .normal)
    Drop.contentEdgeInsets = "lang".localizable == "en" ? UIEdgeInsets(top: 0, left: ControlWidth(8), bottom: 0, right: ControlWidth(40)):UIEdgeInsets(top: 0, left: ControlWidth(40), bottom: 0, right: ControlWidth(8))
    }
    
    func SetUpTF(TF:FloatingTF)  {
        TF.layer.borderColor = #colorLiteral(red: 0.4233468771, green: 0.519071877, blue: 0.7063246369, alpha: 1)
        TF.textColor = LogInColors
        TF.layer.cornerRadius = ControlWidth(8)
        TF.layer.borderWidth = ControlWidth(1)
        TF.TitleLabelY = ControlHeight(30)
        TF.keyboardType = .numberPad
        TF.bottomLineLayer.isHidden = true
        TF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15 , height: TF.frame.height))
        TF.leftViewMode = .always
        TF.rightView = UIView(frame: CGRect(x: 0, y: 0, width: -15 , height: TF.frame.height))
        TF.rightViewMode = .always
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
extension CalculatorVC {
    
    
    @objc func ActionCalculator() {
    self.Alert.SetIndicator(Style: .load)
     guard let url = defaults.string(forKey: "API") else{return}
    let APICalculator = "\(url + PhoneCalculator)"

    if LoanType.titleLabel?.text == "LoanType".localizable || IncomeType.titleLabel?.text == "IncomeType".localizable || NetIncomeTF.text?.TextNull() == false || LoanAmountTF.text?.TextNull() == false {
    Error(Err: "FillInInformationCorrectly".localizable)
    return
    }else if (NetIncomeTF.text?.count)! > 9 {
    Error(Err: "ErrorNetIncome".localizable)
    return
    }else if (LoanAmountTF.text?.count)! > 9 {
    Error(Err: "ErrorLoanAmount".localizable)
    return
    }else{

    guard let NetIncome = NetIncomeTF.text else {return}
    guard let LoanAmount = LoanAmountTF.text else {return}

    let parameters = ["LoanType":"\(Loan)","LoanPeriod": "\(Number)","IncomeType": "\(Income)","NetIncome": "\(NetIncome)","LoanAmount": "\(LoanAmount)"]
    AlamofireCall(Url: APICalculator, HTTP: .get, parameters: parameters, Array: {_ in}) { (json) in
    let CalculatorDetaIls = CalculatorDetaIlsVC()
    CalculatorDetaIls.LoanType = self.LoanType.titleLabel?.text ?? ""
    CalculatorDetaIls.Calcula.append(Calculator(json: json))
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
    PresentByNavigation(ViewController: self, ToViewController: CalculatorDetaIls)
    }
    } Err: { (Err) in
    self.Error(Err:Err)
    }
    }
    }
    
    
    func SetUpTFData() {
    guard let url = defaults.string(forKey: "API") else{return}
    let loanType = "\(url + PhoneLoanType)"
    let incomeType = "\(url + PhoneEmploymentType)"
            
    AlamofireCall(Url: loanType, HTTP: .get, parameters: nil ,Success: {}) { (jsons) in
    for json in jsons {
    if let Loan = "lang".localizable == "en" ? json["enProName"] as? String : json["arProName"] as? String , let LoanId = json["proId"] as? Int {
    self.LoanName.append(Loan)
    self.LoanId.append(LoanId)
    self.LoanType.optionIds = self.LoanId
    self.LoanType.optionArray = self.LoanName
    }
        
    }} Err: {_ in}
            
    LoanType.didSelect{(selectedText , index ,id) in
    self.LoanType.setTitle("\(selectedText)", for: .normal)
    self.Loan = id
    }

    AlamofireCall(Url: incomeType, HTTP: .get, parameters: nil ,Success: {}) { (jsons) in
    for json in jsons {
    if let Employ = "lang".localizable == "en" ? json["enEmpName"] as? String : json["arEmpName"] as? String , let empId = json["empTypeId"] as?Int {
    self.IncomeName.append(Employ)
    self.IncomeId.append(empId)
    self.IncomeType.optionIds = self.IncomeId
    self.IncomeType.optionArray = self.IncomeName
    }
    }
    } Err: {_ in}
            
    IncomeType.didSelect{(selectedText , index ,id) in
    self.IncomeType.setTitle("\(selectedText)", for: .normal)
    self.Income = id
    }
        
    LoanPeriodTF.text = "lang".localizable == "en" ? "\(Number)" : "\(Number)".NumAR()
    }
}
