//
//  LegalVC.swift
//  LegalVC
//
//  Created by Emoji Technology on 14/10/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices

class LegalVC: UIViewController , UITextFieldDelegate {
    
    var reqId = Int()
    var isUpdate = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpItems()
    }
    

    func SetUpItems() {

//    let TopHeight = UIApplication.shared.statusBarFrame.height
    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)

    ViewScroll.addSubview(TopBackView)
    TopBackView.frame =  CGRect(x: ControlX(5), y: ControlY(20), width: view.frame.width - ControlX(10), height: ControlHeight(50))

    ViewScroll.addSubview(TextView)
    TextView.frame = CGRect(x: ControlX(20), y: ControlY(95), width: view.frame.width - ControlX(40), height: ControlHeight(90))

    let StackVertical = UIStackView(arrangedSubviews: [ProjectBrief,MonthlyIncome,ServiceTypeView,LengthOfBusiness])
    StackVertical.axis = .vertical
    StackVertical.spacing = ControlHeight(40)
    StackVertical.distribution = .fillEqually
    StackVertical.alignment = .fill
    StackVertical.backgroundColor = .clear
    ViewScroll.addSubview(StackVertical)

    StackVertical.frame = CGRect(x: ControlX(20), y: ControlY(190), width: view.frame.width - ControlX(40), height: ControlHeight(240))

    ViewScroll.addSubview(UploadFiles)
    ViewScroll.addSubview(CommentsTF)
    ViewScroll.addSubview(SubmitButton)

    UploadFiles.frame = CGRect(x: ControlX(20), y: ControlY(480), width: ControlWidth(190), height: ControlHeight(36))

    CommentsTF.frame = CGRect(x: ControlX(20), y: ControlY(550), width: view.frame.width - ControlX(40), height: ControlHeight(30))

    SubmitButton.frame = CGRect(x: view.center.x - ControlWidth(60), y: ControlY(640), width: ControlWidth(120), height: ControlHeight(40))
    SubmitButton.layer.cornerRadius = SubmitButton.frame.height / 2

    MonthlyIncome.delegate = self
        
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
        Scroll.backgroundColor = .clear
        Scroll.keyboardDismissMode = .interactive
        Scroll.showsVerticalScrollIndicator = false
        Scroll.bounces = true
        return Scroll
    }()

    lazy var  TextView : UILabel = {
        let Label = UILabel()
        Label.text = "Legal & Financial Consultant".localizable
        Label.backgroundColor = .clear
        Label.textColor = HistoryTxet
        Label.numberOfLines = 3
        Label.font = UIFont(name: "Campton-Light", size: ControlWidth(15))
        return Label
    }()

    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = LabelForeground
        View.Space = ControlHeight(3)
        View.FontSize = ControlWidth(28)
        View.text = "LEGALFINANCIALCONSULTANT".localizable
        View.Button.tintColor = View.textColor
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()

    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }

    lazy var ProjectBrief : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "ProjectBrief".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()

    lazy var MonthlyIncome : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "MonthlyIncome".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.keyboardType = .phonePad
        return tf
    }()

    lazy var LengthOfBusiness : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "LengthOfBusiness*".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()

    lazy var CommentsTF : UITextField = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "Comments".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()

    lazy var ServiceTypeView : SPRadioButton = {
        let View = SPRadioButton()
        View.TextYes = "Legal".localizable
        View.TextNo = "Financial".localizable
        View.TextTitle = "ServiceType".localizable
        View.TitleLabel.font = UIFont(name: "Campton-Light" ,size: ControlWidth(15))
        View.YesButton.Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(14))
        View.NoButton.Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(14))
        return View
    }()

    lazy var SubmitButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.titleLabel?.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(18))
        Button.setTitle("SUBMIT".localizable, for: .normal)
        Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.titleLabel?.textAlignment = .center
        Button.addTarget(self, action: #selector(ActionSubmit), for: .touchUpInside)
        return Button
    }()



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


extension LegalVC : UIDocumentPickerDelegate {

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
extension LegalVC {
    
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

    func AddRequest(FileUid:String) {
     guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + PhoneLegalAndFinancialRequest)"
        
    guard let uid = GetUserObject().uid else{return}
    guard let sysToken = GetUserObject().sysToken else{return}

    guard let ProjectBrief = ProjectBrief.text else {return}
    guard let Monthly = MonthlyIncome.text else {return}
    guard let LengthOfBusiness = LengthOfBusiness.text else {return}
    let ServiceType = ServiceTypeView.YesButton.isOn
    let Comments = CommentsTF.text ?? ""


    if ProjectBrief.TextNull() == false || Monthly.TextNull() == false || LengthOfBusiness.TextNull() == false {
    Error(Err: "FillInInformationCorrectly".localizable)
    return
    }

    let parameters: [String: Any] = [
    "isUpdate": isUpdate,
    "reqId": reqId,
    "uid": uid,
    "sysToken": sysToken,
    "projectSectorTypId": 9,
    "projectBrief": ProjectBrief,
    "monthlyIncome": Monthly,
    "serviceType": ServiceType,
    "lengthofBusines": LengthOfBusiness,
    "uploadFilseUrl": FileUid,
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
