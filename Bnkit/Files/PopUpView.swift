//
//  PopUpView.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class PopUpView: UIViewController {

    @IBInspectable var text:String = "" {
      didSet {
      TextView.text = text
      }
    }
    
    @IBInspectable var font:CGFloat = ControlWidth(16) {
      didSet {
      TextView.font = UIFont(name: "Campton-Light", size: font)
      }
    }
    
    
    lazy var ViewPopUp : UIView = {
        let View = UIView()
        View.backgroundColor = TextViewForeground
        View.layer.cornerRadius = ControlHeight(26)
        return View
    }()

    lazy var TextView:UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.scrollsToTop = false
        tv.isSelectable = false
        tv.textColor = LabelForeground
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 4)
        return tv
    }()
    

    lazy var CancelButton : UIButton = {
        let Button = UIButton(type: .system)
        let image = UIImage(named: "group269")?.withInset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.tintColor = .white
        Button.setBackgroundImage(image, for: .normal)
        Button.addTarget(self, action: #selector(PopUpCancel), for: .touchUpInside)
        return Button
    }()
    
    @objc func PopUpCancel() {
    dismiss(animated: true)
    }

    lazy var OkeyButton : UIButton = {
        let Button = UIButton(type: .system)
        let image = UIImage(named: "group272")?.withInset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        Button.setBackgroundImage(image, for: .normal)
        Button.tintColor = .white
        Button.backgroundColor = #colorLiteral(red: 0.7962622643, green: 0.9145382047, blue: 0.8632406592, alpha: 1)
        Button.addTarget(self, action: #selector(PopUpCancel), for: .touchUpInside)
        return Button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 0.4) {
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SetUp()
        ViewPopUp.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        CancelButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        OkeyButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
        self.ViewPopUp.transform = .identity
        self.CancelButton.transform = .identity
        self.OkeyButton.transform = .identity
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    UIView.animate(withDuration: 0.5, animations: {
    self.ViewPopUp.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    self.CancelButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    self.OkeyButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }) { (End) in
    self.ViewPopUp.transform = .identity
    self.CancelButton.transform = .identity
    self.OkeyButton.transform = .identity
    }
    }
    
    var Height = CGFloat()
    func SetUp() {
        
    guard let DetailHeight = TextView.attributedText.string.heightWithConstrainedWidth(view.frame.width - ControlWidth(60), font: UIFont.boldSystemFont(ofSize:ControlWidth(font))) else{return}
    
    Height = DetailHeight < ControlHeight(300) ? DetailHeight:ControlHeight(300)
                
    ViewPopUp.frame = CGRect(x: ControlX(30), y: view.center.y - ((Height + ControlHeight(100))/2), width: view.frame.width - ControlX(60), height: Height + ControlHeight(100))
    view.addSubview(ViewPopUp)
        
    ViewPopUp.addSubview(TextView)
    TextView.frame = CGRect(x: ControlX(20), y: ControlY(20), width: ViewPopUp.frame.width - ControlX(40), height: ViewPopUp.frame.height - ControlHeight(40))
        
    if OkeyButton.isHidden {
    CancelButton.frame = CGRect(x: view.center.x - ControlWidth(31), y: ControlY(550), width: ControlWidth(62), height: ControlWidth(62))
    }else{
    CancelButton.frame = CGRect(x: view.frame.maxX - (ControlX(60) + ControlWidth(62)), y: ControlY(550), width: ControlWidth(62), height: ControlWidth(62))
    }
        
    CancelButton.layer.cornerRadius = CancelButton.frame.height / 2
    view.addSubview(CancelButton)
        
    OkeyButton.frame = CGRect(x: ControlX(60), y: ControlY(550), width: ControlWidth(62), height: ControlWidth(62))
    OkeyButton.layer.cornerRadius = OkeyButton.frame.height / 2
    view.addSubview(OkeyButton)
        
    ContentSize()
    }
    
    func ContentSize() {
    var topCorrection = (TextView.bounds.size.height - TextView.contentSize.height * TextView.zoomScale) / 2.0
    topCorrection = max(0, topCorrection)
    TextView.contentInset = UIEdgeInsets(top: topCorrection , left: 0, bottom: 0, right: 0)
    }
    
}



