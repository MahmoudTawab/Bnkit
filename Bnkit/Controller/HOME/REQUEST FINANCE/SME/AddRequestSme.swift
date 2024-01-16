//
//  AddRequestSme.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 2/26/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices
import FlagPhoneNumber

class AddRequestSme: UIViewController , UITextFieldDelegate {

    var IdAdd = Int()
    var reqId = Int()
    var isUpdate = Bool()
    var Provider = Int()
    var ProviderId = [Int]()
    var ProviderName = [String]()
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpTFData()
    SetUpItems()
   
    }
    

    func SetUpItems() {

    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)

    let StackVertical = UIStackView(arrangedSubviews: [MonthlyIncomeTF,RequestedAmount,StartUpView,IslamicView,LengthOfBusiness])
    StackVertical.axis = .vertical
    StackVertical.spacing = ControlHeight(40)
    StackVertical.distribution = .fillEqually
    StackVertical.backgroundColor = .clear

    ViewScroll.addSubview(TopBackView)
    ViewScroll.addSubview(TextView)
    ViewScroll.addSubview(StackVertical)
    ViewScroll.addSubview(PreferredCompany)
    ViewScroll.addSubview(UploadFiles)
    ViewScroll.addSubview(CommentsTF)
//    ViewScroll.addSubview(CheckboxButton)
//    ViewScroll.addSubview(UserAgreementLabel)
    ViewScroll.addSubview(SubmitButton)

        
    TopBackView.frame = CGRect(x: ControlX(5), y: ControlY(20), width: view.frame.width - ControlX(20), height: ControlHeight(50))

    TextView.frame = CGRect(x: ControlX(20), y: ControlY(80), width: view.frame.width - ControlX(40), height: ControlHeight(90))

    PreferredCompany.frame = CGRect(x: ControlX(20), y: ControlY(185), width: view.frame.width - ControlX(40), height: ControlHeight(30))

    StackVertical.frame = CGRect(x: ControlX(20), y: ControlY(255), width: view.frame.width - ControlX(40), height: ControlHeight(330))

    UploadFiles.frame = CGRect(x: ControlX(20), y: ControlY(630), width: ControlWidth(190), height: ControlHeight(36))

    CommentsTF.frame = CGRect(x: ControlX(20), y: ControlY(700), width: view.frame.width - ControlX(40), height: ControlHeight(30))

//    CheckboxButton.frame = CGRect(x: ControlX(15), y: ControlY(810), width: ControlHeight(35), height: ControlHeight(35))
//
//    UserAgreementLabel.frame = CGRect(x: ControlX(55), y: ControlY(820), width: view.frame.width - ControlX(110), height: ControlHeight(20))

    SubmitButton.frame = CGRect(x: view.center.x - ControlWidth(60), y: ControlY(780), width: ControlWidth(120), height: ControlHeight(40))

    SubmitButton.layer.cornerRadius = SubmitButton.frame.height / 2
        
    let border = UIView()
    border.backgroundColor = #colorLiteral(red: 0.3808627231, green: 0.3846336411, blue: 0.3846336411, alpha: 1)
    border.translatesAutoresizingMaskIntoConstraints = false
    IslamicView.addSubview(border)
    border.widthAnchor.constraint(equalTo: IslamicView.widthAnchor).isActive = true
    border.bottomAnchor.constraint(equalTo: IslamicView.topAnchor ,constant: ControlY(-8)).isActive = true
    border.heightAnchor.constraint(equalToConstant: ControlHeight(1)).isActive = true

    RequestedAmount.delegate = self
    MonthlyIncomeTF.delegate = self

    view.addSubview(Alert)
    Alert.frame = view.bounds
        
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(ControlWidth(20))
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
        Label.text = "PartnershipApplicant".localizable
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
        View.text = "ADDREQUEST".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()

    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }

    lazy var PreferredCompany : DropDown = {
        let drop = DropDown()
        SetUpDropDown(Drop: drop, Placeholder: "Preferred Bank/Company".localizable)
        return drop
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

    lazy var MonthlyIncomeTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "MonthlyIncome".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.keyboardType = .numberPad
        return tf
    }()

    lazy var RequestedAmount : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "RequestedAmount".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.keyboardType = .numberPad
        return tf
    }()

    lazy var StartUpView : SPRadioButton = {
        let View = SPRadioButton()
        View.TextYes = "Yes".localizable
        View.TextNo = "No".localizable
        View.TextTitle = "StartUp".localizable
        return View
    }()
    
    lazy var IslamicView : SPRadioButton = {
        let View = SPRadioButton()
        View.TextYes = "Yes".localizable
        View.TextNo = "No".localizable
        View.TextTitle = "Islamic".localizable
        return View
    }()

    lazy var  LengthOfBusiness : UITextField = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "LengthOfBusiness".localizable, attributes:[.foregroundColor: LabelForeground])
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
        Button.isHidden = true
        return Button
    }()

    lazy var UserAgreementLabel : UILabel = {
        let Label = UILabel()
        Label.isHidden = true
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

    @objc func ActionSubmit() {
    if Auth.auth().currentUser?.uid == nil {
    Error(Err: "ErrorLogIn".localizable)
    return
    }

    guard let phone = GetUserObject().phone else{return}
    if let File = FileSand {
    self.Alert.SetIndicator(Style: .load)
    let riversRef = Storage.storage().reference().child("DataUser").child(phone).child("Files").child(File.lastPathComponent)
    riversRef.putFile(from: File, metadata: nil) { metadata, error in
    if let error = error {
    self.Error(Err:error.localizedDescription)
    return
    }
            
    riversRef.downloadURL { (url, error) in
    guard let File = url?.absoluteString else { return }
    self.AddRequest(FileUid: File)
    }
    }
    }else{
    self.Alert.SetIndicator(Style: .load)
    AddRequest(FileUid: FileURL ?? "")
    }
    }



    func Error(Err:String) {
    self.Alert.SetIndicator(Style: .error)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
    self.SetUpPopUp(text: Err)
    }
    }

    lazy var UploadFiles : UploadFilesButton = {
        let view = UploadFilesButton()
        view.IsUpload(false, 0)
        view.backgroundColor = .clear
        view.LabelText = "UploadFiles".localizable
        view.Cancel.addTarget(self, action: #selector(ActionCancelFiles), for: .touchUpInside)
        view.Button.addTarget(self, action: #selector(ActionUploadFiles), for: .touchUpInside)
        return view
    }()

    @objc func ActionUploadFiles() {
    if UploadFiles.Cancel.alpha == 0 {
    let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet ,kUTTypeJPEG ,kUTTypePNG ,kUTTypePlainText ,kUTTypeMP3]
    let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
    if #available(iOS 11.0, *) {
    documentPicker.allowsMultipleSelection = true
    }
    documentPicker.delegate = self
    documentPicker.modalTransitionStyle = .flipHorizontal
    documentPicker.modalPresentationStyle = .fullScreen
    Present(ViewController: self, ToViewController: documentPicker)
    }
    }

    var FileSand : URL?
    var FileURL : String?
    @objc func ActionCancelFiles() {
    if let File = FileURL {
    Storage.storage().reference(forURL: File).delete { error in
    self.FileURL = nil
    self.FileSand = nil
    self.UploadFiles.IsUpload(false, 0.5)
    }
    }else{
    self.FileSand = nil
    self.UploadFiles.IsUpload(false, 0.5)
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


extension AddRequestSme : UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let FileUrl = urls.first else{return}
        guard let size = try? FileManager.default.attributesOfItem(atPath: FileUrl.path) else {return}

        if let size = size[FileAttributeKey.size] as? NSNumber {
        let floatSize = Float(Int(truncating: size) / 1024)
        if (floatSize / 1024) > 5 {
        self.Error(Err: "ErrorFiles".localizable)
        return
        }

        FileSand = FileUrl
        self.UploadFiles.IsUpload(true, 0.5)
        }
    }

}


///----------------------------------------------
/// MARK: GET DATA BY API
///----------------------------------------------
extension AddRequestSme {
   
    
    
    func SetUpTFData() {
     guard let url = defaults.string(forKey: "API") else{return}
    let Provider = "\(url + PhoneServiceProvider)"

    AlamofireCall(Url: Provider, HTTP: .get, parameters: nil, Success: {}) { (jsons) in
    for json in jsons {
    if let Service = "lang".localizable == "en" ? json["enProvName"] as? String : json["arProvName"] as? String ,let provider = json["provId"] as? Int {
    self.ProviderName.append(Service)
    self.ProviderId.append(provider)
    self.PreferredCompany.optionIds = self.ProviderId
    self.PreferredCompany.optionArray = self.ProviderName
    }
        
    if self.ProviderName.count == jsons.count {
    if let provider = self.ProviderId.firstIndex(of: self.Provider) {
    self.PreferredCompany.selectedIndex = provider
    self.PreferredCompany.ActionTF()
    self.PreferredCompany.table.reloadData()
    self.PreferredCompany.setTitle("\(self.ProviderName[provider])", for: .normal)
    }
    }
    }
    } Err: { _ in}

    PreferredCompany.didSelect{(selectedText , index ,id) in
    self.PreferredCompany.setTitle("\(selectedText)", for: .normal)
    self.Provider = id
    }
    }
    
    
    func AddRequest(FileUid:String) {
     guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + PhoneSmeMicroequest)"

    guard let uid = GetUserObject().uid else { return }
    guard let sysToken = GetUserObject().sysToken else { return }
    guard let MonthlyIncome = MonthlyIncomeTF.text else {return}
    guard let Amount = RequestedAmount.text else {return}

    let StartUp = StartUpView.YesButton.isOn
    let Islamic = IslamicView.YesButton.isOn
        
    let lengthOfBusiness = LengthOfBusiness.text ?? ""
    let Comments = CommentsTF.text ?? ""

    if Provider == 0 || MonthlyIncome.TextNull() == false || Amount.TextNull() == false {
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
        "proId": IdAdd,
        "projectSectorTypId": 3,
        "provId": Provider,
        "monthlyIncome": MonthlyIncome,
        "amount": Amount,
        "sturtUp": StartUp,
        "islamic": Islamic,
        "lengthOfBusiness": lengthOfBusiness,
        "uploadedFilesUrl": FileUid,
        "comments": Comments
    ]

    AlamofireCall(Url: api, HTTP: .post, parameters: parameters,encoding: JSONEncoding.default) {
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {Success()}
    } Err: { (err) in
    self.Error(Err: err)
    }
    }
    
}
