//
//  PopUpLanguageView.swift
//  Bnkit
//
//  Created by Emoji Technology on 20/11/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class PopUpLanguageView: UIViewController {
    
    var SettIngs:SettIngsVC?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        view.addSubview(LanguageView)
        LanguageView.addSubview(EnglishLabel)
        LanguageView.addSubview(ArabicLabel)
        LanguageView.addSubview(EnglishButton)
        LanguageView.addSubview(ArabicButton)
        LanguageView.addSubview(DismissButton)
        LanguageView.addSubview(OkeyButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SetUpLanguage()
    }
    
    lazy var LanguageView: UIView = {
           let View = UIView()
           View.backgroundColor = TextViewForeground
           View.layer.cornerRadius = ControlHeight(26)
           View.clipsToBounds = true
           return View
    }()

    lazy var EnglishLabel : UILabel = {
           let Label = UILabel()
           Label.text = "English"
           Label.textAlignment = .left
           Label.font = UIFont(name: "Campton-Medium" ,size: ControlWidth(20))
           Label.textColor = LabelForeground
           Label.backgroundColor = .clear
           return Label
       }()
       

       lazy var ArabicLabel : UILabel = {
           let Label = UILabel()
           Label.text = "العربية"
           Label.textAlignment = .left
           Label.font = UIFont(name: "Campton-Medium" ,size: ControlWidth(20))
           Label.textColor = LabelForeground
           Label.backgroundColor = .clear
           return Label
       }()
       
       lazy var EnglishButton : RadioButton = {
           let Button = RadioButton()
           Button.gap = ControlHeight(15)
           Button.WidthHeight = ControlHeight(20)
           Button.addTarget(self, action: #selector(ActionEnglish), for: .touchUpInside)
           return Button
       }()
       
       @objc func ActionEnglish() {
       EnglishButton.isOn = true
       ArabicButton.isOn = false
       }
       
       lazy var ArabicButton : RadioButton = {
           let Button = RadioButton()
           Button.gap = ControlHeight(15)
           Button.WidthHeight = ControlHeight(20)
           Button.addTarget(self, action: #selector(ActionNo), for: .touchUpInside)
           return Button
       }()
       
       @objc func ActionNo() {
       ArabicButton.isOn = true
       EnglishButton.isOn = false
       }
       
       
       lazy var DismissButton : UIButton = {
           let Button = UIButton(type: .system)
           Button.setTitle("Cancel".localizable, for: .normal)
           Button.titleLabel?.font = UIFont(name: "Campton-Medium" ,size: ControlWidth(20))
           Button.setTitleColor(LabelForeground, for: .normal)
           Button.backgroundColor = .clear
           Button.layer.borderWidth = ControlHeight(0.4)
           Button.layer.borderColor = LabelForeground.cgColor
           Button.setNeedsDisplay()
           Button.addTarget(self, action: #selector(DismissLanguage), for: .touchUpInside)
           return Button
       }()
       

       lazy var OkeyButton : UIButton = {
           let Button = UIButton(type: .system)
           Button.setTitle("Okey".localizable, for: .normal)
           Button.titleLabel?.font = UIFont(name: "Campton-Medium" ,size: ControlWidth(20))
           Button.setTitleColor(LabelForeground, for: .normal)
           Button.backgroundColor = .clear
           Button.layer.borderWidth = ControlHeight(0.4)
           Button.layer.borderColor = LabelForeground.cgColor
           Button.setNeedsDisplay()
           Button.addTarget(self, action: #selector(DismissLanguage), for: .touchUpInside)
           return Button
       }()
       
       @objc func DismissLanguage() {
       UIView.animate(withDuration: 0.5) {
       self.SetLanguageView()
       }
       }
       
       func SetUpLanguage()  {
       let width = view.frame.width - ControlWidth(70)
       self.LanguageView.layer.transform = CATransform3DMakeScale(0, 0, 0)
       UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
       self.LanguageView.layer.transform = CATransform3DMakeScale(1, 1, 1)
       self.LanguageView.frame = CGRect(x: self.view.center.x - (width / 2) , y:self.view.center.y - 100, width: width, height:  ControlHeight(215))
       self.SetUpItemLanguage()
       })
       }
       
     
       func SetLanguageView()  {
       let width = view.frame.width - ControlWidth(60)
       LanguageView.frame = CGRect(x: view.center.x - (width / 2) , y: view.frame.maxY , width: width, height: ControlHeight(215))
       SetUpItemLanguage()
       }

       
       func SetUpItemLanguage() {
           
       EnglishLabel.frame = CGRect(x: ControlX(30), y: ControlY(40),  width: ControlWidth(205),  height: ControlHeight(30))
           
       ArabicLabel.frame = CGRect(x: EnglishLabel.frame.minX, y: ControlY(110), width: EnglishLabel.frame.width, height: EnglishLabel.frame.height)
           
       EnglishButton.frame = CGRect(x: ControlX(255), y: ControlY(40), width: ControlWidth(30),  height: ControlHeight(30))
           
       ArabicButton.frame = CGRect(x: EnglishButton.frame.minX, y: ControlY(110), width: EnglishButton.frame.width, height: EnglishButton.frame.height)
           
       DismissButton.frame = CGRect(x: ControlX(-1), y: ControlY(166), width: ControlWidth(154.5),  height: ControlHeight(50))
           
       OkeyButton.frame = CGRect(x: DismissButton.frame.maxX, y: DismissButton.frame.minY, width: DismissButton.frame.width, height: DismissButton.frame.height)
       }
}
