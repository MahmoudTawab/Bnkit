//
//  RequestHistoryCell.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/8/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import SwipeCellKit

class RequestHistoryCell: SwipeTableViewCell {
    
    lazy var RequestNameLabel : UILabel = {
        let Label = UILabel()
        Label.backgroundColor = .clear
        Label.textColor = LabelForeground
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    lazy var DateRequesLabel : UILabel = {
        let Label = UILabel()
        Label.backgroundColor = .clear
        Label.textColor = #colorLiteral(red: 0.4391748011, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    lazy var RequestStatusLabel : UILabel = {
        let Label = UILabel()
        Label.backgroundColor = .clear
        Label.textColor = #colorLiteral(red: 0.4391748011, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    lazy var NoteLabel : UILabel = {
        let Label = UILabel()
        Label.backgroundColor = .clear
        Label.textColor = #colorLiteral(red: 0.4391748011, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    lazy var ViewLine : UIView = {
        let View = UIView()
        View.backgroundColor = #colorLiteral(red: 0.4391748011, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    lazy var View : UIView = {
        let View = UIView()
        View.backgroundColor = .clear
        View.layer.borderWidth = 1.4
        View.layer.borderColor = #colorLiteral(red: 0.4391748011, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
        View.layer.cornerRadius = 15
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    backgroundColor = BackgroundColor
    
    addSubview(View)
    View.addSubview(RequestNameLabel)
    View.addSubview(ViewLine)
    View.addSubview(DateRequesLabel)
    View.addSubview(RequestStatusLabel)
    View.addSubview(NoteLabel)

    View.topAnchor.constraint(equalTo: self.topAnchor , constant: ControlY(10)).isActive = true
    View.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: ControlY(-10)).isActive = true
    View.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: ControlX(20)).isActive = true
    View.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: ControlX(-20)).isActive = true

    RequestNameLabel.topAnchor.constraint(equalTo: View.topAnchor , constant:  ControlY(13)).isActive = true
    RequestNameLabel.leadingAnchor.constraint(equalTo: View.leadingAnchor , constant: ControlX(15)).isActive = true
    RequestNameLabel.trailingAnchor.constraint(equalTo: View.trailingAnchor , constant: ControlX(-15)).isActive = true
    RequestNameLabel.heightAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true

    ViewLine.topAnchor.constraint(equalTo: RequestNameLabel.bottomAnchor , constant:  ControlY(5)).isActive = true
    ViewLine.leadingAnchor.constraint(equalTo: RequestNameLabel.leadingAnchor).isActive = true
    ViewLine.trailingAnchor.constraint(equalTo: RequestNameLabel.trailingAnchor).isActive = true
    ViewLine.heightAnchor.constraint(equalToConstant: ControlHeight(1)).isActive = true

    DateRequesLabel.topAnchor.constraint(equalTo: ViewLine.bottomAnchor , constant:  ControlY(10)).isActive = true
    DateRequesLabel.leadingAnchor.constraint(equalTo: RequestNameLabel.leadingAnchor).isActive = true
    DateRequesLabel.widthAnchor.constraint(equalToConstant: ControlWidth(139.5)).isActive = true
    DateRequesLabel.heightAnchor.constraint(equalTo: RequestNameLabel.heightAnchor).isActive = true
        
    RequestStatusLabel.topAnchor.constraint(equalTo: ViewLine.bottomAnchor , constant:  ControlY(10)).isActive = true
    RequestStatusLabel.trailingAnchor.constraint(equalTo: ViewLine.trailingAnchor).isActive = true
    RequestStatusLabel.widthAnchor.constraint(equalTo: DateRequesLabel.widthAnchor).isActive = true
    RequestStatusLabel.heightAnchor.constraint(equalTo: RequestNameLabel.heightAnchor).isActive = true
        
    NoteLabel.topAnchor.constraint(equalTo: DateRequesLabel.bottomAnchor , constant:  ControlY(5)).isActive = true
    NoteLabel.leadingAnchor.constraint(equalTo: RequestNameLabel.leadingAnchor).isActive = true
    NoteLabel.trailingAnchor.constraint(equalTo: RequestNameLabel.trailingAnchor).isActive = true
    NoteLabel.heightAnchor.constraint(equalTo: RequestNameLabel.heightAnchor).isActive = true
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
