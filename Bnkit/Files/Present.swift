//
//  Present.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/5/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//
    
   import UIKit
   import CoreData

   let defaults = UserDefaults.standard

   func isValidEmail(emailID:String) -> Bool {
   let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
   let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
   return emailTest.evaluate(with:emailID)
   }

   func Present(ViewController:UIViewController,ToViewController:UIViewController) {
   if topViewController(ViewController) != topViewController(ToViewController) {
    ToViewController.modalPresentationStyle = .overFullScreen
    ToViewController.modalTransitionStyle = .crossDissolve
    ViewController.present(ToViewController, animated: true)
   }
   }

   func PresentByNavigation(ViewController:UIViewController,ToViewController:UIViewController) {
    let Controller = ToViewController
    Controller.hidesBottomBarWhenPushed = true
    Controller.modalPresentationStyle = .fullScreen
    Controller.modalTransitionStyle = .coverVertical
    ViewController.navigationController?.pushViewController(Controller, animated: true)
   }

   func topViewController(_ controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
   if let navigationController = controller as? UINavigationController {
   return topViewController(navigationController.visibleViewController)}
   if let tabController = controller as? UITabBarController {
   if let selected = tabController.selectedViewController {
   return topViewController(selected)
   }
   }
   if let presented = controller?.presentedViewController {
   return topViewController(presented)
   }
   return controller
   }

   func Success() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        let transition: CATransition = CATransition()
        appDelegate.window?.rootViewController?.navigationController?.popViewController(animated: true)
        appDelegate.window?.makeKeyAndVisible()
        transition.duration = 0.5
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        appDelegate.window?.rootViewController?.view.window!.layer.add(transition, forKey: nil)
        let ControllerNav = UINavigationController(rootViewController: TabBarController())
        ControllerNav.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = ControllerNav
        appDelegate.window?.rootViewController?.modalTransitionStyle = .flipHorizontal
        appDelegate.window?.rootViewController?.modalPresentationStyle = .fullScreen
        }
    }


