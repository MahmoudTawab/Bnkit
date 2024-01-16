//
//  Checkbox.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/10/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit


class Checkbox: UIButton {

 lazy var Button : UIButton = {
 let Button = UIButton(type: .system)
 Button.backgroundColor = .clear
 Button.layer.borderWidth = ControlHeight(1.5)
 Button.layer.borderColor = #colorLiteral(red: 0.6240856554, green: 0.6240856554, blue: 0.6240856554, alpha: 1)
 Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: ControlWidth(11))
 Button.addTarget(self, action: #selector(Targe), for: .touchUpInside)
 return Button
 }()
    

 override func draw(_ rect: CGRect) {
 addSubview(Button)
 Button.frame = CGRect(x: ControlX(8.5), y: ControlY(8.5), width: rect.width - ControlHeight(17), height: rect.height - ControlHeight(17))
     
 addTarget(self, action: #selector(Targe), for: .touchUpInside)
 }
    
 @objc func Targe() {
    Button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
    self.Button.transform = .identity
    })
    
    UIView.animate(withDuration: 0.2) {
    if self.Button.tag == 0 {
    self.Button.setTitle("✓", for: .normal)
    self.Button.setTitleColor(LabelForeground, for: .normal)
    self.Button.layer.borderColor = LabelForeground.cgColor
    self.Button.tag = 1
    }else{
    self.Button.setTitle("", for: .normal)
    self.Button.layer.borderColor = #colorLiteral(red: 0.6240856554, green: 0.6240856554, blue: 0.6240856554, alpha: 1)
    self.Button.tag = 0
    }
    }
    
}


}
