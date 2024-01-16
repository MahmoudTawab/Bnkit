//
//  PopUpRequestCell.swift
//  Bnkit
//
//  Created by Emojiios on 02/06/2022.
//  Copyright © 2022 Mahmoud Tawab. All rights reserved.
//

import UIKit

class PopUpRequestCell: UITableViewCell {

    lazy var RequestName : UILabel = {
    let Label = UILabel()
    Label.textAlignment = .center
    Label.backgroundColor = .clear
    Label.textColor = LabelForeground
    Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(20))
    return Label
    }()
    
    lazy var RequestId : StackLabel = {
    let Label = StackLabel()
    return Label
    }()

    lazy var RequestStatus : StackLabel = {
    let Label = StackLabel()
    return Label
    }()
    
    lazy var ResponseTime : StackLabel = {
    let Label = StackLabel()
    return Label
    }()

    lazy var NotesLabel : UILabel = {
    let Label = UILabel()
    Label.text = "NOTE".localizable
    Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(13.5))
    Label.textColor = LabelForeground
    Label.backgroundColor = .clear
    return Label
    }()
    
    lazy var NotesTV : UILabel = {
    let Label = UILabel()
    Label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    Label.isHidden = true
    Label.numberOfLines = 0
    Label.backgroundColor = .clear
    Label.font = UIFont(name: "Campton-Light", size: ControlWidth(12.5))
    return Label
    }()
    
    lazy var ViewLine: UIView = {
    let View = UIView()
    View.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    View.translatesAutoresizingMaskIntoConstraints = false
    View.heightAnchor.constraint(equalToConstant:  ControlHeight(2)).isActive = true
    return View
    }()
    
    lazy var Brief : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()

    lazy var MonthlyIncome : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()

    lazy var ServiceType : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var StartUp : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var lengthOfBusiness : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var comments : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var employmentType : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var preferredCompany : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var mobadraType : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var coverageAmount : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var corporate : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var interestedIn : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var partnership : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var investmentBudget : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var requestedAmount : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var islamic : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var investmentAmount : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var email : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var fullName : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var mobileNo : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var productInterested : StackLabel = {
    let Label = StackLabel()
    Label.isHidden = true
    return Label
    }()
    
    lazy var Stack : UIStackView = {
        let Stack = UIStackView(arrangedSubviews: [RequestName,RequestId,RequestStatus,ResponseTime,NotesLabel,NotesTV,ViewLine,Brief,MonthlyIncome,ServiceType,StartUp,lengthOfBusiness,comments,employmentType,preferredCompany,mobadraType,coverageAmount,corporate,interestedIn,partnership,investmentBudget,requestedAmount,islamic,investmentAmount,email,fullName,mobileNo,productInterested])
        Stack.axis = .vertical
        Stack.spacing = ControlHeight(10)
        Stack.distribution = .equalSpacing
        Stack.alignment = .fill
        Stack.backgroundColor = .clear
        Stack.translatesAutoresizingMaskIntoConstraints = false
        return Stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        addSubview(Stack)
        Stack.topAnchor.constraint(equalTo: self.topAnchor, constant: ControlX(10)).isActive = true
        Stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: ControlX(-10)).isActive = true
        Stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ControlX(15)).isActive = true
        Stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ControlX(-15)).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class StackLabel: UIStackView {
    
    lazy var leftLabel : UILabel = {
        let Label = UILabel()
        Label.numberOfLines = 2
        Label.textAlignment = .left
        Label.backgroundColor = .clear
        Label.textColor = LabelForeground
        Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(13.5))
        return Label
    }()
    
    lazy var rightLabel : UILabel = {
        let Label = UILabel()
        Label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        Label.numberOfLines = 2
        Label.textAlignment = .center
        Label.backgroundColor = .clear
        Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(12.5))
        return Label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        alignment = .fill
        spacing = ControlX(5)
        distribution = .fillEqually
        addArrangedSubview(leftLabel)
        addArrangedSubview(rightLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
