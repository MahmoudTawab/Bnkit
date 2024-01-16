//
//  ViewNullData.swift
//  ViewNullData
//
//  Created by Emoji Technology on 03/10/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class ViewNullData: UIView {

    let ImageDataNull:UIImageView = {
    let ImageView = UIImageView()
    ImageView.image = UIImage(named: "TitleOfPage")
    ImageView.contentMode = .scaleAspectFit
    ImageView.backgroundColor = .clear
    ImageView.translatesAutoresizingMaskIntoConstraints = false
    return ImageView
    }()
    
    lazy var TryAgain : UIButton = {
        let Button = UIButton(type: .system)
        Button.setTitle("TryAgain".localizable, for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9439466596, green: 0.6406636238, blue: 0.6592981219, alpha: 1)
        Button.titleLabel?.font = UIFont.init(name: "Campton-Book", size: ControlWidth(20))
        Button.setTitleColor(UIColor.white, for: .normal)
        Button.layer.shadowColor = #colorLiteral(red: 0.9439466596, green: 0.6406636238, blue: 0.6592981219, alpha: 1)
        Button.layer.shadowOffset = CGSize(width: 5, height: 5)
        Button.layer.shadowRadius = 9
        Button.layer.shadowOpacity = 0.5
        Button.layer.cornerRadius = ControlHeight(25)
        Button.translatesAutoresizingMaskIntoConstraints = false
        return Button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(ImageDataNull)
        addSubview(TryAgain)
        
        ImageDataNull.centerYAnchor.constraint(equalTo: self.centerYAnchor , constant:  ControlY(-50)).isActive = true
        ImageDataNull.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ImageDataNull.widthAnchor.constraint(equalToConstant: ControlHeight(250)).isActive = true
        ImageDataNull.heightAnchor.constraint(equalToConstant: ControlHeight(250)).isActive = true
        
        TryAgain.topAnchor.constraint(equalTo: ImageDataNull.bottomAnchor , constant: ControlY(50)).isActive = true
        TryAgain.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        TryAgain.widthAnchor.constraint(equalTo:self.widthAnchor ,constant: ControlWidth(-100)).isActive = true
        TryAgain.heightAnchor.constraint(equalToConstant: ControlHeight(50)).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
