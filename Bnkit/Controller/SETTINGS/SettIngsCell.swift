//
//  SettIngsCell.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/8/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

protocol SettIngsCelldelegate {
    func didLanguage()
}

class SettIngsCell: UITableViewCell {

    var delegate:SettIngsCelldelegate?
    
     lazy var SettIngsLabel : UILabel = {
        let Label = UILabel()
        Label.textColor = LabelForeground
        Label.backgroundColor = .clear
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
        }()

       lazy var LanguageIcon:UIButton = {
          let button = UIButton(type: .system)
          button.alpha = 0
          button.backgroundColor = .clear
          button.setImage(UIImage(named: "LeftAndRight"), for: .normal)
          button.transform = CGAffineTransform(rotationAngle: -.pi/2)
          button.tintColor = LabelForeground
          button.translatesAutoresizingMaskIntoConstraints = false
          button.addTarget(self, action: #selector(ActionLanguage), for: .touchUpInside)
          return button
       }()
        
        @objc func ActionLanguage() {
        delegate?.didLanguage()
        }

       lazy var LogoImageView:UIImageView = {
        let ImageView = UIImageView()
        ImageView.contentMode = .scaleAspectFit
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        return ImageView
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
        View.alpha = 0
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            backgroundColor = BackgroundColor
            addSubview(SettIngsLabel)
            addSubview(LogoImageView)
            addSubview(ViewLine)
            addSubview(LanguageIcon)
            addSubview(ViewTopLine)
            
            ViewLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ControlX(28)).isActive = true
            ViewLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            ViewLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            ViewLine.heightAnchor.constraint(equalToConstant: ControlHeight(0.8)).isActive = true
            
            ViewTopLine.leadingAnchor.constraint(equalTo: ViewLine.leadingAnchor).isActive = true
            ViewTopLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            ViewTopLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            ViewTopLine.heightAnchor.constraint(equalTo: ViewLine.heightAnchor).isActive = true
            
            LogoImageView.leadingAnchor.constraint(equalTo: ViewLine.leadingAnchor, constant: ControlX(8)).isActive = true
            LogoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            SettIngsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            SettIngsLabel.heightAnchor.constraint(equalTo: self.heightAnchor, constant: ControlHeight(-20)).isActive = true
            SettIngsLabel.leadingAnchor.constraint(equalTo: LogoImageView.trailingAnchor, constant: ControlX(20)).isActive = true
            SettIngsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ControlX(-10)).isActive = true
            
            LanguageIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            LanguageIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: ControlX(-15)).isActive = true
            LanguageIcon.heightAnchor.constraint(equalToConstant: ControlHeight(18)).isActive = true
            LanguageIcon.widthAnchor.constraint(equalToConstant: ControlHeight(13)).isActive = true
        }
        
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}
