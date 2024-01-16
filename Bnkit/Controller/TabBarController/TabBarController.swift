//
//  TabBarController.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        SetUpController()
    }
    
    func SetUpController() {
        let Notifications = getController(root: NotificationsVC(), selectedImage: "path1481", image: "path1481")
        
        let RequestHistory = getController(root: RequestHistoryVC(), selectedImage: "group249", image: "group249")
        
        let Home = getController(root: HomeVC(), selectedImage: "group352", image: "group352")

        let Contact = ContactController()
        Contact.SignIn = true
        let CustomerService = getController(root: Contact, selectedImage: "group83", image: "group83")
        
        let SettIngs = getController(root: SettIngsVC(), selectedImage: "group351", image: "group351")
        
        viewControllers = [Notifications,RequestHistory,Home,CustomerService,SettIngs]
        
        self.selectedIndex = 2
        
        if let items = tabBar.items {
        for item in items {
        item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        }
    }
    
    func getController(root: UIViewController , selectedImage: String, image: String) -> UIViewController {
        let controller = UINavigationController(rootViewController: root)
        controller.navigationBar.isHidden = true
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage)
        controller.tabBarItem.image = UIImage(named: image)
        
        tabBar.tintColor = #colorLiteral(red: 0.9439466596, green: 0.6406636238, blue: 0.6592981219, alpha: 1)
        tabBar.backgroundColor = tabBarForeground
        tabBar.barTintColor = tabBarForeground
        tabBar.unselectedItemTintColor = LogInColors
        tabBar.clipsToBounds = true
        tabBar.layer.borderColor = UIColor.clear.cgColor
        return controller
    }
    
    init() {
    super.init(nibName: nil, bundle: nil)
    object_setClass(self.tabBar, WeiTabBar.self)
    }

    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
}


class WeiTabBar: UITabBar {
      override func sizeThatFits(_ size: CGSize) -> CGSize {
          var sizeThatFits = super.sizeThatFits(size)
          sizeThatFits.height = ControlHeight(50)
          return sizeThatFits
      }
  }
