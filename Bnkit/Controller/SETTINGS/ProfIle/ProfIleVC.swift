//
//  ProfIleVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/9/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import MobileCoreServices

class ProfIleVC: UIViewController , UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate , UIViewControllerTransitioningDelegate , MediaBrowserDelegate {
    
    var SizeFont = CGFloat()
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ProfIleView.removeFromSuperview()
        
        self.view.addSubview(self.ProfIleView)
        self.ProfIleView.frame = self.view.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.ProfIleView.captureSession.stopRunning()
    }
    
    func SetUpItems() {
        
    ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    view.addSubview(ViewScroll)
        
    FirstNameTF.delegate = self
    LastNameTF.delegate = self
        
    ViewScroll.addSubview(TopBackView)
    ViewScroll.addSubview(ProfIleImageView)
    ViewScroll.addSubview(AddProfIle)
    ViewScroll.addSubview(UpdateFirstName)
    ViewScroll.addSubview(UpdateLastName)
    ViewScroll.addSubview(SaveButton)
        
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(20), width: view.frame.width - ControlX(20), height: ControlHeight(50))
    
    ProfIleImageView.frame = CGRect(x: view.center.x - ControlWidth(75), y: TopBackView.frame.maxY + ControlY(15), width: ControlWidth(150) , height: ControlWidth(150))
        
    AddProfIle.frame = CGRect(x: ProfIleImageView.frame.maxX - ControlX(18), y: ProfIleImageView.frame.minY - ControlY(8), width: ControlWidth(36), height: ControlWidth(36))
        
    let StackName = UIStackView(arrangedSubviews: [FirstNameTF,LastNameTF])
    StackName.distribution = .fillEqually
    StackName.axis = .horizontal
    StackName.spacing = ControlWidth(13)
    StackName.backgroundColor = .clear
    ViewScroll.addSubview(StackName)
        
    StackName.frame = CGRect(x: ControlX(25), y: ProfIleImageView.frame.maxY + ControlY(50), width: view.frame.width - ControlX(50), height: ControlWidth(25))
        
    UpdateFirstName.frame = CGRect(x: StackName.frame.midX - ControlX(22), y: StackName.frame.minY - ControlY(38), width: ControlWidth(36), height: ControlWidth(36))
        
    UpdateLastName.frame = CGRect(x: StackName.frame.maxX - ControlX(22), y: UpdateFirstName.frame.minY , width: UpdateFirstName.frame.width, height: UpdateFirstName.frame.height)
       
    let StackLabel = UIStackView(arrangedSubviews: [LabelSalary,LabelUtilityBill,LabelBankStatement,LabelHRLetter])
    StackLabel.distribution = .fillEqually
    StackLabel.axis = .vertical
    StackLabel.spacing = ControlHeight(24)
    StackLabel.backgroundColor = .clear
        
    let StackButton = UIStackView(arrangedSubviews: [UploadSalary,UploadUtilityBill,UploadBankStatement,UploadHRLetter])
    StackButton.distribution = .fillEqually
    StackButton.axis = .vertical
    StackButton.spacing = ControlHeight(24)
    StackButton.backgroundColor = .clear
        
    let StackVertical = UIStackView(arrangedSubviews: [PhoneTF,IDTF,EmailTF,PasswordTF])
    StackVertical.axis = .vertical
    StackVertical.spacing = ControlHeight(25)
    StackVertical.distribution = .fillEqually
    StackVertical.backgroundColor = .clear
    ViewScroll.addSubview(StackVertical)
        
    StackVertical.frame = CGRect(x: ControlX(25), y: StackName.frame.maxY + ControlY(25) , width: view.frame.width - ControlX(50), height: ControlWidth(215))
        
    PasswordTF.Icon.trailingAnchor.constraint(equalTo: StackVertical.trailingAnchor, constant: ControlX(5)).isActive = true
       
        
    ViewScroll.addSubview(StackLabel)
    StackLabel.frame = CGRect(x: ControlWidth(20), y: StackVertical.frame.maxY + ControlY(40), width: view.frame.width - ControlWidth(210), height: ControlWidth(232))
        
    ViewScroll.addSubview(StackButton)
    StackButton.frame = CGRect(x: view.frame.maxX - ControlWidth(195), y: StackVertical.frame.maxY + ControlY(40), width: ControlWidth(170), height: ControlWidth(232))
        
    SaveButton.frame = CGRect(x: view.center.x - ControlWidth(60), y: StackButton.frame.maxY + ControlY(50), width: ControlWidth(120), height: ControlWidth(40))
    SaveButton.layer.cornerRadius = SaveButton.frame.height / 2
    LoadData()
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
    Alert.SetIndicator(Style: .load)
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    self.Alert.SetIndicator(Style: .Hidden)
    }
        
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(ControlWidth(30))
    IfIsUpload()
    }
    
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.backgroundColor = .clear
        Scroll.showsVerticalScrollIndicator = false
        return Scroll
    }()
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = LabelForeground
        View.Space = ControlHeight(5)
        View.FontSize = ControlWidth(30)
        View.text = "PROFILE".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }

    lazy var ProfIleImageView:UIImageView = {
        let ImageView = UIImageView()
        ImageView.contentMode = .scaleAspectFill
        ImageView.layer.cornerRadius = ControlWidth(75)
        ImageView.layer.borderWidth = ControlWidth(2)
        ImageView.layer.borderColor = ProfIleColors.cgColor
        ImageView.tintColor = ProfIleColors
        ImageView.layer.masksToBounds = true
        ImageView.backgroundColor = HistoryTxet
        ImageView.image = UIImage(named: "Profile")?.withRenderingMode(.alwaysTemplate)
        ImageView.isUserInteractionEnabled = true
        ImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DidSelect)))
        return ImageView
    }()
    
    @objc func DidSelect() {
        if ProfIleImageView.image != UIImage(named: "Profile")?.withRenderingMode(.alwaysTemplate) {
        let browser = MediaBrowser(delegate: self)
        browser.enableGrid = false
        browser.enableSwipeToDismiss = false
        browser.title = "PROFILE".localizable
        let nc = UINavigationController(rootViewController: browser)
        Present(ViewController: self, ToViewController: nc)
        }
        
//        if ProfIleImageView.image != UIImage(named: "Profile")?.withRenderingMode(.alwaysTemplate) {
//        let datasource = FMImageDataSource(images: [ProfIleImageView.image ?? UIImage(named: "Profile")?.withRenderingMode(.alwaysTemplate) ?? UIImage()])
//        let config = Config(initImageView: ProfIleImageView, initIndex: 0)
//        let fmImageVC = FMImageSlideViewController(datasource: datasource, config: config)
//        fmImageVC.view.frame = ProfIleImageView.frame
//        self.present(fmImageVC, animated: true)
//        }
    }
    
    func numberOfMedia(in mediaBrowser: MediaBrowser) -> Int {
        return 1
    }
    
    func media(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
    let photo = Media(image: ProfIleImageView.image ?? UIImage())
    return photo
    }
    
    lazy var AddProfIle : UIButton = {
        let Button = UIButton(type: .system)
        let Image = UIImage(named: "Add")?.withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        Button.backgroundColor = .clear
        Button.tintColor = LabelForeground
        Button.setBackgroundImage(Image, for: .normal)
        Button.addTarget(self, action: #selector(ActionAddImage), for: .touchUpInside)
        return Button
    }()
    
    
    lazy var ProfIleView: AddProfIleImage = {
        let View = AddProfIleImage()
        View.alpha = 0
        View.ProfIle = self
        View.DoneButton.addTarget(self, action: #selector(DoneAction), for: .touchUpInside)
        View.DismissButton.addTarget(self, action: #selector(CancelAction), for: .touchUpInside)
        View.LibraryButton.addTarget(self, action: #selector(ActionLibrary), for: .touchUpInside)
        return View
    }()
    
    var ChangeProfIle = false
    @objc func DoneAction() {
    if ProfIleView.ImageView.image != nil {
    ProfIleImageView.image = ProfIleView.ImageView.image
    ChangeProfIle = true
    UIView.animate(withDuration: 0.3) {
    self.ProfIleView.alpha = 0
    }
    }
    }
    
    @objc func CancelAction() {
    UIView.animate(withDuration: 0.3) {
    self.ProfIleView.alpha = 0
    }
    }
    
    @objc func ActionLibrary() {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary;
    imagePicker.allowsEditing = true
    imagePicker.modalPresentationStyle = .fullScreen
    imagePicker.transitioningDelegate = self
    imagePicker.modalPresentationStyle = .custom
    present(imagePicker, animated: true, completion: nil)
    }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
         let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
         ProfIleImageView.image = image
         
        dismiss(animated: true) {
        UIView.animate(withDuration: 0.3) {
        self.ProfIleView.alpha = 0
        }
        }
     }
     
     fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
         return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
     }
     
     fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
         return input.rawValue
     }
    
    let transition = CircularTransition()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transtitonMode = .present
        transition.startingPoint = ProfIleView.LibraryButton.center
        transition.circleColor = BackgroundColor
        return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transtitonMode = .dismiss
        transition.startingPoint = ProfIleView.LibraryButton.center
        transition.circleColor = BackgroundColor
        return transition
    }
    
    @objc func ActionAddImage() {
    UIView.animate(withDuration: 0.3) {
    self.ProfIleView.alpha = 1
    }
    }
    
    func LoadData() {
    let firstname = GetUserObject().firsName
    let lastname = GetUserObject().lastName
    let phone = GetUserObject().phone ?? "Phone".localizable
        
    let ID = GetUserObject().personalId ?? "IDNo".localizable
    let email = GetUserObject().email ?? "Email".localizable
        
    self.FirstNameTF.text = firstname?.uppercased()
    self.LastNameTF.text = lastname?.uppercased()

    let Phone = String(phone.enumerated().map { $0 > 0 && $0 % 3 == 0 ? [" ",$1] : [$1]}.joined())
    let id = String(ID.enumerated().map { $0 > 0 && $0 % 3 == 0 ? [" ",$1] : [$1]}.joined())
    self.PhoneTF.attributedPlaceholder = NSAttributedString(string: Phone, attributes:[.foregroundColor: LabelForeground])
    self.IDTF.attributedPlaceholder = NSAttributedString(string: id, attributes:[.foregroundColor: LabelForeground])
    self.EmailTF.attributedPlaceholder = NSAttributedString(string: email, attributes:[.foregroundColor: LabelForeground])

        
    if GetUserObject().photoPath != nil {
    if let url = GetUserObject().photoPath {
    self.ProfIleImageView.sd_setImage(with: Foundation.URL(string: url)) { (Image, Error, type, URL) in}
    }
    }else{
    ProfIleImageView.image = UIImage(named: "Profile")?.withRenderingMode(.alwaysTemplate)
    }
        
    }
    
    lazy var FirstNameTF : FloatingTF = {
        let tf = FloatingTF()
        tf.isEnabled = false
        tf.textAlignment = .center
        tf.textColor = LabelForeground
        tf.Title.textAlignment = .center
        tf.clearButtonMode = .never
        tf.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(27))
        tf.TitleLabelY = 35
        tf.addTarget(self, action: #selector(NameTF(_:)), for: .editingChanged)
        return tf
    }()
    
    lazy var UpdateFirstName : UIButton = {
        let Button = UIButton(type: .system)
        let Image = UIImage(named: "Add")?.withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        Button.backgroundColor = .clear
        Button.tintColor = LabelForeground
        Button.setBackgroundImage(Image, for: .normal)
        Button.addTarget(self, action: #selector(ActionUpdateFirst), for: .touchUpInside)
        return Button
    }()
    

    @objc func ActionUpdateFirst() {
    UpdateFirstName.alpha = 0
    FirstNameTF.isEnabled = true
    FirstNameTF.becomeFirstResponder()
    }
    
    
    lazy var LastNameTF : FloatingTF = {
        let tf = FloatingTF()
        tf.isEnabled = false
        tf.textAlignment = .center
        tf.textColor = LabelForeground
        tf.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(27))
        tf.Title.textAlignment = .center
        tf.clearButtonMode = .never
        tf.TitleLabelY = 35
        tf.addTarget(self, action: #selector(NameTF(_:)), for: .editingChanged)
        return tf
    }()
    
    
    lazy var UpdateLastName : UIButton = {
        let Button = UIButton(type: .system)
        let Image = UIImage(named: "Add")?.withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        Button.backgroundColor = .clear
        Button.tintColor = LabelForeground
        Button.setBackgroundImage(Image, for: .normal)
        Button.addTarget(self, action: #selector(ActionUpdateLast), for: .touchUpInside)
        return Button
    }()
    

    @objc func ActionUpdateLast() {
    UpdateLastName.alpha = 0
    LastNameTF.isEnabled = true
    LastNameTF.becomeFirstResponder()
    }

    @objc func NameTF(_ TF:FloatingTF)  {
    TF.text = TF.text?.uppercased()
    TF.autocapitalizationType = .allCharacters
        
    if LastNameTF.text == "" {
    LastNameTF.Title.text = "LastName".localizable
    TF.isFloatingTitleHidden = true
    }
        
    if FirstNameTF.text == "" {
    FirstNameTF.Title.text = "FirstName".localizable
    TF.isFloatingTitleHidden = true
    }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let whitespaceSet = NSCharacterSet.whitespaces
        let range = string.rangeOfCharacter(from: whitespaceSet)
        if let _ = range {
        if textField.text == "" {
        return false
        }
        return true
        }else {
        return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == FirstNameTF {
    UpdateFirstName.alpha = 1
    FirstNameTF.isEnabled = false
    FirstNameTF.resignFirstResponder()
    }
    if textField == LastNameTF {
    UpdateLastName.alpha = 1
    LastNameTF.isEnabled = false
    LastNameTF.resignFirstResponder()
    }
    }
    
    
    lazy var PhoneTF : UITextField = {
        let tf = FloatingTF()
        tf.textAlignment = .center
        tf.isEnabled = false
        tf.SetUpIcon(LeftOrRight: true)
        return tf
    }()
    
    lazy var IDTF : UITextField = {
        let tf = FloatingTF()
        tf.textAlignment = .center
        tf.isEnabled = false
        return tf
    }()
    
    
    lazy var EmailTF : UITextField = {
        let tf = FloatingTF()
        tf.textAlignment = .center
        tf.isEnabled = false
        tf.SetUpIcon(LeftOrRight: true)
        return tf
    }()
    
    lazy var PasswordTF : FloatingTF = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "Password".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.textAlignment = .center
        tf.SetUpIcon(LeftOrRight: false)
        tf.Icon.transform = "lang".localizable == "en" ? CGAffineTransform(rotationAngle: .pi) : .identity 
        tf.Icon.contentMode = .scaleAspectFit
        tf.addTarget(self, action: #selector(ActionPassword), for: .editingDidBegin)
        return tf
    }()
    
    @objc func ActionPassword() {
    PasswordTF.resignFirstResponder()
    PresentByNavigation(ViewController: self, ToViewController: ChangePasswordVC())
    }
    
    lazy var SaveButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.titleLabel?.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(18))
        Button.setTitle("SAVE".localizable, for: .normal)
        Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.titleLabel?.textAlignment = .center
        Button.addTarget(self, action: #selector(ActionSave), for: .touchUpInside)
        return Button
    }()
    
    
    
    func SetUpPopUp(text:String) {
    let PopUp = PopUpView()
    PopUp.text = text
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUp)
    }
    

    func Error(Err:String) {
    self.Alert.SetIndicator(Style: .error)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
    self.SetUpPopUp(text: Err)
    }
    }


    // lod Files
    
    var URL : URL?
    var ButtonTag : Int?
    lazy var UploadSalary : UploadFilesButton = {
        let view = UploadFilesButton()
        view.backgroundColor = .clear
        view.LabelText = "UploadFiles".localizable
        view.Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(9.5))
        view.Cancel.addTarget(self, action: #selector(ActionCancelSalary), for: .touchUpInside)
        view.Button.addTarget(self, action: #selector(ActionUploadSalary), for: .touchUpInside)
        return view
    }()
    
    @objc func ActionUploadSalary() {
    if UploadSalary.Cancel.alpha == 0 {
    ButtonTag = 0
    DocumentPicker()
    }
    }

    @objc func ActionCancelSalary() {
    ActionDelete(URL: GetUserObject().salary ?? "", Files: .Salary)
    }
    
    lazy var LabelSalary : UILabel = {
        let Label = UILabel()
        Label.text = "*Salary".localizable
        Label.font = UIFont(name: "Campton-Light", size: ControlWidth(12))
        Label.textColor = LabelForeground
        Label.backgroundColor = .clear
        return Label
    }()
    
    ///
    ///

    lazy var UploadUtilityBill : UploadFilesButton = {
        let view = UploadFilesButton()
        view.backgroundColor = .clear
        view.LabelText = "UploadFiles".localizable
        view.Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(9.5))
        view.Cancel.addTarget(self, action: #selector(ActionCancelUtilityBill), for: .touchUpInside)
        view.Button.addTarget(self, action: #selector(ActionUploadUtilityBill), for: .touchUpInside)
        return view
    }()
    
    @objc func ActionUploadUtilityBill() {
    if UploadUtilityBill.Cancel.alpha == 0 {
    ButtonTag = 1
    DocumentPicker()
    }
    }


    @objc func ActionCancelUtilityBill() {
    ActionDelete(URL: GetUserObject().utility ?? "", Files: .UtilityBill)
    }

    lazy var LabelUtilityBill : UILabel = {
        let Label = UILabel()
        Label.text = "*Utility Bill".localizable
        Label.font = UIFont(name: "Campton-Light", size: ControlWidth(12))
        Label.textColor = LabelForeground
        Label.backgroundColor = .clear
        return Label
    }()
    
    ///
    ///
    
    lazy var UploadBankStatement : UploadFilesButton = {
        let view = UploadFilesButton()
        view.backgroundColor = .clear
        view.LabelText = "UploadFiles".localizable
        view.Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(9.5))
        view.Cancel.addTarget(self, action: #selector(ActionCancelBankStatement), for: .touchUpInside)
        view.Button.addTarget(self, action: #selector(ActionUploadBankStatement), for: .touchUpInside)
        return view
    }()
    
    @objc func ActionUploadBankStatement() {
    if UploadBankStatement.Cancel.alpha == 0 {
    ButtonTag = 2
    DocumentPicker()
    }
    }


    @objc func ActionCancelBankStatement() {
    ActionDelete(URL: GetUserObject().bankStatement ?? "", Files: .BankStatement)
    }

    lazy var LabelBankStatement : UILabel = {
        let Label = UILabel()
        Label.text = "*Bank Statement".localizable
        Label.font = UIFont(name: "Campton-Light", size: ControlWidth(12))
        Label.textColor = LabelForeground
        Label.backgroundColor = .clear
        return Label
    }()
    
    ///
    ///
    
    lazy var UploadHRLetter : UploadFilesButton = {
        let view = UploadFilesButton()
        view.backgroundColor = .clear
        view.LabelText = "UploadFiles".localizable
        view.Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(9.5))
        view.Cancel.addTarget(self, action: #selector(ActionCancelHRLetter), for: .touchUpInside)
        view.Button.addTarget(self, action: #selector(ActionUploadHRLetter), for: .touchUpInside)
        return view
    }()
    
    @objc func ActionUploadHRLetter() {
    if UploadHRLetter.Cancel.alpha == 0 {
    ButtonTag = 3
    DocumentPicker()
    }
    }


    @objc func ActionCancelHRLetter() {
    ActionDelete(URL: GetUserObject().hrletter ?? "", Files: .HRLetter)
    }

    lazy var LabelHRLetter : UILabel = {
        let Label = UILabel()
        Label.text = "*HR Letter / Self Employed".localizable
        Label.font = UIFont(name: "Campton-Light", size: ControlWidth(12))
        Label.textColor = LabelForeground
        Label.backgroundColor = .clear
        return Label
    }()
    
    ///
    ///
    
    func DocumentPicker() {
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
    
    
    func PutFile(FileSand:URL , Child:String , completion: @escaping ((String) -> Void)) {
    self.Alert.SetIndicator(Style: .load)
    guard let phone = GetUserObject().phone else {return}
    let riversRef = Storage.storage().reference().child("DataUser").child(phone).child("Files").child(Child)
    riversRef.putFile(from: FileSand, metadata: nil) { metadata, error in
    if let error = error {
    self.Error(Err: error.localizedDescription)
    return
    }

    riversRef.downloadURL { (url, error) in
    if let error = error {
    self.Error(Err:error.localizedDescription)
    return
    }
    guard let downloadURL = url else {return}
    completion(downloadURL.absoluteString)
    }
    }
    }


    
    func SetURLFiles(Url:String,Files:ProfIleFiles)  {
        if let data = defaults.object(forKey: "User") as? Data {
        if var decodedPeople = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any] {
        
        switch Files {
        case .Salary:
        decodedPeople.updateValue(Url, forKey: "salary")
        case .UtilityBill:
        decodedPeople.updateValue(Url, forKey: "utility")
        case .BankStatement:
        decodedPeople.updateValue(Url, forKey: "bankStatement")
        case .HRLetter:
        decodedPeople.updateValue(Url, forKey: "hrletter")
        }
            
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedPeople)
        defaults.set(encodedData, forKey: "User")
        defaults.synchronize()
        IfIsUpload()
        }
        }
    }
    
    func IfIsUpload() {
    if GetUserObject().salary != "" && GetUserObject().salary != nil {
    UploadSalary.IsUpload(true, 0.5, false)
    }else{
    UploadSalary.IsUpload(false, 0.5, false)
    }
        
    if GetUserObject().utility != "" && GetUserObject().utility != nil {
    UploadUtilityBill.IsUpload(true, 0.5, false)
    }else{
    UploadUtilityBill.IsUpload(false, 0.5, false)
    }
        
    if GetUserObject().bankStatement != "" && GetUserObject().bankStatement != nil {
    UploadBankStatement.IsUpload(true, 0.5, false)
    }else{
    UploadBankStatement.IsUpload(false, 0.5, false)
    }
        
    if GetUserObject().hrletter != "" && GetUserObject().hrletter != nil {
    UploadHRLetter.IsUpload(true, 0.5, false)
    }else{
    UploadHRLetter.IsUpload(false, 0.5, false)
    }
    }
    
    
    lazy var Alert:AlertView = {
        let View = AlertView()
        View.alpha = 0
        View.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return View
    }()
}

public enum ProfIleFiles {
    case Salary,UtilityBill,BankStatement,HRLetter
}

extension ProfIleVC : UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let url = defaults.string(forKey: "API") else{return}
    guard let FileUrl = urls.first else{return}
    guard let size = try? FileManager.default.attributesOfItem(atPath: FileUrl.path) else {return}

    if let size = size[FileAttributeKey.size] as? NSNumber {
    let floatSize = Float(Int(truncating: size) / 1024)
    if (floatSize / 1024) > 5 {
    self.Error(Err: "ErrorFiles".localizable)
    return
    }
 
    switch ButtonTag {
    case 0:
    UploadSalary.IsUpload(true, 0.5, false)
    PutFile(FileSand: FileUrl, Child: "*Salary") { Url in
    self.SentToApi(api: "\(url + PhoneUpdateSalaryPath)", Url: Url ,Files: .Salary)
    }
    case 1:
    UploadUtilityBill.IsUpload(true, 0.5, false)
    PutFile(FileSand: FileUrl, Child: "*UtilityBill") { Url in
    self.SentToApi(api: "\(url + PhoneUpdateUtilityPath)", Url: Url ,Files: .UtilityBill)
    }
    case 2:
    UploadBankStatement.IsUpload(true, 0.5, false)
    PutFile(FileSand: FileUrl, Child: "*BankStatement") { Url in
    self.SentToApi(api: "\(url + PhoneUpdateBankStatementPath)", Url: Url ,Files: .BankStatement)
    }
    case 3:
    UploadHRLetter.IsUpload(true, 0.5, false)
    PutFile(FileSand: FileUrl, Child: "*HRLetter") { Url in
    self.SentToApi(api: "\(url + PhoneUpdateHrletterPath)", Url: Url ,Files:.HRLetter)
    }
    default:
    break
    }

    }
    }
    

}


///----------------------------------------------
/// MARK: GET DATA BY API
///----------------------------------------------
extension ProfIleVC {
    
    @objc func ActionSave() {
   
    guard let url = defaults.string(forKey: "API") else{return}
    let ProfileApi = "\(url + UpdateProfile)"
    let PhotoApi = "\(url + UpdateProfilePhoto)"
    
    guard let uid = GetUserObject().uid else {return}
    guard let phone = GetUserObject().phone else {return}
    guard let sysToken = GetUserObject().sysToken else {return}
    let firstName = GetUserObject().firsName?.uppercased() ?? ""
    let lastName = GetUserObject().lastName?.uppercased() ?? ""
        
    guard let FirstName = self.FirstNameTF.text else {return}
    guard let LastName = self.LastNameTF.text else {return}
    let dateformat = DateFormatter()
    dateformat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                
    let UpdateProfile:[String:Any] = [
    "uid": uid,
    "sysToken": sysToken,
    "firsName": FirstName,
    "lastName": LastName,
    "birth": dateformat.string(from: Date())
    ]
        
    if FirstName == firstName && LastName == lastName && !ChangeProfIle {
    self.navigationController?.popViewController(animated: true)
    return
    }else if FirstName == "" || LastName == "" {
    self.Alert.SetIndicator(Style: .load)
    self.Error(Err: "ErrorFirstAndLastName".localizable)
    return
    }else if FirstName == firstName && LastName == lastName && ChangeProfIle {
    self.Alert.SetIndicator(Style: .load)
    self.UpdatePhoto(PhotoApi: PhotoApi, phone: phone, uid: uid, sysToken: sysToken)
    return
    }else{
    self.Alert.SetIndicator(Style: .load)
      
    AlamofireCall(Url: ProfileApi, HTTP: .put, parameters: UpdateProfile,encoding: JSONEncoding.default) {
        
    if let data = defaults.object(forKey: "User") as? Data {
    if var decodedPeople = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any] {
    decodedPeople.updateValue(FirstName, forKey: "firsName")
    decodedPeople.updateValue(LastName, forKey: "lastName")
 
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedPeople)
    defaults.set(encodedData, forKey: "User")
    defaults.synchronize()
    }
    }
    
    self.UpdatePhoto(PhotoApi: PhotoApi, phone: phone, uid: uid, sysToken: sysToken)
    } Err: { error in
    self.Error(Err: error)
    }
    }
    }
    
    func UpdatePhoto(PhotoApi:String,phone:String,uid:String,sysToken:String) {
    if ChangeProfIle {
    guard let data = ProfIleImageView.image?.jpegData(compressionQuality: 0.75) else {return}
    Storag(child: ["DataUser",phone,"ProfIle"], image: data) { (photoPath) in
    let UpdatePhoto = [
    "uid": uid,
    "sysToken": sysToken,
    "photoPath": photoPath
    ]

    AlamofireCall(Url: PhotoApi, HTTP: .put, parameters: UpdatePhoto,encoding: JSONEncoding.default) {
    if let data = defaults.object(forKey: "User") as? Data {
    if var decodedPeople = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any] {
    decodedPeople.updateValue(photoPath, forKey: "photoPath")
    
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedPeople)
    defaults.set(encodedData, forKey: "User")
    defaults.synchronize()
    }
    }
        
    self.ChangeProfIle = false
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    self.ButtonAction()
    NotificationCenter.default.post(name: LogInController.NotificationSignOut, object: nil)
    }
    } Err: { err in
    self.Error(Err: err)
    }
    } Err: { (err) in
    self.Error(Err: err)
    }
    }else{
    self.Alert.SetIndicator(Style: .success)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    self.ButtonAction()
    NotificationCenter.default.post(name: LogInController.NotificationSignOut, object: nil)
    }
    }
    }
    
    
    func SentToApi(api:String ,Url:String,Files:ProfIleFiles) {
    guard let uid = GetUserObject().uid else {return}
    guard let sysToken = GetUserObject().sysToken else {return}
    let parameters = ["uid": uid,
                      "sysToken": sysToken,
                      "filePpath": Url]
        
    AlamofireCall(Url: api, HTTP: .put, parameters: parameters,encoding: JSONEncoding.default) {
    self.Alert.SetIndicator(Style: .success)
    self.SetURLFiles(Url: Url, Files: Files)
    } Err: { error in
    self.Error(Err: error)
    }
    }
    
    func ActionDelete(URL:String,Files:ProfIleFiles) {
    self.Alert.SetIndicator(Style: .load)
    if URL != "" {
    Storage.storage().reference(forURL: URL).delete { error in}
    }

    guard let url = defaults.string(forKey: "API") else{return}
    switch Files {
    case .Salary:
    self.SentToApi(api: "\(url + PhoneUpdateSalaryPath)", Url: "", Files: Files)
    case .UtilityBill:
    self.SentToApi(api: "\(url + PhoneUpdateUtilityPath)", Url: "", Files: Files)
    case .BankStatement:
    self.SentToApi(api: "\(url + PhoneUpdateBankStatementPath)", Url: "", Files: Files)
    case .HRLetter:
    self.SentToApi(api:  "\(url + PhoneUpdateHrletterPath)", Url: "", Files: Files)
    }
    }
    
}
