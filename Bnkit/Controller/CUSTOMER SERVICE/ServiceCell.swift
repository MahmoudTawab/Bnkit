//
//  ServiceCell.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 10/14/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol ChatMessageDelegate {
    func ImageAction(_ cell:ServiceCell)
}

class ServiceCell: UICollectionViewCell {
    
    var message:Message?
    var chatLogController:CustomerServiceVC?
    var Delegate:ChatMessageDelegate?
    var CustomerService:CustomerServiceVC?
    var bubbleViewright:NSLayoutConstraint?
    var bubbleViewleft:NSLayoutConstraint?
    var bubbleWidth:NSLayoutConstraint?
    
    lazy var ViewBubble: UIView = {
        let View = UIView()
        View.layer.cornerRadius = ControlHeight(8)
        View.layer.masksToBounds = true
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    lazy var MessagesTV:UILabel = {
        let Label = UILabel()
        Label.numberOfLines = 0
        Label.textColor = .white
        Label.backgroundColor = .clear
        Label.font = UIFont(name: "Campton-Book", size: ControlWidth(15))
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    lazy var DateLabel : UILabel = {
        let Label = UILabel()
        Label.backgroundColor = .clear
        Label.textAlignment = .left
        Label.font = UIFont(name: "Campton-ExtraBold", size: ControlWidth(11))
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    lazy var messageImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = ControlHeight(8)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageView)))
        return imageView
    }()
    
    @objc func handleImageView() {
    Delegate?.ImageAction(self)
    }
    
    
    
    let transition = CircularTransition()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let Controller = CustomerService {
        transition.startingPoint = CGPoint(x: Controller.view.frame.midX, y: Controller.view.frame.maxY)
        }
        transition.transtitonMode = .present
        transition.circleColor = BackgroundColor
        return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let Controller = CustomerService {
        transition.startingPoint = CGPoint(x: Controller.view.frame.midX, y: Controller.view.frame.maxY)
        }
        transition.transtitonMode = .dismiss
        transition.circleColor = BackgroundColor
        return transition
    }
    
    
    let activityIndicatorView:UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.translatesAutoresizingMaskIntoConstraints = false
    aiv.hidesWhenStopped = true
    aiv.color = .white
    aiv.backgroundColor = .clear
    return aiv
    }()

    lazy var playButton:UIButton = {
        let button  = UIButton(type: .custom)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    var playerLayer:AVPlayerLayer?
    var player:AVPlayer?
    @objc func handlePlay() {
        if let videoUrlString = message?.videoUrl , let url = NSURL(string: videoUrlString)  {
        player = AVPlayer(url: url as URL)
        let vc = AVPlayerViewController()
        vc.player = player
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.view.contentMode = .scaleAspectFill
        activityIndicatorView.startAnimating()
        playButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object:vc.player?.currentItem)
        CustomerService?.present(vc, animated: true) {
        vc.player?.play()
        self.playButton.isHidden = false
        self.activityIndicatorView.stopAnimating()
        }
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification?) {
    CustomerService?.dismiss(animated: true)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    override init(frame: CGRect) {
    super.init(frame: frame)
        
    backgroundColor = BackgroundColor
    contentView.addSubview(ViewBubble)
    contentView.addSubview(MessagesTV)
        
    contentView.addSubview(messageImageView)
    contentView.addSubview(playButton)
    contentView.addSubview(activityIndicatorView)
    contentView.addSubview(DateLabel)
        
    ViewBubble.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    bubbleViewleft = ViewBubble.leftAnchor.constraint(equalTo: self.leftAnchor , constant: ControlX(15))
    bubbleViewleft?.isActive = true
        
    bubbleViewright = ViewBubble.rightAnchor.constraint(equalTo: self.rightAnchor , constant: ControlX(-15))
        
    bubbleWidth = ViewBubble.widthAnchor.constraint(equalToConstant: ControlWidth(260))
    bubbleWidth?.isActive = true
    ViewBubble.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    NSLayoutConstraint.activate([
    MessagesTV.leftAnchor.constraint(equalTo: ViewBubble.leftAnchor , constant: ControlX(10)),
    MessagesTV.topAnchor.constraint(equalTo: ViewBubble.topAnchor),
    MessagesTV.rightAnchor.constraint(equalTo: ViewBubble.rightAnchor, constant: ControlX(-10)),
    MessagesTV.heightAnchor.constraint(equalTo: ViewBubble.heightAnchor, constant: ControlHeight(-15)) ,
    
    messageImageView.leftAnchor.constraint(equalTo: ViewBubble.leftAnchor, constant: ControlX(4)),
    messageImageView.topAnchor.constraint(equalTo: ViewBubble.topAnchor, constant: ControlY(4)),
    messageImageView.rightAnchor.constraint(equalTo: ViewBubble.rightAnchor, constant: ControlX(-4)),
    messageImageView.bottomAnchor.constraint(equalTo: ViewBubble.bottomAnchor, constant: ControlY(-4)),
        
    playButton.centerXAnchor.constraint(equalTo: ViewBubble.centerXAnchor),
    playButton.centerYAnchor.constraint(equalTo: ViewBubble.centerYAnchor),
    playButton.widthAnchor.constraint(equalToConstant: ControlHeight(58)),
    playButton.heightAnchor.constraint(equalToConstant: ControlHeight(58)),
    
    activityIndicatorView.centerXAnchor.constraint(equalTo: ViewBubble.centerXAnchor),
    activityIndicatorView.centerYAnchor.constraint(equalTo: ViewBubble.centerYAnchor),
    activityIndicatorView.widthAnchor.constraint(equalToConstant: ControlHeight(58)),
    activityIndicatorView.heightAnchor.constraint(equalToConstant: ControlHeight(58)),
            
    DateLabel.bottomAnchor.constraint(equalTo: ViewBubble.bottomAnchor, constant: ControlY(-3)),
    DateLabel.leftAnchor.constraint(equalTo: ViewBubble.leftAnchor , constant: ControlX(10)),
    DateLabel.widthAnchor.constraint(equalToConstant: ControlWidth(55)),
    DateLabel.heightAnchor.constraint(equalToConstant: ControlHeight(20))
    ])
        
    playButton.layer.cornerRadius = ControlHeight(29)
    }
        
    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }

}

