//
//  UploadFilesButton.swift
//  UploadFilesButton
//
//  Created by Emoji Technology on 13/10/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class UploadFilesButton: UIView {

    @IBInspectable
    var LabelText: String = "" {
        didSet{
            Label.text = "\(LabelText)  |"
        }
    }
    
    lazy var Button : UIButton = {
        let Button = UIButton(type: .system)
        Button.translatesAutoresizingMaskIntoConstraints = false
        return Button
    }()
    
    lazy var Label : UILabel = {
        let Label = UILabel()
        Label.textColor = #colorLiteral(red: 1, green: 0.971345441, blue: 0.9510625207, alpha: 1)
        Label.backgroundColor = .clear
        Label.translatesAutoresizingMaskIntoConstraints = false
        Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(12))
        return Label
    }()
    
    lazy var Image:UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var Cancel : UIButton = {
        let Button = UIButton(type: .system)
        let image = UIImage(named: "group269")?.withInset(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        Button.tintColor = LabelForeground
        Button.backgroundColor = .clear
        Button.setBackgroundImage(image, for: .normal)
        Button.translatesAutoresizingMaskIntoConstraints = false
        return Button
    }()

    private var ButtonRight: NSLayoutConstraint!
    private var ButtonLeft: NSLayoutConstraint!
    
    private var ButtonRightIsUpload: NSLayoutConstraint!
    private var ButtonLeftIsUpload: NSLayoutConstraint!
    
    private var CancelRight: NSLayoutConstraint!
    private var CancelRightIsUpload: NSLayoutConstraint!
    
    func IsUpload(_ Upload:Bool ,_ Duration:TimeInterval ,_ Move:Bool = true) {
    UIView.animate(withDuration: Duration) {
    self.Cancel.alpha = Upload ? 1:0
    self.Button.backgroundColor = Upload ? #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1) : #colorLiteral(red: 0.6768248081, green: 0.6769407988, blue: 0.6768085361, alpha: 1)
    self.LabelStar.isHidden = Upload
    self.Image.image = Upload ? UIImage(named:"group272") : UIImage(named:"UploadFiles")
        
    self.CancelRight.isActive = Upload
    self.CancelRightIsUpload.isActive = !Upload
        
    if Move {
    self.ButtonLeft.isActive = Upload
    self.ButtonRight.isActive = Upload
   
    self.ButtonLeftIsUpload.isActive = !Upload
    self.ButtonRightIsUpload.isActive = !Upload
    }else{
    self.ButtonLeft.isActive = true
    self.ButtonRight.isActive = true
       
    self.ButtonLeftIsUpload.isActive = false
    self.ButtonRightIsUpload.isActive = false
    }
        
    self.layoutIfNeeded()
    }
    }
    
    
    lazy var LabelStar : UILabel = {
        let Label = UILabel()
        Label.text = "*"
        Label.isHidden = true
        Label.font = UIFont.systemFont(ofSize: ControlWidth(18))
        Label.textColor = LabelForeground
        Label.backgroundColor = .clear
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(Cancel)
        addSubview(Button)
    
        ButtonRightIsUpload = Button.leftAnchor.constraint(equalTo: self.leftAnchor)
        ButtonRight = Button.rightAnchor.constraint(equalTo: self.rightAnchor)
        ButtonRight?.isActive = true
        
        ButtonLeftIsUpload = Button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: ControlX(-30))
        ButtonLeft = Button.leftAnchor.constraint(equalTo: self.leftAnchor, constant: ControlX(30))
        ButtonLeft?.isActive = true
        
        Button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        Button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        Button.addSubview(Label)
        Button.addSubview(Image)
        
        Label.topAnchor.constraint(equalTo: Button.topAnchor, constant: ControlY(5)).isActive = true
        Label.leftAnchor.constraint(equalTo: Button.leftAnchor, constant: ControlX(13)).isActive = true
        Label.bottomAnchor.constraint(equalTo: Button.bottomAnchor, constant: ControlY(-5)).isActive = true
        Label.rightAnchor.constraint(equalTo: Button.rightAnchor, constant: ControlY(-30)).isActive = true
        
        Image.centerYAnchor.constraint(equalTo: Button.centerYAnchor).isActive = true
        Image.rightAnchor.constraint(equalTo: Button.rightAnchor, constant: ControlWidth(-13)).isActive = true
        Image.widthAnchor.constraint(equalToConstant: ControlHeight(13)).isActive = true
        Image.heightAnchor.constraint(equalToConstant: ControlHeight(13)).isActive = true
        
        addSubview(LabelStar)
        LabelStar.topAnchor.constraint(equalTo: Button.topAnchor).isActive = true
        LabelStar.leftAnchor.constraint(equalTo: Button.rightAnchor , constant: ControlWidth(7)).isActive = true
        LabelStar.widthAnchor.constraint(equalToConstant: ControlWidth(12)).isActive = true
        LabelStar.heightAnchor.constraint(equalToConstant: ControlWidth(12)).isActive = true
        
        CancelRightIsUpload = Cancel.rightAnchor.constraint(equalTo: self.rightAnchor ,constant: ControlX(-40))
        CancelRight = Cancel.leftAnchor.constraint(equalTo: self.leftAnchor , constant: ControlX(5))
        CancelRight?.isActive = true
        
        Cancel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        Cancel.widthAnchor.constraint(equalToConstant: ControlHeight(16)).isActive = true
        Cancel.heightAnchor.constraint(equalToConstant: ControlHeight(16)).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
     super.layoutSubviews()
        layer.cornerRadius = self.frame.height / 2
        Button.layer.cornerRadius = Button.frame.height / 2
    }
    

}
