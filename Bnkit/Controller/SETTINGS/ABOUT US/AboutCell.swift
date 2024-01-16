//
//  AboutCell.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/12/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {
        
    lazy var ViewBackground : UIView = {
        let View = UIView()
        View.backgroundColor = #colorLiteral(red: 0.4740355015, green: 0.563254118, blue: 0.7413062453, alpha: 1)
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    lazy var TheTitle : UILabel = {
        let Label = UILabel()
        Label.numberOfLines = 0
        Label.textColor = .white
        Label.backgroundColor = .clear
        return Label
    }()
    
    lazy var TheDetails : UILabel = {
        let Label = UILabel()
        Label.textColor = LabelForeground
        Label.alpha = 0.95
        Label.backgroundColor = BackgroundColor
        Label.numberOfLines = 0
        return Label
    }()

    var StackVertical = UIStackView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = BackgroundColor
        
        StackVertical = UIStackView(arrangedSubviews: [TheTitle,TheDetails])
        StackVertical.axis = .vertical
        StackVertical.spacing = ControlHeight(10)
        StackVertical.distribution = .equalSpacing
        StackVertical.alignment = .fill
        StackVertical.backgroundColor = .clear
        StackVertical.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(ViewBackground)
        
        addSubview(StackVertical)
        StackVertical.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: ControlX(25)).isActive = true
        StackVertical.topAnchor.constraint(equalTo: self.topAnchor,constant: ControlY(10)).isActive = true
        StackVertical.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: ControlX(-25)).isActive = true
        StackVertical.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        ViewBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        ViewBackground.topAnchor.constraint(equalTo: self.topAnchor,constant: ControlY(10)).isActive = true
        ViewBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        ViewBackground.heightAnchor.constraint(equalTo: StackVertical.arrangedSubviews[0].heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
