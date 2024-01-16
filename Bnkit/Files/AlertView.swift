//
//  AlertView.swift
//  Bnkit
//
//  Created by Emojiios on 19/06/2022.
//  Copyright © 2022 Mahmoud Tawab. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    public enum StyleAlert {
        case success,error,load,Hidden
    }
    
    lazy var ViewBackground:UIView = {
        let View = UIView()
        View.alpha = 0
        View.backgroundColor = HistoryTxet
        View.layer.cornerRadius = ControlX(10)
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    lazy var Indicator:InstagramActivityIndicator = {
        let aiv = InstagramActivityIndicator()
        aiv.alpha = 0
        aiv.layer.cornerRadius = 10
        aiv.animationDuration = 0.5
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
      
    lazy var Success:SuccessAnimatedView = {
        let Success = SuccessAnimatedView()
        Success.alpha = 0
        Success.translatesAutoresizingMaskIntoConstraints = false
        return Success
    }()

    lazy var Cancel:CancelAnimatedView = {
        let Cancel = CancelAnimatedView()
        Cancel.alpha = 0
        Cancel.translatesAutoresizingMaskIntoConstraints = false
        return Cancel
    }()
    
    var isShow = Bool()
    func SetIndicator(Style:StyleAlert) {

        switch Style {
        case .load:
            Show()
            Indicator.alpha = 1
            Cancel.alpha = 0
            Success.alpha = 0
            Indicator.startAnimating()
            
        case .success:
            Show()
            Indicator.alpha = 0
            Cancel.alpha = 0
            Success.alpha = 1
            Success.animate()
            Indicator.stopAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.SetIndicator(Style:.Hidden)
            }
            
        case .error:
            Show()
            Indicator.alpha = 0
            Cancel.alpha = 1
            Success.alpha = 0
            Cancel.animate()
            Indicator.stopAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.SetIndicator(Style:.Hidden)
            }
            
        case .Hidden:
        if isShow == true {
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut) {
        self.alpha = 0
        self.isShow = false
        self.ViewBackground.alpha = 0
        self.ViewBackground.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }
        }
        }
    }
    
    func Show() {
        if !isShow {
        self.alpha = 1
        self.isShow = true
        ViewBackground.alpha = 0
        ViewBackground.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil);
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.ViewBackground.alpha = 1
            self.ViewBackground.transform = .identity
        })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(ViewBackground)
        ViewBackground.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        ViewBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ViewBackground.widthAnchor.constraint(equalToConstant: ControlWidth(140)).isActive = true
        ViewBackground.heightAnchor.constraint(equalToConstant: ControlWidth(140)).isActive = true
            
        ViewBackground.addSubview(Indicator)
        Indicator.centerYAnchor.constraint(equalTo: ViewBackground.centerYAnchor).isActive = true
        Indicator.centerXAnchor.constraint(equalTo: ViewBackground.centerXAnchor).isActive = true
        Indicator.widthAnchor.constraint(equalToConstant: ControlWidth(70)).isActive = true
        Indicator.heightAnchor.constraint(equalToConstant: ControlWidth(70)).isActive = true
            
        ViewBackground.addSubview(Success)
        Success.centerYAnchor.constraint(equalTo: ViewBackground.centerYAnchor).isActive = true
        Success.centerXAnchor.constraint(equalTo: ViewBackground.centerXAnchor).isActive = true
        Success.widthAnchor.constraint(equalToConstant: ControlWidth(70)).isActive = true
        Success.heightAnchor.constraint(equalToConstant: ControlWidth(70)).isActive = true
            
        ViewBackground.addSubview(Cancel)
        Cancel.centerYAnchor.constraint(equalTo: ViewBackground.centerYAnchor).isActive = true
        Cancel.centerXAnchor.constraint(equalTo: ViewBackground.centerXAnchor).isActive = true
        Cancel.widthAnchor.constraint(equalToConstant: ControlWidth(70)).isActive = true
        Cancel.heightAnchor.constraint(equalToConstant: ControlWidth(70)).isActive = true
        
        perform(#selector(IsHiddenIndicator), with: self, afterDelay: 39)
    }
    
    @objc func IsHiddenIndicator() {
    if self.isShow == true {self.SetIndicator(Style:.Hidden)}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

