//
//  SPRadioButton.swift
//  Color
//
//  Created by Mahmoud Abd El Tawab on 6/24/19.
//  Copyright © 2019 Mahmoud Abd El Tawab. All rights reserved.
//

import UIKit

class SPRadioButton: UIView {
    

    var YesOrNo = Bool()
    @IBInspectable var TextYes:String = "" {
      didSet {
        YesButton.text = TextYes
      }
    }
    
    @IBInspectable var TextNo:String = "" {
      didSet {
          NoButton.text = TextNo
      }
    }
    
    @IBInspectable var TextTitle:String = "" {
      didSet {
          TitleLabel.text = TextTitle
      }
    }
    
    lazy var YesButton : RadioButton = {
        let Button = RadioButton(frame: CGRect(x: ControlWidth(115), y: ControlY(15), width: ControlWidth(100), height: ControlWidth(30)))
        Button.isOn = true
        Button.backgroundColor = .clear
        Button.Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(15))
        Button.addTarget(self, action: #selector(ActionYes), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionYes() {
    YesOrNo = true
    YesButton.isOn = true
    NoButton.isOn = false
    SetUpRadio()
    }
    
    lazy var NoButton : RadioButton = {
        let Button = RadioButton(frame: CGRect(x: ControlWidth(235), y: ControlY(15), width: ControlWidth(100), height: ControlWidth(30)))
        Button.backgroundColor = .clear
        Button.Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(15))
        Button.addTarget(self, action: #selector(ActionNo), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionNo() {
    YesOrNo = false
    NoButton.isOn = true
    YesButton.isOn = false
    SetUpRadio()
    }
    
    lazy var TitleLabel : UILabel = {
        let Label = UILabel()
        Label.backgroundColor = .clear
        Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(16))
        Label.textColor = LabelForeground
        return Label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(TitleLabel)
        addSubview(YesButton)
        addSubview(NoButton)

        TitleLabel.frame = CGRect(x: 0, y: ControlY(15), width: ControlWidth(170), height: ControlWidth(30))
        SetUpRadio()
    }
    
    func SetUpRadio() {
    YesButton.drawCircles(rect: CGRect(x: ControlWidth(185), y: ControlY(15), width: ControlWidth(100), height: ControlWidth(30)))
        
    NoButton.drawCircles(rect: CGRect(x: ControlWidth(315), y: ControlY(15), width: ControlWidth(100), height: ControlWidth(30)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class RadioButton: UIButton {
    
    @IBInspectable
    var gap:CGFloat = ControlHeight(13.4) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var WidthHeight:CGFloat = ControlHeight(16) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    

    @IBInspectable
    var fillColor: UIColor = BackgroundColor {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isOn: Bool = false {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable var Space:CGFloat = ControlHeight(12) {
    didSet {
    self.setNeedsDisplay()
    }
    }
    
    
    @IBInspectable var text:String = "" {
      didSet {
      Label.text = text
      }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        drawCircles(rect: rect)
    }
    
    
     lazy var Label : UILabel = {
        let Label = UILabel()
        Label.textAlignment = .left
        Label.backgroundColor = .clear
        Label.textColor = LabelForeground
        return Label
    }()
       
    //MARK:- Draw inner and outer circles
    func drawCircles(rect: CGRect) {
        var path = UIBezierPath()
        
        let height = (rect.height / 2) - (WidthHeight / 2)
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: height, width: WidthHeight, height: WidthHeight))
        addSubview(Label)
        
        Label.frame = CGRect(x: WidthHeight + Space, y: height, width: frame.width - WidthHeight - Space, height: WidthHeight)
    
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = fillColor.cgColor
        circleLayer.path = path.cgPath
        circleLayer.lineWidth = 1.1
        circleLayer.strokeColor = LabelForeground.cgColor
        layer.addSublayer(circleLayer)
        
        if self.isOn {
        let innerCircleLayer = CAShapeLayer()
        let rectForInnerCircle = CGRect(x: self.gap, y: height + self.gap, width: self.WidthHeight - 2 * self.gap, height: self.WidthHeight - 2 * self.gap)
        innerCircleLayer.path = UIBezierPath(ovalIn: rectForInnerCircle).cgPath
    
        innerCircleLayer.fillColor = LabelForeground.cgColor
    
        self.layer.addSublayer(innerCircleLayer)

         let flash = CABasicAnimation(keyPath: "opacity")
         flash.duration = 0.4
         flash.fromValue = 1 // alpha
         flash.toValue = 0.2 // alpha
         flash.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
         flash.autoreverses = true
         flash.repeatCount = 1
         innerCircleLayer.add(flash, forKey: nil)
        }
        self.layer.shouldRasterize =  true
        self.layer.rasterizationScale = UIScreen.main.nativeScale
        
    }
    

}

