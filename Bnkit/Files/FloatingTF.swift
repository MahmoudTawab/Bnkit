//
//  FloatingTF.swift
//  FloatingTF
//
//  Created by Abhilash  on 11/02/17.
//  Copyright © 2017 Abhilash . All rights reserved.
//

import UIKit

class FloatingTF: UITextField {
    
  var floatingTitleLabelHeight = ControlHeight(20)
  let bottomLineLayer = UIView()
  let animationDuration = 0.3
  var isFloatingTitleHidden = true
  let Title = UILabel()
  let TitleError = UILabel()
  let IconError = UILabel()
  let bubbleLayer = CAShapeLayer()
  
  required init?(coder aDecoder:NSCoder) {
    super.init(coder:aDecoder)
    setup()
  }
  
  override init(frame:CGRect) {
    super.init(frame:frame)
    setup()
  }
    
  fileprivate func setup() {
    borderStyle = UITextField.BorderStyle.none
    self.clipsToBounds = false
    self.font = UIFont(name: "Campton-Light", size: ControlWidth(15))
    self.tintColor = titleActiveTextColor
    self.backgroundColor = BackgroundColor
    self.autocorrectionType = .no
    
    if #available(iOS 12.0, *) {
    self.textContentType = .oneTimeCode
    }
    
    // Set up
    Title.alpha = 0.0
    Title.backgroundColor = .clear
    Title.textColor = titleActiveTextColor
    Title.font = UIFont(name: "Campton-Light", size: ControlWidth(13))
      
    TitleError.alpha = 0.0
    TitleError.backgroundColor = BackgroundColor
    TitleError.font = UIFont(name: "Campton-Light", size: ControlWidth(13))
    TitleError.translatesAutoresizingMaskIntoConstraints = false
      
    IconError.alpha = 0.0
    IconError.text = "!"
    IconError.textColor = .white
    IconError.textAlignment = .center
    IconError.layer.masksToBounds = true
    IconError.font = UIFont.systemFont(ofSize: ControlWidth(16))
    IconError.translatesAutoresizingMaskIntoConstraints = false
      
    if let str = placeholder , !str.isEmpty {
    Title.text = str.capitalized
    Title.sizeToFit()
    }
      
    self.addSubview(Title)
      
    bottomLineLayer.translatesAutoresizingMaskIntoConstraints = false
    bottomLineLayer.backgroundColor = titleActiveTextColor
      
    setBottomLineLayerFrame()
      
    self.addTarget(self, action: #selector(DidBegin), for: .editingDidBegin)
    self.addTarget(self, action: #selector(DidBegin), for: .editingChanged)
    self.addTarget(self, action: #selector(DidEnd), for: .editingDidEnd)
  }
    
    @objc func DidEnd() {
    TitleError.alpha = 0
    IconError.alpha = 0
    bottomLineLayer.backgroundColor = titleActiveTextColor
    }
    
    @objc func DidBegin() {

    if ShowError {
    if self.keyboardType == .emailAddress {
    self.addTarget(self, action: #selector(NoErrorEmail), for: .editingChanged)
    bottomLineLayer.backgroundColor = !NoErrorEmail() ? #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) : titleActiveTextColor
        
    TitleError.text = !NoErrorEmail() ? "ErrorEmail".localizable : ""
    TitleError.alpha = !NoErrorEmail() ? 1 : 0
    IconError.alpha = !NoErrorEmail() ? 1 : 0
    Icon.alpha = NoErrorEmail() ? 1 : 0
    IconError.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    TitleError.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
    rightView = UIView(frame: CGRect(x: 0, y: 0, width: ControlWidth(30) , height: frame.height))
    rightViewMode = .always
    }
        
    if self.isSecureTextEntry == true {
    self.addTarget(self, action: #selector(NoErrorPassword), for: .editingChanged)
    bottomLineLayer.backgroundColor = !NoErrorPassword() ? #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) : titleActiveTextColor
        
    TitleError.text = !NoErrorPassword() ? "ErrorPasswordCorrectly".localizable : ""
    TitleError.alpha = !NoErrorPassword() ? 1 : 0
    IconError.alpha = !NoErrorPassword() ? 1 : 0
    Icon.alpha = NoErrorPassword() ? 1 : 0
    IconError.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    TitleError.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
    rightView = UIView(frame: CGRect(x: 0, y: 0, width: ControlWidth(30) , height: frame.height))
    rightViewMode = .always
    }
        
    if self.isSecureTextEntry == false &&  self.keyboardType != .emailAddress {
    self.addTarget(self, action: #selector(IsEmpty), for: .editingDidBegin)
    bottomLineLayer.backgroundColor = !IsEmpty() ? #colorLiteral(red: 0.9099414945, green: 0.8040828109, blue: 0.495026648, alpha: 1) : titleActiveTextColor
        
    TitleError.text = !IsEmpty() ? "It can't be empty".localizable : ""
    TitleError.alpha = !IsEmpty() ? 1 : 0
    IconError.alpha = !IsEmpty() ? 1 : 0
    IconError.backgroundColor = #colorLiteral(red: 0.9099414945, green: 0.8040828109, blue: 0.495026648, alpha: 1)
    TitleError.textColor = #colorLiteral(red: 0.9099414945, green: 0.8040828109, blue: 0.495026648, alpha: 1)
        
    }
    }
    }
    
    let Icon = UIButton()
    func SetUpIcon(LeftOrRight:Bool) {
    Icon.tintColor = LabelForeground
    Icon.translatesAutoresizingMaskIntoConstraints = false
        
    self.addSubview(Icon)
    
    if LeftOrRight {
    let image = UIImage(named: "lock")?.withInset(UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2))
    Icon.setBackgroundImage(image, for: .normal)
    Icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ControlX(4)).isActive = true
    }else{
    let image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: ControlY(2), left: ControlX(4), bottom: ControlY(2), right: ControlX(4)))
    Icon.setBackgroundImage(image, for: .normal)
    Icon.transform = CGAffineTransform(rotationAngle: -.pi/2)
    Icon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ControlX(-4)).isActive = true
    }
        
    rightView = UIView(frame: CGRect(x: 0, y: 0, width: ControlWidth(30) , height: frame.height))
    rightViewMode = .always
        
    Icon.widthAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true
    Icon.heightAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true
    Icon.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant: 1).isActive = true
    }
  
  @IBInspectable var ShowError : Bool = true
  @IBInspectable var enableFloatingTitle : Bool = true
  @IBInspectable var titleActiveTextColor:UIColor = LabelForeground {
    didSet {
    Title.textColor = titleActiveTextColor
    self.textColor = titleActiveTextColor
    }
  }
    

   override func layoutSubviews() {
    super.layoutSubviews()
    
    if let txt = text , txt.isEmpty {
      // Hide
    if !isFloatingTitleHidden {
    hideTitle()
    }
    } else if enableFloatingTitle {
    setTitleFrame()
    // Show
    showTitle()
    }
  }

	/// setBottomLineLayerFrame( - Description:
	private func setBottomLineLayerFrame() {
        
    self.addSubview(TitleError)
    self.addSubview(IconError)
    self.addSubview(bottomLineLayer)
        
    bottomLineLayer.topAnchor.constraint(equalTo: self.bottomAnchor ,constant: ControlHeight(1)).isActive = true
    bottomLineLayer.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    bottomLineLayer.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    bottomLineLayer.heightAnchor.constraint(equalToConstant: ControlHeight(1)).isActive = true
                
    IconError.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    IconError.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ControlX(-4)).isActive = true
    IconError.widthAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true
    IconError.heightAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true
    IconError.layer.cornerRadius = ControlHeight(10)
                
    TitleError.topAnchor.constraint(equalTo: self.bottomAnchor , constant: ControlHeight(5)).isActive = true
    TitleError.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    TitleError.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    TitleError.heightAnchor.constraint(equalToConstant: floatingTitleLabelHeight).isActive = true
        
    }
  
  fileprivate func showTitle() {
    UIView.animate(withDuration: animationDuration) {
    // Animation
    self.Title.text = self.placeholder
    self.Title.alpha = 1.0
    var l = self.Title.frame
    l.origin.y = -(CGFloat)(self.TitleLabelY)
    self.Title.frame = l
        
    self.isFloatingTitleHidden = false
     } completion: { _ in
    }
  }
  
  fileprivate func hideTitle() {
    self.isFloatingTitleHidden = true
    UIView.animate(withDuration: animationDuration) {
    // Animation
    self.Title.alpha = 0.0
    var l = self.Title.frame
    l.origin.y = self.Title.font.lineHeight + 0
    self.Title.frame = l
    
    } completion: { _ in
    }
  }
        
    var TitleLabelY = ControlHeight(20)
	private func setTitleFrame() {
    self.Title.frame = CGRect(x:0, y: -TitleLabelY, width: self.frame.size.width, height:floatingTitleLabelHeight)
	}

}

extension UITextField {
    @objc func NoErrorEmail() -> Bool {
    if isValidEmail(emailID: self.text ?? "") != false {
    return true
    }else{
    return false
    }
    }

    @objc func NoErrorPassword() -> Bool {
    if (self.text?.count) ?? 0 > 5 {
    return true
    }else{
    return false
    }
    }

    @objc func IsEmpty() -> Bool {
    if self.text?.TextNull() == false {
    return false
    }else{
    return true
    }
    }

}


    
