//
//  ReusableView.swift
//  ReusableView
//
//  Created by Emoji Technology on 19/09/2021.
//

import UIKit

class ReusableView: UICollectionReusableView {
    
    lazy var Label : UILabel = {
        let Label = UILabel()
        Label.textAlignment = .center
        Label.font = UIFont(name: "Campton-Medium" ,size: ControlWidth(15.5))
        Label.textColor = LabelForeground
        Label.backgroundColor = BackgroundColor
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    lazy var View : UIView = {
        let View = UIView()
        View.backgroundColor = LabelForeground
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = BackgroundColor
        addSubview(View)
        addSubview(Label)
        Label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        Label.heightAnchor.constraint(equalTo: self.heightAnchor , constant: ControlHeight(-10)).isActive = true
        Label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        Label.widthAnchor.constraint(equalToConstant: ControlWidth(180)).isActive = true
            
        View.heightAnchor.constraint(equalToConstant: ControlHeight(0.7)).isActive = true
        View.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        View.leftAnchor.constraint(equalTo: leftAnchor , constant: ControlX(15)).isActive = true
        View.rightAnchor.constraint(equalTo: rightAnchor , constant: ControlX(-15)).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
