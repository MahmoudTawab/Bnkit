//
//  AppDelegate.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/4/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , MOLHResetable {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    static let PostNotification = NSNotification.Name(rawValue: "Notification")
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        LodAPI()
        
        let ControllerNav = UINavigationController(rootViewController: LaunchScreen())
        ControllerNav.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = ControllerNav
        
        MOLH.shared.activate(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = HistoryTxet
        
        UIImageView.appearance().isExclusiveTouch = true
        UILabel.appearance().isExclusiveTouch = true
        UIView.appearance().isExclusiveTouch = true
        UIButton.appearance().isExclusiveTouch = true
    
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
        } else {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func reset() {
    window?.rootViewController?.modalPresentationStyle = .fullScreen
    window?.rootViewController?.modalTransitionStyle = .flipHorizontal
    window?.rootViewController = TabBarController()
    IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "lang".localizable == "en" ? "Done" : "تم"
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }
        print(userInfo)
      }

      // [START receive_message]
      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
      }
      // [END receive_message]
      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
      }
    
      func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
      }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
        
    NotificationCenter.default.post(name: AppDelegate.PostNotification, object: nil)
    }
    print(userInfo)
    if #available(iOS 14.0, *) {
        completionHandler([.banner, .sound])
    } else {
        completionHandler([[.alert, .sound]])
    }
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)
    completionHandler()
  }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
        
    if let fcmToken = fcmToken {
    let dataDict:[String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
    guard let url = defaults.string(forKey: "API") else{return}
    let UrlToken = "\(url + FireToken)"
        
    guard let uid = GetUserObject().uid else{return}
    guard let sysToken = GetUserObject().sysToken else{return}
        
    let UpdateToken = [
    "uid": uid,
    "sysToken": sysToken,
    "fireToken": fcmToken
    ]
        
    if defaults.string(forKey: "Token") == fcmToken {
    return
    }else if Auth.auth().currentUser?.uid != nil {
    
    AlamofireCall(Url: UrlToken, HTTP: .put, parameters: UpdateToken,encoding: JSONEncoding.default) { 
    defaults.set(fcmToken, forKey: "Token")
    } Err: { (error) in
    print(error)
    }
        
    }
    }
    }
    
  }
  

