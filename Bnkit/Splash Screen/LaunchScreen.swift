//
//  LaunchScreen.swift
//  Bnkit
//
//  Created by Mohamed Tawab on 05/02/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AVFoundation
import FirebaseAuth
import FirebaseFirestore

class LaunchScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        playVideo()
        perform(#selector(IfNotUser), with: self, afterDelay: 4)
    }
    
    fileprivate func playVideo() {
    guard let videoURL = Bundle.main.url(forResource: "Splash", withExtension: "mp4") else {return}
    let player = AVPlayer(url: videoURL)
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    playerLayer.videoGravity = .resizeAspectFill
    playerLayer.frame = view.bounds
    view.layer.addSublayer(playerLayer)
    player.play()
    }
    
    @objc func IfNotUser() {
    if GetUserObject().uid == nil {
    do {
    try Auth.auth().signOut()
    NotUser()
    }catch let signOutErr {
    NotUser()
    print(signOutErr.localizedDescription)
    }
    }else{
    Present(Controller: TabBarController())
    NotificationCenter.default.post(name: LogInController.NotificationSignOut, object: nil)
    }
    }
    
    func NotUser() {
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
    if key != "API" {defaults.removeObject(forKey: key)}}
    Present(Controller: TabBarController())
    NotificationCenter.default.post(name: LogInController.NotificationSignOut, object: nil)
    }
    
    @objc func Present(Controller:UIViewController) {
    let TabBar = Controller
    TabBar.modalPresentationStyle = .overCurrentContext
    TabBar.modalTransitionStyle = .crossDissolve
    present(TabBar, animated: true)
    }

}
