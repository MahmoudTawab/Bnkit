//
//  NewsAndUpdateCell.swift
//  NewsAndUpdateCell
//
//  Created by Emoji Technology on 17/10/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import WebKit

class NewsAndUpdateCell: UITableViewCell , WKUIDelegate, WKNavigationDelegate {
    
    lazy var ImageView:UIImageView = {
        let ImageView = UIImageView()
        ImageView.contentMode = .scaleAspectFill
        ImageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ImageView.translatesAutoresizingMaskIntoConstraints = false
        return ImageView
    }()

    lazy var ViewColor: UIView = {
        let View = UIView()
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    lazy var TitleLabel : UILabel = {
        let Label = UILabel()
        Label.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(12))
        Label.numberOfLines = 2
        Label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Label.backgroundColor = .clear
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    
    lazy var  BodyLabel : UILabel = {
        let Label = UILabel()
        Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(10))
        Label.backgroundColor = .clear
        Label.numberOfLines = 0
        Label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Label.translatesAutoresizingMaskIntoConstraints = false
        return Label
    }()
    
    lazy var View : UIView = {
        let View = UIView()
        View.clipsToBounds = true
        View.backgroundColor = .clear
        View.layer.cornerRadius = ControlHeight(10)
        View.translatesAutoresizingMaskIntoConstraints = false
        return View
    }()
    
    lazy var WebView: WKWebView = {
        let web = WKWebView(frame: .zero)
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
    backgroundColor = BackgroundColor
        
    addSubview(View)
    View.addSubview(WebView)
    View.addSubview(ImageView)
    View.addSubview(ViewColor)
    ViewColor.addSubview(TitleLabel)
    ViewColor.addSubview(BodyLabel)
        
    View.topAnchor.constraint(equalTo: self.topAnchor , constant: ControlY(12)).isActive = true
    View.bottomAnchor.constraint(equalTo: self.bottomAnchor , constant: ControlY(-12)).isActive = true
    View.leadingAnchor.constraint(equalTo: self.leadingAnchor , constant: ControlX(20)).isActive = true
    View.trailingAnchor.constraint(equalTo: self.trailingAnchor , constant: ControlX(-20)).isActive = true
        
    WebView.topAnchor.constraint(equalTo: View.topAnchor).isActive = true
    WebView.leftAnchor.constraint(equalTo: View.leftAnchor).isActive = true
    WebView.rightAnchor.constraint(equalTo: View.rightAnchor).isActive = true
    WebView.heightAnchor.constraint(equalToConstant: ControlHeight(139)).isActive = true
        
    ImageView.topAnchor.constraint(equalTo: View.topAnchor).isActive = true
    ImageView.leftAnchor.constraint(equalTo: View.leftAnchor).isActive = true
    ImageView.rightAnchor.constraint(equalTo: View.rightAnchor).isActive = true
    ImageView.heightAnchor.constraint(equalToConstant: ControlHeight(139)).isActive = true
      
    ViewColor.topAnchor.constraint(equalTo: ImageView.bottomAnchor).isActive = true
    ViewColor.leadingAnchor.constraint(equalTo: View.leadingAnchor).isActive = true
    ViewColor.trailingAnchor.constraint(equalTo: View.trailingAnchor).isActive = true
    ViewColor.bottomAnchor.constraint(equalTo: View.bottomAnchor).isActive = true
        
    TitleLabel.topAnchor.constraint(equalTo: ViewColor.topAnchor, constant: ControlY(10)).isActive = true
    TitleLabel.leadingAnchor.constraint(equalTo: ViewColor.leadingAnchor, constant: ControlX(15)).isActive = true
    TitleLabel.trailingAnchor.constraint(equalTo: ViewColor.trailingAnchor, constant: ControlX(-15)).isActive = true
    TitleLabel.heightAnchor.constraint(equalToConstant: ControlHeight(35)).isActive = true
        
    BodyLabel.topAnchor.constraint(equalTo: TitleLabel.bottomAnchor).isActive = true
    BodyLabel.leadingAnchor.constraint(equalTo: TitleLabel.leadingAnchor).isActive = true
    BodyLabel.trailingAnchor.constraint(equalTo: TitleLabel.trailingAnchor).isActive = true
    BodyLabel.bottomAnchor.constraint(equalTo: View.bottomAnchor , constant: ControlY(-10)).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValues(_ NewAndUpdate: NewsAndUpdates) {
    guard let isVedio = NewAndUpdate.isVedio else { return }
    if isVedio {
    WebView.isHidden = false
    ImageView.isHidden = true
    if let Link = NewAndUpdate.youtubeCode {
    if let videoURL = URL(string: "https://www.youtube.com/embed/\(Link)?playsinline=1") {
    if self.WebView.url != videoURL {
    self.WebView.configuration.allowsInlineMediaPlayback = true
    self.WebView.load(URLRequest(url: videoURL))
    }
    }
    }
    }else{
    WebView.isHidden = true
    ImageView.isHidden = false
    self.WebView.configuration.allowsInlineMediaPlayback = false
    self.WebView.configuration.mediaTypesRequiringUserActionForPlayback = .all
    }
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    self.WebView.startShimmeringEffect()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    WebView.stopShimmeringEffect()
    }
    
}


