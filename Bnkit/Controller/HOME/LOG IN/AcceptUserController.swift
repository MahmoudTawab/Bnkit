//
//  AcceptUserController.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/5/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class AcceptUserController: UIViewController {

    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    }
    
    func SetUpItems() {
    view.addSubview(TopBackView)
    view.addSubview(AgreementTV)
        
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlX(20), height: ControlHeight(50))
    AgreementTV.frame = CGRect(x: ControlX(25), y: TopBackView.frame.maxY + ControlY(25), width: view.frame.width - ControlX(50), height: view.frame.height - ControlHeight(120))
        
    if let enAgreement = defaults.string(forKey: "enAgreement") , let arAgreement = defaults.string(forKey: "arAgreement") {
    AgreementTV.text = "lang".localizable == "en" ? enAgreement : arAgreement
    }
    }
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = LabelForeground
        View.Space = ControlHeight(4)
        View.FontSize = ControlWidth(30)
        View.text = "AGREEMENT".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var AgreementTV:UITextView = {
        let tv = UITextView()
        tv.textColor = #colorLiteral(red: 0.4391748011, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
        tv.isEditable = false
        tv.isSelectable = false
        tv.backgroundColor = .clear
        tv.font = UIFont(name: "Campton-Light", size: ControlWidth(16))
        return tv
    }()
    

}
