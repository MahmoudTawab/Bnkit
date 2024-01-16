//
//  RequestFlnanceVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/13/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class RequestFlnanceVC: UIViewController {

    var Home:HomeVC?
    var ProductsServices:ProductsServicesVC?
    
    var StackHeight = CGFloat()
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = BackgroundColor
    SetUpItems()
    }
    
    func SetUpItems() {
                
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlWidth(20), height: ControlHeight(50))
        
    view.addSubview(TopBackView)
    let StackHorizontal = UIStackView(arrangedSubviews: [PersonalButton,CorporateButton,SmeButton])
    StackHorizontal.distribution = .fillEqually
    StackHorizontal.axis = .horizontal
    StackHorizontal.spacing = ControlHeight(5)
    StackHorizontal.backgroundColor = .clear
    view.addSubview(StackHorizontal)
    StackHorizontal.frame = CGRect(x: 0, y: ControlY(170) , width: view.frame.width, height: ControlWidth(375))
    }

    lazy var TopBackView: TopView = {
        let View = TopView()
        View.Space = ControlHeight(3)
        View.FontSize = ControlWidth(30)
        View.Button.tintColor = View.textColor
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
      lazy var PersonalButton : UIButton = {
      let Button = UIButton(type: .system)
      SetUpButton(button: Button, Background: "Personal", Title: "PERSONAL".localizable)
      Button.addTarget(self, action: #selector(ActionPersonal), for: .touchUpInside)
      return Button
      }()
          

      @objc func ActionPersonal() {
      PresentByNavigation(ViewController: self, ToViewController: PersonalVC())
      }
      
      lazy var CorporateButton : UIButton = {
      let Button = UIButton(type: .system)
      SetUpButton(button: Button, Background: "insurance", Title: "insurance".localizable)
      Button.addTarget(self, action: #selector(ActionCorporate), for: .touchUpInside)
      return Button
      }()
          

      @objc func ActionCorporate() {
      PresentByNavigation(ViewController: self, ToViewController: InsuranceVC())
      }
      
      lazy var SmeButton : UIButton = {
      let Button = UIButton(type: .system)
      SetUpButton(button: Button, Background: "SME&MICRO", Title: "SME&MICRO".localizable)
      Button.addTarget(self, action: #selector(ActionSme), for: .touchUpInside)
      return Button
      }()
          

      @objc func ActionSme() {
      PresentByNavigation(ViewController: self, ToViewController: SMEVC())
      }
      
      func SetUpButton(button:UIButton,Background:String,Title:String) {
      button.setTitleColor(.white, for: .normal)
      button.contentHorizontalAlignment = .center
      button.contentVerticalAlignment = .top
      button.titleLabel?.numberOfLines = 0
      button.layoutIfNeeded()
      button.setTitle(Title, for: .normal)
      button.backgroundColor = .clear
      button.subviews.first?.contentMode = .scaleAspectFill
      button.setBackgroundImage(UIImage(named: Background), for: .normal)
      button.titleLabel?.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(11.5))
      button.contentEdgeInsets = UIEdgeInsets(top: ControlY(100), left: 0, bottom: 0, right: 0)
      }
}
