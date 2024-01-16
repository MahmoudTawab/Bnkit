//
//  NotificationsCell.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import SwipeCellKit

class NotificationsCell: SwipeTableViewCell {
    
   lazy var TitleLabel : UILabel = {
    let Label = UILabel()
    Label.numberOfLines = 2
    Label.backgroundColor = .clear
    Label.translatesAutoresizingMaskIntoConstraints = false
    return Label
    }()
    
    lazy var DetaLabel : UILabel = {
        let Label = UILabel()
        Label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        Label.textAlignment = .center
        Label.backgroundColor = .clear
        Label.numberOfLines = 2
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    lazy var NotificationsView: UIView = {
        let View = UIView()
        View.backgroundColor = #colorLiteral(red: 0.9439466596, green: 0.6406636238, blue: 0.6592981219, alpha: 1)
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    lazy var ViewLine : UIView = {
        let View = UIView()
        View.backgroundColor = #colorLiteral(red: 0.3011728312, green: 0.3260864058, blue: 0.3622796413, alpha: 1)
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    lazy var ViewTopLine : UIView = {
        let View = UIView()
        View.backgroundColor = #colorLiteral(red: 0.3011728312, green: 0.3260864058, blue: 0.3622796413, alpha: 1)
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        backgroundColor = BackgroundColor
        addSubview(TitleLabel)
        addSubview(DetaLabel)
        addSubview(NotificationsView)
        addSubview(ViewLine)
        addSubview(ViewTopLine)
        
        ViewLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ControlX(28)).isActive = true
        ViewLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        ViewLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        ViewLine.heightAnchor.constraint(equalToConstant: ControlHeight(0.8)).isActive = true

        ViewTopLine.leadingAnchor.constraint(equalTo: ViewLine.leadingAnchor).isActive = true
        ViewTopLine.trailingAnchor.constraint(equalTo: ViewLine.trailingAnchor).isActive = true
        ViewTopLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        ViewTopLine.heightAnchor.constraint(equalTo: ViewLine.heightAnchor).isActive = true

        TitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        TitleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, constant: ControlHeight(-20)).isActive = true
        TitleLabel.leadingAnchor.constraint(equalTo: ViewLine.leadingAnchor).isActive = true
        TitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ControlX(-80)).isActive = true

        DetaLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        DetaLabel.leadingAnchor.constraint(equalTo: TitleLabel.trailingAnchor, constant: ControlX(5)).isActive = true
        DetaLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ControlX(-20)).isActive = true
        DetaLabel.heightAnchor.constraint(equalTo: TitleLabel.heightAnchor).isActive = true

        NotificationsView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ControlX(10)).isActive = true
        NotificationsView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        NotificationsView.widthAnchor.constraint(equalToConstant: ControlHeight(7)).isActive = true
        NotificationsView.heightAnchor.constraint(equalToConstant: ControlHeight(7)).isActive = true
        NotificationsView.layer.cornerRadius = ControlHeight(7) / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
