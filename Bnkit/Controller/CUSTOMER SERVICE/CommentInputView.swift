//
//  CommentInputView.swift
//  instagram
//
//  Created by Mahmoud Tawab on 8/7/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

protocol CommentInputViewDelegate {
    func didSubmit(for Comment:String)
    func didSendItems()
}

class CommentInputView: UIView , UIScrollViewDelegate {

    var delegate:CommentInputViewDelegate?
    
    lazy var ViewText:UIView = {
        let View = UIView()
        View.layer.cornerRadius = 8
        View.layer.borderColor = #colorLiteral(red: 0.3807084346, green: 0.3807084346, blue: 0.3807084346, alpha: 1)
        View.layer.borderWidth = ControlHeight(0.8)
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    lazy var TextView : GrowingTextView = {
    let TV = GrowingTextView()
    TV.placeholder = "TypeYourMessage".localizable
    TV.minHeight = ControlWidth(37)
    TV.maxHeight = ControlWidth(100)
    TV.placeholderColor = LabelForeground
    TV.font = UIFont(name: "Campton-Light", size: ControlWidth(14))
    TV.backgroundColor = .clear
    TV.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    TV.clipsToBounds = true
    TV.textColor = LabelForeground
    TV.autocorrectionType = .no
    TV.translatesAutoresizingMaskIntoConstraints = false
    TV.textContainerInset = UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4)
    return TV
    }()

    lazy var SendItemsButton : UIButton = {
        let Button = UIButton(type: .system)
        let image = UIImage(named: "group282")?.withInset(UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8))
        Button.backgroundColor = #colorLiteral(red: 0.8444725871, green: 0.6160533428, blue: 0.6682747006, alpha: 1)
        Button.layer.cornerRadius = ControlHeight(8)
        Button.tintColor = .white
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.setBackgroundImage(image, for: .normal)
        Button.addTarget(self, action: #selector(ActionSendItems), for: .touchUpInside)
        return Button
    }()

    @objc func ActionSendItems() {
    delegate?.didSendItems()
    }


    lazy var SubmitButton : UIButton = {
    let SB = UIButton(type: .system)
    let image = UIImage(named: "Group 1")?.withInset(UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8))
    SB.setBackgroundImage(image, for: .normal)
    SB.backgroundColor = #colorLiteral(red: 0.7962622643, green: 0.9145382047, blue: 0.8632406592, alpha: 1)
    SB.layer.cornerRadius = ControlHeight(8)
    SB.tintColor = .white
    SB.translatesAutoresizingMaskIntoConstraints = false
    SB.addTarget(self, action: #selector(ActionSubmit), for: .touchUpInside)
    return SB
    }()

    @objc func ActionSubmit() {
    guard let Comment =  TextView.text else {return}
    delegate?.didSubmit(for: Comment)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = BackgroundColor
        
        autoresizingMask = .flexibleHeight

        addSubview(SendItemsButton)
        SendItemsButton.leftAnchor.constraint(equalTo: leftAnchor, constant: ControlX(15)).isActive = true
        SendItemsButton.widthAnchor.constraint(equalToConstant: ControlWidth(40)).isActive = true
        SendItemsButton.heightAnchor.constraint(equalToConstant: ControlWidth(37)).isActive = true
        SendItemsButton.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        
        addSubview(ViewText)
        addSubview(TextView)
        ViewText.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        ViewText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ViewText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: ControlWidth(-120)).isActive = true
        ViewText.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        
        TextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        TextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        TextView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: ControlWidth(-120)).isActive = true
        TextView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
        
        addSubview(SubmitButton)
        SubmitButton.rightAnchor.constraint(equalTo: rightAnchor, constant: ControlX(-15)).isActive = true
        SubmitButton.widthAnchor.constraint(equalTo: SendItemsButton.widthAnchor).isActive = true
        SubmitButton.heightAnchor.constraint(equalTo: SendItemsButton.heightAnchor).isActive = true
        SubmitButton.bottomAnchor.constraint(equalTo: SendItemsButton.bottomAnchor).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

