//
//  CalculatorDetaIlsVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 2/10/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class CalculatorDetaIlsVC: UIViewController {
    
    var SizeFont = CGFloat()
    var LoanType = String()
    var Calcula = [Calculator]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpItems()
        SetUp()
    }
    
    func SetUpItems() {
        
    TopBackView.frame = CGRect(x: ControlX(5), y: ControlY(40), width: view.frame.width - ControlWidth(10), height: ControlHeight(50))
    view.addSubview(TopBackView)
      
    let StackVertical1 = UIStackView(arrangedSubviews: [Label1,Label2])
    StackVertical1.axis = .vertical
    StackVertical1.spacing = ControlHeight(2)
    StackVertical1.distribution = .equalSpacing
    StackVertical1.alignment = .center
    StackVertical1.backgroundColor = .clear
        
    let StackVertical2 = UIStackView(arrangedSubviews: [StackVertical1,Label3,Label4,Label5])
    StackVertical2.axis = .vertical
    StackVertical2.spacing = ControlHeight(20)
    StackVertical2.distribution = .equalSpacing
    StackVertical2.alignment = .center
    StackVertical2.backgroundColor = .clear
    StackVertical2.translatesAutoresizingMaskIntoConstraints = false
        
    view.addSubview(StackVertical2)
    StackVertical2.topAnchor.constraint(equalTo: TopBackView.bottomAnchor,constant: ControlY(55)).isActive = true
    StackVertical2.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: ControlX(15)).isActive = true
    StackVertical2.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: ControlX(-15)).isActive = true
    StackVertical2.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: ControlY(-50)).isActive = true
    }
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = LabelForeground
        View.Space = ControlHeight(3)
        View.FontSize = ControlWidth(30)
        View.text = "CALCULATORDETAILS".localizable
        View.Button.tintColor = View.textColor
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var Label1 : UILabel = {
        let Label = UILabel()
        return Label
    }()
    
    lazy var Label2 : UILabel = {
        let Label = UILabel()
        return Label
    }()
    
    lazy var Label3 : UILabel = {
        let Label = UILabel()
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.heightAnchor.constraint(equalToConstant: ControlHeight(90)).isActive = true
        return Label
    }()

    lazy var Label4 : UILabel = {
        let Label = UILabel()
        return Label
    }()
    
    lazy var Label5 : UILabel = {
        let Label = UILabel()
        return Label
    }()
    
    func SetUp() {
    let LoanPeriod = Calcula.first?.numberofPayments ?? 0
    let Years = "lang".localizable == "en" ? "\(LoanPeriod / 12)":"\(LoanPeriod / 12)".NumAR()
    let Payments = "lang".localizable == "en" ? "\(LoanPeriod)":"\(LoanPeriod)".NumAR()
    let Payment = "lang".localizable == "en" ? "\(Calcula.first?.monthlyPayment ?? 0)":"\(Calcula.first?.monthlyPayment ?? 0)".NumAR()
    let Amount = "lang".localizable == "en" ? "\(Calcula.first?.loanAmount ?? 0)":"\(Calcula.first?.loanAmount ?? 0)".NumAR()
        
    let Font1 = UIFont(name: "Campton-Light", size: ControlWidth(15)) ?? UIFont.boldSystemFont(ofSize: ControlWidth(15))
    let Font2 = UIFont(name: "Campton-SemiBold", size: ControlWidth(15)) ?? UIFont.boldSystemFont(ofSize: ControlWidth(15))
    let Font3 = UIFont(name: "Campton-Light", size: ControlWidth(19)) ?? UIFont.boldSystemFont(ofSize: ControlWidth(19))
    let Font4 = UIFont(name: "Campton-SemiBold", size: ControlWidth(23)) ?? UIFont.boldSystemFont(ofSize: ControlWidth(23))
    let Font5 = UIFont(name: "Campton-SemiBold", size: ControlWidth(40)) ?? UIFont.boldSystemFont(ofSize: ControlWidth(40))
        
    Attributed(Label1, Font1, "LoanType".localizable + " : ",Font2, LoanType)
    Attributed(Label2, Font1, "LoanPeriod".localizable + " : ", Font2, Years)
    Attributed(Label3, Font3, "NUMBEROFPAYMENTS".localizable + "\n", Font5, Payments)
    Attributed(Label4, Font3, "MONTHLYPAYMENT".localizable + "\n", Font5, Payment + "\n","EGP".localizable, Font4)
    Attributed(Label5, Font3, "LOANAMOUNT".localizable + "\n", Font5,Amount + "\n","EGP".localizable, Font4)
    }
    
    func Attributed(_ label:UILabel,_ font1: UIFont,_ string1:String,_ font2: UIFont,_ string2:String,_ string3:String = String(),_ font3: UIFont = UIFont()) {
      let style = NSMutableParagraphStyle()
      style.alignment = .center
      let attributedString = NSMutableAttributedString(string: string1, attributes: [
      .font: font1,
      .foregroundColor: CalculatorDetaIls ,
      .paragraphStyle: style
      ])
      attributedString.append(NSAttributedString(string: string2 , attributes: [
      .font: font2,
      .foregroundColor: LabelForeground ,
      .paragraphStyle: style
      ]))
      attributedString.append(NSAttributedString(string: string3 , attributes: [
      .font: font3,
      .foregroundColor: LabelForeground ,
      .paragraphStyle: style
      ]))
      label.backgroundColor = .clear
      label.numberOfLines = 0
      label.attributedText = attributedString
    }
}
