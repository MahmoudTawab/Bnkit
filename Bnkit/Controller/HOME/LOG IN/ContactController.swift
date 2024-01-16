//
//  ContactController.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import FirebaseFirestore

class ContactController: UIViewController  {

    var SignIn = Bool()
    var SizeFont = CGFloat()
    override func viewDidLoad() {
    super.viewDidLoad()
    if SignIn {
    TopBackView.alpha = 0
    ContactUSLabel.alpha = 1
    SetUpButton(button: ChatButton, Background: "group2434", Title: "CHAT".localizable)
    }else{
    TopBackView.alpha = 1
    ContactUSLabel.alpha = 0
    SetUpButton(button: ChatButton, Background: "group2377", Title: "LEAVEMESSAGE".localizable)
    }
    view.backgroundColor = BackgroundColor
    navigationController?.navigationBar.isHidden = true
   
    SetUpItems()
    }
    

    func SetUpItems() {

        view.addSubview(TopBackView)
        view.addSubview(ContactUSLabel)
        
        let StackVertical = UIStackView(arrangedSubviews: [CallUsButton,SocialMediaButton,ChatButton,OfficeAddressButton])
        StackVertical.axis = .vertical
        StackVertical.spacing = ControlHeight(11)
        StackVertical.distribution = .fillEqually
        StackVertical.backgroundColor = .clear
        view.addSubview(StackVertical)
            
        TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlX(20), height: ControlHeight(50))
        ContactUSLabel.frame = CGRect(x: ControlX(30), y: ControlY(40), width: view.frame.width - ControlX(60), height: ControlHeight(50))
        StackVertical.frame = CGRect(x: ControlX(25), y: ControlY(105), width: view.frame.width - ControlX(50), height: ControlHeight(502))
    }

    lazy var TopBackView: TopView = {
        let View = TopView()
        View.Space = 0
        View.FontSize = ControlWidth(30)
        View.textColor = LabelForeground
        View.text = "CONTACTUS".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }

    lazy var ContactUSLabel : UILabel = {
    let Label = UILabel()
    Label.text = "CONTACTUS".localizable
    Label.textColor = LabelForeground
    Label.textAlignment = .left
    Label.backgroundColor = .clear
    Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(30))
    return Label
    }()
    
    
    lazy var CallUsButton : UIButton = {
    let Button = UIButton(type: .system)
    if let phone = defaults.string(forKey: "phone") {
    let Phone = String(phone.enumerated().map { $0 > 0 && $0 % 3 == 0 ? [" ",$1] : [$1]}.joined())
                
    let attributedString = NSMutableAttributedString(string: "CallUS".localizable, attributes: [
    .font: UIFont(name: "Campton-SemiBold" ,size: ControlWidth(12.5)) ?? UIFont.systemFont(ofSize: ControlWidth(12.5)),
    .foregroundColor: UIColor.white
    ])
    
    attributedString.append(NSAttributedString(string: " \n ", attributes: [
    .foregroundColor: UIColor.clear
    ]))
        
    attributedString.append(NSAttributedString(string: "UserAgreement".localizable, attributes: [
    .font: UIFont(name: "Campton-SemiBold" ,size: ControlWidth(12.5)) ?? UIFont.systemFont(ofSize: ControlWidth(12.5)),
    .foregroundColor: UIColor.white ,
    .underlineStyle: NSUnderlineStyle.single.rawValue
    ]))
        
    Button.backgroundColor = .clear
    Button.setAttributedTitle(attributedString, for: .normal)
    }
    SetUpButton(button: Button, Background: "group2375", Title: "")
    Button.tintColor = .white
    Button.addTarget(self, action: #selector(ActionCallUs), for: .touchUpInside)
    return Button
    }()
      

    @objc func ActionCallUs() {
    CallUsButton.isEnabled = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
    self.CallUsButton.isEnabled = true
    }
    if let phone = defaults.string(forKey: "phone") {
    let formattedNumber = phone.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
    if let url = NSURL(string: ("tel:" + (formattedNumber))) {
    if #available(iOS 10.0, *) {
    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    } else {
    UIApplication.shared.openURL(url as URL)
    }
    }
    }
    }
    
    lazy var SocialMediaButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2376", Title: "SOCIALMEDIA".localizable)
    Button.addTarget(self, action: #selector(ActionSocialMedia), for: .touchUpInside)
    return Button
    }()
 
    @objc func ActionSocialMedia() {
    if let faceBook = defaults.string(forKey: "faceBookPage") {
    guard let url = URL(string:faceBook) else{return}
    let application = UIApplication.shared
    if application.canOpenURL(url) {
    application.open(url, options: [:])
    return
    }
    }
    }
    
    lazy var ChatButton : UIButton = {
    let Button = UIButton(type: .system)
    Button.addTarget(self, action: #selector(ActionChat), for: .touchUpInside)
    return Button
    }()
        

    @objc func ActionChat() {
    if SignIn {
    PresentByNavigation(ViewController: self, ToViewController: CustomerServiceVC())
    }else{
    PresentByNavigation(ViewController: self, ToViewController: LeaveMessageVC())
    }
    }
    
    
    lazy var OfficeAddressButton : UIButton = {
    let Button = UIButton(type: .system)
    SetUpButton(button: Button, Background: "group2378", Title: "OFFICEADDRESS".localizable)
    Button.addTarget(self, action: #selector(ActionOfficeAddress), for: .touchUpInside)
    return Button
    }()
        
    @objc func ActionOfficeAddress() {
    let latitude = defaults.double(forKey: "lat")
    let longitude = defaults.double(forKey: "long")
    let Adders = defaults.string(forKey: "adders")
    let location =  CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let placemark : MKPlacemark = MKPlacemark(coordinate: location, addressDictionary:nil)
    let mapItem:MKMapItem = MKMapItem(placemark: placemark)
    mapItem.name = Adders
    let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey as NSCopying)
    let currentLocationMapItem:MKMapItem = MKMapItem.forCurrentLocation()
    MKMapItem.openMaps(with: [currentLocationMapItem, mapItem], launchOptions: launchOptions as? [String : Any])
    }
    
    
    func SetUpButton(button:UIButton,Background:String,Title:String) {
    button.setTitleColor(.white, for: .normal)
    button.contentHorizontalAlignment = .left
    button.contentVerticalAlignment = .top
    button.titleLabel?.numberOfLines = 0
    button.setTitle(Title, for: .normal)
    button.subviews.first?.contentMode = .scaleAspectFit
    button.setBackgroundImage(UIImage(named: Background), for: .normal)
    button.titleLabel?.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(12.5))
    button.contentEdgeInsets = UIEdgeInsets(top: 18, left: 25, bottom: 0, right: 0)
    }

}


