//
//  TopView.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class TopView: UIView {

    @IBInspectable var Space:CGFloat = 0 {
    didSet {
    
    }
    }
    
    @IBInspectable var FontSize:CGFloat = 0 {
    didSet {
    Label.titleLabel?.font = UIFont(name: "Campton-SemiBold", size: FontSize)
    }
    }
    
    @IBInspectable var text:String = "" {
      didSet {
      Label.setTitle(text, for: .normal)
      }
    }
    
    @IBInspectable var textColor:UIColor = .clear {
      didSet {
      Label.setTitleColor(textColor, for: .normal)
      Button.tintColor = textColor
      }
     }
    
     lazy var Label : UIButton = {
        let Button = UIButton()
        Button.backgroundColor = .clear
        Button.contentHorizontalAlignment = "lang".localizable == "en" ? .left : .right
        Button.titleLabel?.numberOfLines = 2
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        return Button
    }()
    
    lazy var Button : UIButton = {
        let Button = UIButton(type: .system)
        let Image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        Button.backgroundColor = .clear
        Button.setImage(Image, for: .normal)
        Button.contentVerticalAlignment = .center
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.transform = "lang".localizable == "en" ? .identity : CGAffineTransform(rotationAngle: .pi)
        return Button
    }()

    
    override func draw(_ rect: CGRect) {
    super.draw(rect)
    backgroundColor = .clear
        
    addSubview(Label)
    addSubview(Button)
        
    Button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    Button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    Button.heightAnchor.constraint(equalToConstant: ControlHeight(50)).isActive = true
    Button.widthAnchor.constraint(equalTo: Button.heightAnchor).isActive = true
        
    Label.leadingAnchor.constraint(equalTo: Button.trailingAnchor ,constant: Space).isActive = true
    Label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    Label.widthAnchor.constraint(equalToConstant: rect.width - ControlWidth(50) - Space).isActive = true
    Label.heightAnchor.constraint(equalToConstant: ControlHeight(50)).isActive = true
    }
    
}
