//
//  NewsAndUpdateDetalls.swift
//  NewsAndUpdateDetalls
//
//  Created by Emoji Technology on 17/10/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import WebKit

class NewsAndUpdateDetalls: UIViewController , WKUIDelegate, WKNavigationDelegate {
    
    var IsVedio : Bool?
    var TextTi : String?
    var TextDe : String?
    var ImageUrl : String?
    var VedioUrl : String?
    var NewsAndUpdateId : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor
        SetUpItems()
        UpdateShowOffer()
    }

    
    fileprivate func SetUpItems() {
        
    view.addSubview(TopBackView)
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlWidth(20), height: ControlHeight(50))
            
    TopBackView.addSubview(ActivityIndicator)
    ActivityIndicator.frame = CGRect(x: view.frame.maxX - ControlHeight(45), y: ControlY(10), width: ControlHeight(30), height: ControlHeight(30))
            
    view.addSubview(ViewScroll)
    ViewScroll.frame = CGRect(x: 0, y: ControlY(100), width: view.frame.width, height: view.frame.height - ControlHeight(100))
     
    guard let TitleHeight = TextTi?.heightWithConstrainedWidth(view.frame.width - ControlWidth(40), font: UIFont.boldSystemFont(ofSize: ControlWidth(22))) else{return}
    guard  let DetailHeight = TextDe?.heightWithConstrainedWidth(view.frame.width - ControlWidth(40), font: UIFont.boldSystemFont(ofSize: ControlWidth(12))) else{return}
        
    ViewScroll.addSubview(ImageView)
    ViewScroll.addSubview(WebView)
    ViewScroll.addSubview(TitleLabel)
    ViewScroll.addSubview(DetailLabel)
    
    ImageView.frame = CGRect(x: 0, y: ControlY(10), width: view.frame.width, height: ControlHeight(300))
        
    WebView.frame = CGRect(x: 0, y: ControlY(10), width: view.frame.width, height: ControlHeight(300))
        
    TitleLabel.frame = CGRect(x: ControlX(20), y: ImageView.frame.maxY + ControlY(20), width: view.frame.width - ControlWidth(40), height: TitleHeight + ControlHeight(35))
    DetailLabel.frame = CGRect(x: ControlX(20), y: TitleLabel.frame.maxY + ControlY(5), width: view.frame.width - ControlWidth(40), height: DetailHeight + ControlHeight(35))
        
        
    if IsVedio ?? false {
        
    WebView.isHidden = false
    ImageView.isHidden = true
        
    if let Link = VedioUrl {
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
                
    if let ImageUrl = ImageUrl {
    self.ImageView.sd_setImage(with: URL(string: ImageUrl)) { Image, _, _, _ in
    self.ImageView.image = Image
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    self.ActivityIndicator.stopAnimating()
    }
    }
        
    }
        
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(ControlHeight(80))
    }
    
        
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.Space = 0
        View.textColor = LabelForeground
        View.FontSize = ControlWidth(30)
        View.text = "NEWSUPDATES".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }

    let ActivityIndicator:UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .white)
    aiv.hidesWhenStopped = true
    aiv.isHidden = true
    aiv.color = LabelForeground
    return aiv
    }()

    lazy var ViewScroll : UIScrollView = {
        let Scroll = UIScrollView()
        Scroll.backgroundColor = .clear
        Scroll.showsVerticalScrollIndicator = false
        Scroll.bounces = true
        return Scroll
    }()
    
    lazy var ImageView:UIImageView = {
        let ImageView = UIImageView()
        ImageView.contentMode = .scaleToFill
        ImageView.backgroundColor = .black
        return ImageView
    }()

    
    lazy var  TitleLabel : UILabel = {
    let label = UILabel()
    label.text = TextTi
    label.backgroundColor = .clear
    label.numberOfLines = 0
    label.sizeToFit()
    label.textColor = LabelForeground
    label.font = UIFont(name: "Campton-SemiBold", size:  ControlHeight(22))
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    return label
    }()
    
    lazy var DetailLabel : UILabel = {
    let label = UILabel()
    label.text = TextDe
    label.backgroundColor = .clear
    label.numberOfLines = 0
    label.textColor = LabelForeground
    label.font = UIFont(name: "Campton-SemiBold", size:  ControlHeight(12))
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    return label
    }()


    lazy var WebView: WKWebView = {
        let web = WKWebView(frame: .zero)
        web.clipsToBounds = true
        web.uiDelegate = self
        web.navigationDelegate = self
        web.isOpaque = false
        web.backgroundColor = HistoryButton
        return web
    }()
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    self.WebView.startShimmeringEffect()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    WebView.stopShimmeringEffect()
    ActivityIndicator.stopAnimating()
    }
    
}


///----------------------------------------------
/// MARK: GET DATA BY API
///----------------------------------------------
extension NewsAndUpdateDetalls {
    
    
    func UpdateShowOffer() {
    guard let url = defaults.string(forKey: "API") else{return}
    let Offer = "\(url + PhoneNewsAndUpdate)"
        
    guard let Url = URL(string:Offer) else {return}
    var components = URLComponents(url: Url, resolvingAgainstBaseURL: false)!

    if let Id = NewsAndUpdateId {
    components.queryItems = [URLQueryItem(name: "Id", value: "\(Id)")]
    guard let ComponentsUrl = components.url?.absoluteString else{return}
    AlamofireCall(Url: ComponentsUrl, HTTP: .put, parameters: nil, Err: {_ in})
    }
    }
    
}
