//
//  AddRequestPersonal.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/18/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseAuth
import FirebaseStorage
import MobileCoreServices

class AddRequestPersonal: UIViewController , UITextFieldDelegate {

    var IdAdd = Int()
    var reqId = Int()
    var isUpdate = Bool()
    
    var Emp = Int()
    var Provider = Int()
    var EmpId = [Int]()
    var EmpName = [String]()
    var ProviderId = [Int]()
    var ServiceProvider = [String]()
    
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    SetUpTFData()
    }
    

    func SetUpItems() {

    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)

    let StackTop = UIStackView(arrangedSubviews: [MonthlyIncomeTF,CoverageAmountTF])
    StackTop.axis = .vertical
    StackTop.spacing = ControlHeight(40)
    StackTop.distribution = .fillEqually
    StackTop.backgroundColor = .clear


    let StackBottom = UIStackView(arrangedSubviews: [CorporateView,ProductsInterested ,LengthOfBusiness,CommentsTF])
    StackBottom.axis = .vertical
    StackBottom.spacing = ControlHeight(40)
    StackBottom.distribution = .fillEqually
    StackBottom.backgroundColor = .clear

    ViewScroll.addSubview(TopBackView)

    ViewScroll.addSubview(TextView)
    ViewScroll.addSubview(StackTop)
    ViewScroll.addSubview(StackBottom)
    ViewScroll.addSubview(UploadFiles)
    ViewScroll.addSubview(UploadImage)

    ViewScroll.addSubview(PreferredCompany)
    ViewScroll.addSubview(Employment)
//  ViewScroll.addSubview(CheckboxButton)
//    ViewScroll.addSubview(UserAgreementLabel)
    ViewScroll.addSubview(SubmitButton)

    TopBackView.frame = CGRect(x: ControlX(5), y: ControlY(25), width: view.frame.width - ControlX(20), height: ControlHeight(50))

    TextView.frame = CGRect(x: ControlX(20), y: ControlY(80), width: view.frame.width - ControlX(40), height: ControlHeight(90))

    Employment.frame = CGRect(x: ControlX(20), y: ControlY(190), width: view.frame.width - ControlX(40), height: ControlHeight(26))

    PreferredCompany.frame = CGRect(x: ControlX(20), y: ControlY(260), width: view.frame.width - ControlX(40), height: ControlHeight(26))

    StackTop.frame = CGRect(x: ControlX(20), y: ControlY(325), width: view.frame.width - ControlX(40), height: ControlHeight(110))

    UploadFiles.frame = CGRect(x: ControlX(15), y: ControlY(490), width: view.frame.width / 2.4, height: ControlHeight(36))

    UploadImage.frame = CGRect(x: view.frame.maxX - UploadFiles.frame.width - ControlX(15), y: UploadFiles.frame.minY, width: UploadFiles.frame.width, height: UploadFiles.frame.height)

    StackBottom.frame = CGRect(x: ControlX(20), y: ControlY(550), width: view.frame.width - ControlX(40), height: ControlHeight(220))

//    CheckboxButton.frame = CGRect(x: ControlX(15), y: ControlY(930), width: ControlHeight(35), height: ControlHeight(35))
//
//    UserAgreementLabel.frame = CGRect(x: ControlX(55), y: ControlY(940), width: ControlWidth(300), height: ControlHeight(20))

    SubmitButton.frame = CGRect(x: view.center.x - ControlWidth(60), y: ControlY(820), width: ControlWidth(120), height: ControlHeight(40))
    SubmitButton.layer.cornerRadius = SubmitButton.frame.height / 2

    MonthlyIncomeTF.delegate = self
    CoverageAmountTF.delegate = self
        
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
        View.text = isUpdate ? "UPDATEREQUEST".localizable : "ADDREQUEST".localizable
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

    lazy var PreferredCompany : DropDown = {
        let drop = DropDown()
        SetUpDropDown(Drop: drop, Placeholder: "PreferredCompany".localizable)
        return drop
    }()

    lazy var MonthlyIncomeTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "MonthlyIncome".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.keyboardType = .numberPad
        return tf
    }()

    lazy var CoverageAmountTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "CoverageAmount".localizable, attributes:[.foregroundColor: LabelForeground])
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

    lazy var CorporateView : SPRadioButton = {
        let View = SPRadioButton()
        View.TextYes = "Yes".localizable
        View.TextNo = "No".localizable
        View.TextTitle = "Corporate".localizable
        return View
    }()

    lazy var  ProductsInterested : UITextField = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "Products Interested in the Future".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
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

    if FileSand != nil || ImageUpload != nil  {
    self.Alert.SetIndicator(Style: .load)
    if let File = FileSand {
        
    let riversRef = Storage.storage().reference().child("DataUser").child(phone).child("Files").child(File.lastPathComponent)
    riversRef.putFile(from: File, metadata: nil) { metadata, error in
    if let error = error {
    self.Error(Err: error.localizedDescription)
    return
    }
        
    riversRef.downloadURL { (url, error) in
    guard let File = url?.absoluteString else { return }
    if let Image = self.ImageUpload?.jpegData(compressionQuality: 0.75) {
    Storag(child: ["DataUser",phone,"Image","ImagePersonal"], image: Image) { Image in
    self.AddRequest(FileUid: File, imageUid: Image)
    } Err: { error in
    self.Error(Err: error)
    return
    }
    }else{
    self.AddRequest(FileUid: File, imageUid: "")
    }
    }
    }
        
    }else{
    if let Image = self.ImageUpload?.jpegData(compressionQuality: 0.75) {
    Storag(child: ["DataUser",phone,"Image","ImagePersonal"], image: Image) { image in
    self.AddRequest(FileUid: "", imageUid: image)
    } Err: { error in
    self.Error(Err: error)
    return
    }
    }
    }

    }else{
    self.Alert.SetIndicator(Style: .load)
    AddRequest(FileUid: FileURL ?? "", imageUid: uploedImageUrl ?? "")
    }
    }


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

    // lod Files ... lod Image
    lazy var UploadFiles : UploadFilesButton = {
        let view = UploadFilesButton()
        view.IsUpload(false, 0)
        view.backgroundColor = .clear
        view.LabelStar.isHidden = false
        view.LabelText = "UploadFiles".localizable
        view.Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(9))
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

    var ImageUpload : UIImage?
    var uploedImageUrl:String?
    lazy var UploadImage : UploadFilesButton = {
        let view = UploadFilesButton()
        view.IsUpload(false, 0)
        view.backgroundColor = .clear
        view.LabelStar.isHidden = false
        view.LabelText = "UploadImage".localizable
        view.Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(8.5))
        view.Cancel.addTarget(self, action: #selector(ActionCancelImage), for: .touchUpInside)
        view.Button.addTarget(self, action: #selector(ActionUploadImage), for: .touchUpInside)
        return view
    }()

    @objc func ActionUploadImage() {
    if UploadImage.Cancel.alpha == 0 {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary;
    imagePicker.allowsEditing = true
    imagePicker.modalPresentationStyle = .fullScreen
    present(imagePicker, animated: true, completion: nil)
    }
    }
    }

    @objc func ActionCancelImage() {
    if let Image = uploedImageUrl {
    Storage.storage().reference(forURL: Image).delete { error in
    self.ImageUpload = nil
    self.uploedImageUrl = nil
    self.UploadImage.IsUpload(false, 0.5)
    }
    }else{
    self.ImageUpload = nil
    self.UploadImage.IsUpload(false, 0.5)
    }
    }
    
    lazy var Alert:AlertView = {
        let View = AlertView()
        View.alpha = 0
        View.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return View
    }()

}


extension AddRequestPersonal : UIDocumentPickerDelegate {

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

extension AddRequestPersonal : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
         let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage

        dismiss(animated: true) {
        self.ImageUpload = image
        self.UploadImage.IsUpload(true, 0.5)
        }
     }

     fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
         return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
     }

     fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
         return input.rawValue
     }
}




///----------------------------------------------
/// MARK: GET DATA BY API
///----------------------------------------------
extension AddRequestPersonal {
    
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

    let Provider = "\(url + PhoneServiceProvider)"
    AlamofireCall(Url: Provider, HTTP: .get, parameters: nil, Success: {}) { (jsons) in
    for json in jsons {
    if let Service = "lang".localizable == "en" ? json["enProvName"] as? String : json["arProvName"] as? String ,let provider = json["provId"] as? Int {
    self.ServiceProvider.append(Service)
    self.ProviderId.append(provider)
    self.PreferredCompany.optionIds = self.ProviderId
    self.PreferredCompany.optionArray = self.ServiceProvider
    }
        
    if self.ServiceProvider.count == jsons.count {
    if let Provider = self.ProviderId.firstIndex(of: self.Provider) {
    self.PreferredCompany.selectedIndex = Provider
    self.PreferredCompany.ActionTF()
    self.PreferredCompany.table.reloadData()
    self.PreferredCompany.setTitle("\(self.ServiceProvider[Provider])", for: .normal)
    }
    }
    }
    } Err: { _ in}

    PreferredCompany.didSelect{(selectedText , index ,id) in
    self.PreferredCompany.setTitle("\(selectedText)", for: .normal)
    self.Provider = id
    }
    }
    
    
    
    func AddRequest(FileUid:String , imageUid:String) {

    if Auth.auth().currentUser?.uid == nil {
    Error(Err: "ErrorLogIn".localizable)
    return
    }

    guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + PhonePersonalRequest)"
        
    guard let uid = GetUserObject().uid else { return }
    guard let sysToken = GetUserObject().sysToken else { return }
    guard let MonthlyIncome = MonthlyIncomeTF.text else {return}
    guard let CoverageAmount = CoverageAmountTF.text else {return}

    let corporate = CorporateView.YesButton.isOn
    let productsInterested = ProductsInterested.text ?? ""
    let lengthOfBusiness = LengthOfBusiness.text ?? ""
    let Comments = CommentsTF.text ?? ""

    if Emp == 0 || Provider == 0 || MonthlyIncome.TextNull() == false || CoverageAmount.TextNull() == false {
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
        "empTypeId": Emp,
        "provId": Provider,
        "monthlyIncome": MonthlyIncome,
        "amount": CoverageAmount,
        "uploadedFilesUrl": FileUid,
        "uploadedImageUrl": imageUid,
        "corporate": corporate,
        "productInterested": productsInterested,
        "lengthOfBusiness": lengthOfBusiness,
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
