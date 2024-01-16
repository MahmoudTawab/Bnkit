//
//  HelpCell.swift
//  Bnkit
//
//  Created by Mohamed Tawab on 05/02/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import WebKit

class HelpCell: UITableViewCell , WKUIDelegate, WKNavigationDelegate {
        
    lazy var OpenClose : UIImageView = {
        let Image = UIImageView()
        Image.backgroundColor = .clear
        Image.image = UIImage(named: "LeftAndRight")
        Image.tintColor = #colorLiteral(red: 0.4391748011, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
        Image.contentMode = .scaleAspectFit
        Image.translatesAutoresizingMaskIntoConstraints = false
        return Image
    }()

    lazy var TextTitle : UILabel = {
        let Label = UILabel()
        Label.backgroundColor = .clear
        Label.textColor = LabelForeground
        Label.font = UIFont(name: "Campton-Medium" ,size: ControlWidth(17))
        return Label
    }()
    
    lazy var TheDetails : UILabel = {
        let Label = UILabel()
        Label.textColor = #colorLiteral(red: 0.4391748011, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
        Label.backgroundColor = .clear
        Label.numberOfLines = 0
        Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(12))
        return Label
    }()

    lazy var ViewTopLine : UIView = {
    let View = UIView()
    View.backgroundColor = HistoryButton
    View.translatesAutoresizingMaskIntoConstraints = false
    return View
    }()
    
    lazy var ViewLine : UIView = {
    let View = UIView()
    View.backgroundColor = HistoryButton
    View.translatesAutoresizingMaskIntoConstraints = false
    return View
    }()
    
    lazy var WebView: WKWebView = {
        let web = WKWebView(frame: .zero)
        web.layer.cornerRadius = ControlHeight(20)
        web.clipsToBounds = true
        web.uiDelegate = self
        web.navigationDelegate = self
        web.isOpaque = false
        web.backgroundColor = HistoryButton
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = TextViewForeground
        
        addSubview(ViewLine)
        addSubview(ViewTopLine)

        let childStackView = UIStackView(arrangedSubviews: [TextTitle, OpenClose])
        childStackView.axis = .horizontal
        childStackView.distribution = .fillProportionally
        childStackView.alignment = .center
        childStackView.spacing = ControlHeight(20)
        childStackView.backgroundColor = .clear
        childStackView.translatesAutoresizingMaskIntoConstraints = false
        childStackView.arrangedSubviews[1].widthAnchor.constraint(equalToConstant: ControlWidth(16)).isActive = true
        childStackView.arrangedSubviews[1].heightAnchor.constraint(equalToConstant: ControlHeight(16)).isActive = true
        
        ViewLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        ViewLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        ViewLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        ViewLine.heightAnchor.constraint(equalToConstant: ControlHeight(3)).isActive = true

        ViewTopLine.leadingAnchor.constraint(equalTo: ViewLine.leadingAnchor).isActive = true
        ViewTopLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        ViewTopLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        ViewTopLine.heightAnchor.constraint(equalTo: ViewLine.heightAnchor).isActive = true
         
        let StackVertical = UIStackView(arrangedSubviews: [childStackView,TheDetails,WebView])
        StackVertical.axis = .vertical
        StackVertical.spacing = ControlHeight(20)
        StackVertical.backgroundColor = .clear
        StackVertical.distribution = .equalSpacing
        StackVertical.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(StackVertical)
        
        StackVertical.arrangedSubviews[0].heightAnchor.constraint(equalToConstant: ControlHeight(30)).isActive = true
        StackVertical.arrangedSubviews[2].heightAnchor.constraint(equalToConstant: ControlHeight(220)).isActive = true
        
        StackVertical.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: ControlX(25)).isActive = true
        StackVertical.topAnchor.constraint(equalTo: self.topAnchor, constant: ControlY(20)).isActive = true
        StackVertical.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ControlX(-25)).isActive = true
        StackVertical.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: ControlY(-20)).isActive = true
        
        contentView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }

    
    func setValues(_ help: Help) {
        
    TextTitle.text = "lang".localizable == "en" ? help.enQuestion : help.arQuestion
    TheDetails.text =  "lang".localizable == "en" ? help.enAnswer : help.arAnswer
                
    TheDetails.isHidden = !help.HelpShow
    WebView.isHidden = !help.HelpShow
        
    if help.HelpShow {
    OpenClose.transform = CGAffineTransform(rotationAngle: .pi/2)
    if let Link = help.youtubeCode {
    if let videoURL = URL(string: "https://www.youtube.com/embed/\(Link)?playsinline=1") {
    if self.WebView.url != videoURL {
    self.WebView.configuration.allowsInlineMediaPlayback = true
    self.WebView.load(URLRequest(url: videoURL))
    }
    }
    }
    }else{
    self.WebView.configuration.allowsInlineMediaPlayback = false
    self.WebView.configuration.mediaTypesRequiringUserActionForPlayback = .all
    OpenClose.transform = CGAffineTransform(rotationAngle: -.pi/2)
    }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    self.WebView.startShimmeringEffect()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    WebView.stopShimmeringEffect()
    }

}



