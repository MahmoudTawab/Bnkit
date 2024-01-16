//
//  SignUpController.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/5/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import CoreData
import FlagPhoneNumber
import FirebaseFirestore

class SignUpController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIViewControllerTransitioningDelegate, UITextFieldDelegate ,FPNTextFieldDelegate {
     
    var Error : SignUpError?
    var verification:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = BackgroundColor
        SetUpItems()
    }

    func SetUpItems() {

        ViewScroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(ViewScroll)
        
        let StackHorizontal = UIStackView(arrangedSubviews: [FirstNameTF,LastNameTF])
        StackHorizontal.distribution = .fillEqually
        StackHorizontal.axis = .horizontal
        StackHorizontal.spacing = ControlHeight(15)
        StackHorizontal.backgroundColor = .clear
    
        let StackVertical = UIStackView(arrangedSubviews: [StackHorizontal,PhoneNoTF,EmailTF,PasswordTF,PasswordConfirmTF,IDNoTF])
        StackVertical.axis = .vertical
        StackVertical.spacing = ControlHeight(45)
        StackVertical.distribution = .fillEqually
        StackVertical.backgroundColor = .clear
        
        ViewScroll.addSubview(SignUpLabel)
        ViewScroll.addSubview(StackVertical)
        
        ViewScroll.addSubview(FrontIdImage)
        ViewScroll.addSubview(BackIdImage)
        ViewScroll.addSubview(CheckboxButton)
        ViewScroll.addSubview(IAcceptUserLabel)
        ViewScroll.addSubview(LeftButton)
        ViewScroll.addSubview(RightButton)
        ViewScroll.addSubview(StackFrontId)
        ViewScroll.addSubview(StackBackId)
        
        SignUpLabel.frame = CGRect(x: ControlX(20), y: ControlY(30), width: view.frame.width - ControlX(40), height: ControlWidth(40))
        
        StackVertical.frame = CGRect(x: ControlX(25), y: ControlY(100), width: view.frame.width - ControlX(50), height: ControlWidth(465))
                
        StackFrontId.frame = CGRect(x: ControlX(25), y: StackVertical.frame.maxY + ControlX(25), width: StackVertical.frame.width / 2.3, height: ControlWidth(40))
        
        StackBackId.frame = CGRect(x: StackVertical.frame.maxX - StackFrontId.frame.width, y: StackFrontId.frame.minY , width: StackFrontId.frame.width, height: StackFrontId.frame.height)

        FrontIdImage.frame = CGRect(x: ControlX(25), y: StackBackId.frame.maxY + ControlX(20), width: StackFrontId.frame.width, height: ControlWidth(105))
        
        BackIdImage.frame = CGRect(x: StackVertical.frame.maxX - StackFrontId.frame.width, y: FrontIdImage.frame.minY, width: StackFrontId.frame.width, height: FrontIdImage.frame.height)

        CheckboxButton.frame = CGRect(x: ControlX(20), y: BackIdImage.frame.maxY + ControlY(30), width: ControlWidth(40), height: ControlWidth(40))
        IAcceptUserLabel.frame = CGRect(x: ControlX(65), y: BackIdImage.frame.maxY + ControlY(40), width: view.frame.width - ControlWidth(130), height: ControlWidth(20))
        
        LeftButton.frame = CGRect(x: ControlWidth(20), y: CheckboxButton.frame.maxY + ControlY(30), width: ControlWidth(45), height: ControlWidth(60))
        
        RightButton.frame = CGRect(x: view.frame.maxX - ControlWidth(65), y: CheckboxButton.frame.maxY + ControlY(30), width: ControlWidth(45), height: ControlWidth(60))
        
        PhoneNoTF.delegate = self
        IDNoTF.delegate = self
        
        view.addSubview(Alert)
        Alert.frame = view.bounds
        Alert.SetIndicator(Style: .load)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.Alert.SetIndicator(Style: .Hidden)
        }
        
        // MARK: - ViewScroll contentSize height
        ViewScroll.updateContentViewSize(ControlWidth(30))
        SetUpPhoneNumber()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
    
    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.keyboardDismissMode = .interactive
        Scroll.backgroundColor = BackgroundColor
        Scroll.showsVerticalScrollIndicator = false
        Scroll.delegate = self
        Scroll.bounces = true
        return Scroll
    }()

    lazy var SignUpLabel : UILabel = {
    let Label = UILabel()
    Label.textAlignment = .left
    Label.backgroundColor = .clear
    Label.textColor = LabelForeground
    Label.text = "CREATEACCOUNT".localizable
    Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(30))
    return Label
    }()
    
    lazy var FirstNameTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string:"FirstName".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()

    lazy var LastNameTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string:"LastName".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    

    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
    var repository: FPNCountryRepository = FPNCountryRepository()
    let bottomLine = UIView()
    let PhoneLabel = UILabel()
    lazy var PhoneNoTF : FPNTextField = {
        let tf = FPNTextField()
        tf.displayMode = .list
        tf.delegate = self
        tf.textColor = LabelForeground
        tf.attributedPlaceholder = NSAttributedString(string: "Phone".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.addTarget(self, action: #selector(PhoneEditingDidEnd), for: .editingDidEnd)
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = LabelForeground
        tf.addSubview(bottomLine)
        
        bottomLine.leftAnchor.constraint(equalTo: tf.leftAnchor).isActive = true
        bottomLine.rightAnchor.constraint(equalTo: tf.rightAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: tf.bottomAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: ControlHeight(1)).isActive = true
        
        ///
        PhoneLabel.alpha = 0
        PhoneLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        PhoneLabel.backgroundColor = .clear
        PhoneLabel.text = "ErrorPhone".localizable
        PhoneLabel.translatesAutoresizingMaskIntoConstraints = false
        PhoneLabel.font = UIFont(name: "Campton-Light", size: ControlWidth(13))
        tf.addSubview(PhoneLabel)
        
        PhoneLabel.leftAnchor.constraint(equalTo: tf.leftAnchor).isActive = true
        PhoneLabel.rightAnchor.constraint(equalTo: tf.rightAnchor).isActive = true
        PhoneLabel.topAnchor.constraint(equalTo: tf.bottomAnchor , constant: ControlHeight(5)).isActive = true
        PhoneLabel.heightAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true
        return tf
    }()
    
    
    func SetUpPhoneNumber() {
    listController.setup(repository: PhoneNoTF.countryRepository)
    listController.didSelect = { [weak self] country in
    self?.PhoneNoTF.setFlag(countryCode: country.code)
    }
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
    print(name, dialCode, code)
    }
    
    var isValidNumber = false
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
    bottomLine.backgroundColor = isValid ?  LabelForeground : #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    PhoneLabel.alpha = isValid ? 0 : 1
    isValidNumber = isValid
    }
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        listController.title = "Select your country".localizable
        listController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshCountries))
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissCountries))
        listController.navigationItem.rightBarButtonItem?.tintColor = LabelForeground
        listController.navigationItem.leftBarButtonItem?.tintColor = LabelForeground
        
        listController.searchController.searchBar.barTintColor = BackgroundColor
        listController.searchController.searchBar.backgroundColor = BackgroundColor
        
        Present(ViewController: self, ToViewController: navigationViewController)
    }
    
    @objc func refreshCountries() {
    listController.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    @objc func dismissCountries() {
    listController.dismiss(animated: true, completion: nil)
    }
    
    @objc func PhoneEditingDidEnd() {
    bottomLine.backgroundColor = LabelForeground
    PhoneLabel.alpha = 0
    }
    
    
    lazy var EmailTF : UITextField = {
        let tf = FloatingTF()
        tf.keyboardType = .emailAddress
        tf.attributedPlaceholder = NSAttributedString(string: "Email".localizable, attributes:[.foregroundColor: LabelForeground])
        return tf
    }()
    
    
    lazy var PasswordTF : UITextField = {
        let tf = FloatingTF()
        tf.attributedPlaceholder = NSAttributedString(string: "Password".localizable, attributes:[.foregroundColor: LabelForeground])
        
        return tf
    }()
    
    lazy var PasswordConfirmTF : FloatingTF = {
        let tf = FloatingTF()
        tf.isSecureTextEntry = true
        tf.attributedPlaceholder = NSAttributedString(string: "PasswordConfirm".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.clearButtonMode = .never
        tf.addTarget(self, action: #selector(PasswordConfirm), for: .editingChanged)
        return tf
    }()
    
    
    var Successfully = false
    let image1 = UIImage(named: "group272")?.withInset(UIEdgeInsets(top: ControlY(2), left: ControlX(4), bottom: ControlY(2), right: ControlX(4)))
    let image2 = UIImage(named: "group269")?.withInset(UIEdgeInsets(top: ControlY(2), left: ControlX(4), bottom: ControlY(2), right: ControlX(4)))
    @objc func PasswordConfirm() {
    if (PasswordConfirmTF.text?.count)! > 0 {
    PasswordConfirmTF.SetUpIcon(LeftOrRight: false)
    if PasswordConfirmTF.text == PasswordTF.text {
    PasswordConfirmTF.Icon.setBackgroundImage(image1, for: .normal)
    Successfully = true
    }else{
    PasswordConfirmTF.Icon.setBackgroundImage(image2, for: .normal)
    Successfully = false
    }
    PasswordConfirmTF.Icon.transform = .identity
    }else{
    PasswordConfirmTF.Icon.removeFromSuperview()
    }
    }
    
    lazy var IDNoTF : FloatingTF = {
        let tf = FloatingTF()
        tf.ShowError = false
        tf.attributedPlaceholder = NSAttributedString(string: "IDNo".localizable, attributes:[.foregroundColor: LabelForeground])
        tf.addTarget(self, action: #selector(NoErrorID), for: .editingChanged)
        tf.keyboardType = .numberPad
        return tf
    }()
    
    var ErrorID = true
    @objc func NoErrorID() {
    if (IDNoTF.text?.count)! != 14 || IDNoTF.text?.isValidCivilID == false {
    ErrorID = true
        
    if IDNoTF.isFirstResponder {
    IDNoTF.TitleError.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    IDNoTF.bottomLineLayer.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    IDNoTF.TitleError.text = "ErrorID".localizable
    IDNoTF.TitleError.alpha = 1
    IDNoTF.IconError.alpha = 1
    }else{
    IDNoTF.TitleError.text = ""
    IDNoTF.TitleError.alpha = 0
    IDNoTF.IconError.alpha = 0
    IDNoTF.bottomLineLayer.backgroundColor = #colorLiteral(red: 0.3808627231, green: 0.3846336411, blue: 0.3846336411, alpha: 1)
    }
        
    }else{
    IDNoTF.TitleError.alpha = 0
    IDNoTF.IconError.alpha = 0
    IDNoTF.bottomLineLayer.backgroundColor = #colorLiteral(red: 0.3808627231, green: 0.3846336411, blue: 0.3846336411, alpha: 1)
    ErrorID = false
    }
    }

    lazy var FrontIdLabel : UILabel = {
        let Label = UILabel()
        Label.text = "FrontID".localizable
        Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(18))
        Label.backgroundColor = .clear
        Label.textColor = LabelForeground
        return Label
    }()
    
    lazy var  CancelFrontId : UIButton = {
        let Button = UIButton(type: .system)
        let image = UIImage(named: "group269")?.withInset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        Button.backgroundColor = .clear
        Button.tintColor = LabelForeground
        Button.setBackgroundImage(image, for: .normal)
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.widthAnchor.constraint(equalToConstant: ControlWidth(40)).isActive = true
        Button.addTarget(self, action: #selector(ActionCancelFront), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionCancelFront() {
     FrontIdImage.image = UIImage(named: "group2490")
    }
    
    
    lazy var StackFrontId : UIStackView = {
        let Stack = UIStackView(arrangedSubviews: [FrontIdLabel,CancelFrontId])
        Stack.axis = .horizontal
        Stack.spacing = ControlWidth(10)
        Stack.distribution = .equalSpacing
        Stack.alignment = .fill
        Stack.backgroundColor = .clear
        return Stack
    }()
    
    lazy var FrontIdImage : UIImageView = {
        let Image = UIImageView()
        Image.backgroundColor = .clear
        Image.image = UIImage(named: "group2490")
        Image.contentMode = .scaleToFill
        Image.layer.cornerRadius = ControlHeight(12)
        Image.layer.borderWidth = ControlHeight(3)
        Image.layer.borderColor = LabelForeground.cgColor
        Image.clipsToBounds = true
        Image.isUserInteractionEnabled = true
        Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ActionFrontId)))
        return Image
    }()
    
    @objc func ActionFrontId() {
    BackIdOrFrontId = true
    ActionAddImage()
    }
    
    lazy var BackIdLabel : UILabel = {
           let Label = UILabel()
           Label.text = "BackID".localizable
           Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(18))
           Label.backgroundColor = .clear
           Label.textColor = LabelForeground
           return Label
    }()
    
    lazy var  CancelBackId : UIButton = {
        let Button = UIButton(type: .system)
        let image = UIImage(named: "group269")?.withInset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        Button.backgroundColor = .clear
        Button.tintColor = LabelForeground
        Button.setBackgroundImage(image, for: .normal)
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.widthAnchor.constraint(equalToConstant: ControlWidth(40)).isActive = true
        Button.addTarget(self, action: #selector(ActionCancelBack), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionCancelBack() {
    BackIdImage.image = UIImage(named: "group2489")
    }
    
    lazy var StackBackId : UIStackView = {
        let Stack = UIStackView(arrangedSubviews: [BackIdLabel,CancelBackId])
        Stack.axis = .horizontal
        Stack.spacing = ControlWidth(10)
        Stack.distribution = .equalSpacing
        Stack.alignment = .fill
        Stack.backgroundColor = .clear
        return Stack
    }()
    
    lazy var BackIdImage : UIImageView = {
        let Image = UIImageView()
        Image.backgroundColor = .clear
        Image.image = UIImage(named: "group2489")
        Image.contentMode = .scaleToFill
        Image.layer.cornerRadius = ControlHeight(12)
        Image.layer.borderWidth = ControlHeight(3)
        Image.layer.borderColor = LabelForeground.cgColor
        Image.clipsToBounds = true
        Image.isUserInteractionEnabled  = true
        Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ActionBackId)))
        return Image
    }()
    
    @objc func ActionBackId() {
     BackIdOrFrontId = false
     ActionAddImage()
    }
    
    
    lazy var ProfIleView: AddProfIleImage = {
        let View = AddProfIleImage()
        View.alpha = 0
        View.SignUp = self
        View.DoneButton.addTarget(self, action: #selector(DoneAction), for: .touchUpInside)
        View.DismissButton.addTarget(self, action: #selector(CancelAction), for: .touchUpInside)
        View.LibraryButton.addTarget(self, action: #selector(ActionLibrary), for: .touchUpInside)
        return View
    }()
    
    
    var BackIdOrFrontId = Bool()
    @objc func DoneAction() {
    if ProfIleView.ImageView.image != nil {
    if BackIdOrFrontId {
    FrontIdImage.image = ProfIleView.ImageView.image
    }else{
    BackIdImage.image = ProfIleView.ImageView.image
    }
    UIView.animate(withDuration: 0.3) {
    self.ProfIleView.alpha = 0
    self.navigationController?.navigationBar.alpha = 1
    }
    }
    }
    
    @objc func CancelAction() {
    UIView.animate(withDuration: 0.3) {
    self.ProfIleView.alpha = 0
    self.navigationController?.navigationBar.alpha = 1
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
        
         if BackIdOrFrontId {
         FrontIdImage.image = image
         }else{
         BackIdImage.image = image
         }
         
        dismiss(animated: true) {
        UIView.animate(withDuration: 0.3) {
        self.ProfIleView.alpha = 0
        self.navigationController?.navigationBar.alpha = 1
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
    self.navigationController?.navigationBar.alpha = 0
    }
    }
    
    lazy var CheckboxButton : Checkbox = {
        let Button = Checkbox(type: .system)
        Button.backgroundColor = .clear
        Button.addTarget(self, action: #selector(ActionCheckbox), for: .touchUpInside)
        Button.Button.addTarget(self, action: #selector(ActionCheckbox), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionCheckbox() {
    if CheckboxButton.tag == 0 {
    RightButton.tintColor =  #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
    CheckboxButton.tag = 1
    }else{
    RightButton.tintColor =  #colorLiteral(red: 0.6817588806, green: 0.5006659627, blue: 0.5454977751, alpha: 1)
    CheckboxButton.tag = 0
    }
    }

    lazy var IAcceptUserLabel : UILabel = {
        let Label = UILabel()
        Label.font = UIFont(name: "Campton-Light", size: ControlWidth(16))
        Label.text = "AcceptAgreement".localizable
        Label.textColor = LabelForeground
        Label.backgroundColor = .clear
        Label.isUserInteractionEnabled = true
        Label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ActionIAcceptUser)))
        return Label
    }()
    
    @objc func ActionIAcceptUser() {
    PresentByNavigation(ViewController: self, ToViewController: AcceptUserController())
    }

    lazy var LeftButton : UIButton = {
        let Button = UIButton(type: .custom)
        let image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        Button.tintColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.backgroundColor = .clear
        Button.setBackgroundImage(image, for: .normal)
        Button.addTarget(self, action: #selector(ActionLeft), for: .touchUpInside)
        return Button
    }()

    @objc func ActionLeft() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var RightButton : UIButton = {
        let Button = UIButton(type: .custom)
        let image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        Button.tintColor = #colorLiteral(red: 0.6817588806, green: 0.5006659627, blue: 0.5454977751, alpha: 1)
        Button.backgroundColor = .clear
        Button.setBackgroundImage(image, for: .normal)
        Button.transform = CGAffineTransform(rotationAngle: .pi)
        Button.addTarget(self, action: #selector(ActionRight), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionRight() {
    guard let email = EmailTF.text else {return}
    if email.TextNull() == false && PasswordTF.text?.TextNull() == false && PasswordConfirmTF.text?.TextNull() == false && FirstNameTF.text?.TextNull() == false && LastNameTF.text?.TextNull() == false && ErrorID {
    Error(Err: "FillInInformationCorrectly".localizable)
    return
    }else if isValidEmail(emailID: email) == false {
    Error(Err: "ErrorEmail".localizable)
    return
    }else if (PasswordTF.text?.count)! < 6 || (PasswordConfirmTF.text?.count)! < 6 || Successfully == false {
    Error(Err: "ErrorPasswordCorrectly".localizable)
    return
    }else if FirstNameTF.text == "" || LastNameTF.text == "" {
    Error(Err: "ErrorFirstAndLastName".localizable)
    return
    }else if CheckboxButton.Button.tag == 0 {
    Error(Err: "ErrorUserAgreement".localizable)
    return
    }else if isValidNumber == false {
    Error(Err: "ErrorPhone".localizable)
    return
    }else if ErrorID {
    Error(Err: "ErrorID".localizable)
    return
    }else{
    self.Alert.SetIndicator(Style: .load)
    ActionSignUp()
    }
    }
    
    var Email = String()
    var Phone = String()
    func ActionSignUp() {
    guard let email = EmailTF.text else {return}
    guard let phone = PhoneNoTF.text else {return}
        
    if email != Email || phone != Phone {
    ActionSignUpAPI()
    }else{
    ReSendSms()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
extension SignUpController {
    
    
    func ActionSignUpAPI() {
    
    guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + CheckClientAsync)"

    guard let email = EmailTF.text else {return}
    guard let Phone = PhoneNoTF.text else {return}
    let PhoneNew = Phone.replacingOccurrences(of: " ", with: "")

    let parameters = ["sysToken": SysTokenCheckClient,"email": email,"phone": PhoneNew]
    AlamofireCall(Url: api, HTTP: .get, parameters: parameters, Success: {}, Array: {_ in}) { json in
    self.Error = SignUpError(json: json)

    if self.Error?.emailUsed == true {
    self.Error(Err: "EmailIsUsed".localizable)
    self.EmailTF.becomeFirstResponder()
    return
    }else if self.Error?.phoneValid == false {
    self.Error(Err: "ErrorPhone".localizable)
    self.PhoneNoTF.becomeFirstResponder()
    return
    }else if self.Error?.phoneUsed == true {
    self.Error(Err: "PhoneNumberIsUsed".localizable)
    self.PhoneNoTF.becomeFirstResponder()
    return
    }else{
    if let OTP = self.Error?.verification {
    self.Alert.SetIndicator(Style: .Hidden)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
    let Verflclatlon = VerflclatlonController()
    self.Email = email
    self.Phone = Phone
    self.verification = "\(OTP)"
    Verflclatlon.SignUp = self
    PresentByNavigation(ViewController: self, ToViewController: Verflclatlon)
    }
    }
    }
    } Err: { error in
    self.Error(Err: error)
    }
    }
    
    
    func ReSendSms() {
    guard let url = defaults.string(forKey: "API") else{return}
    let api = "\(url + ReSendSmsAsync)"
    guard let Phone = PhoneNoTF.text else {return}
    let PhoneNew = Phone.replacingOccurrences(of: " ", with: "")
    guard let verification = verification else {return}
        
    guard let Url = URL(string:api) else {return}
    var components = URLComponents(url: Url, resolvingAgainstBaseURL: false)!
    components.queryItems = [URLQueryItem(name: "sysToken", value: SysTokenReSendSms),
                             URLQueryItem(name: "phone", value: PhoneNew),
                             URLQueryItem(name: "verification", value: verification)]
        
    guard let ComponentsUrl = components.url?.absoluteString else {return}
    AlamofireCall(Url: ComponentsUrl, HTTP: .get, parameters: nil) {
    self.verification = verification
    self.Alert.SetIndicator(Style: .Hidden)
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
    let Verflclatlon = VerflclatlonController()
    Verflclatlon.SignUp = self
    PresentByNavigation(ViewController: self, ToViewController: Verflclatlon)
    }
    } Err: { error in
    self.Error(Err:error)
    }
    }
    
}

