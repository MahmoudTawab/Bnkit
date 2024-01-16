//
//  OfferDetaIlsVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 1/17/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class OfferDetaIlsVC: UIViewController {

    var TextTi : String?
    var TextDe : String?
    var ImageUrl : String?
    var OffId : Int?
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
        
    if let ImageUrl = ImageUrl {
    self.ImageView.sd_setImage(with: URL(string: ImageUrl)) { Image, _, _, _ in
    self.ImageView.image = Image
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    self.ActivityIndicator.stopAnimating()
    }
    }
    
    guard let TitleHeight = TextTi?.heightWithConstrainedWidth(view.frame.width - ControlWidth(40), font: UIFont.boldSystemFont(ofSize: ControlWidth(22))) else{return}
    guard let DetailHeight = TextDe?.heightWithConstrainedWidth(view.frame.width - ControlWidth(40), font: UIFont.boldSystemFont(ofSize: ControlWidth(12))) else{return}
        
    ViewScroll.addSubview(ImageView)
    ViewScroll.addSubview(TitleLabel)
    ViewScroll.addSubview(DetailLabel)
    
    ImageView.frame = CGRect(x: 0, y: ControlY(10), width: view.frame.width, height: ControlHeight(300))
        
    TitleLabel.frame = CGRect(x: ControlX(20), y: ImageView.frame.maxY + ControlY(20), width: view.frame.width - ControlWidth(40), height: TitleHeight + ControlWidth(35))
    DetailLabel.frame = CGRect(x: ControlX(20), y: TitleLabel.frame.maxY + ControlY(5), width: view.frame.width - ControlWidth(40), height: DetailHeight + ControlWidth(35))
        
    // MARK: - ViewScroll contentSize height
    ViewScroll.updateContentViewSize(ControlHeight(60))
    }
    
        
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.Space = 0
        View.textColor = LabelForeground
        View.FontSize = ControlWidth(30)
        View.text = "OFFERDETAILS".localizable
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
    label.font = UIFont(name: "Campton-SemiBold", size:  ControlWidth(22))
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    return label
    }()
    
    lazy var  DetailLabel : UILabel = {
    let label = UILabel()
    label.text = TextDe
    label.backgroundColor = .clear
    label.numberOfLines = 0
    label.textColor = LabelForeground
    label.font = UIFont(name: "Campton-SemiBold", size:  ControlWidth(12))
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    return label
    }()


}


///----------------------------------------------
/// MARK: GET DATA BY API
///----------------------------------------------
extension OfferDetaIlsVC {
    
    func UpdateShowOffer() {
    guard let url = defaults.string(forKey: "API") else{return}
    let Offer = "\(url + ShowOffer)"
        
    guard let Url = URL(string:Offer) else {return}
    var components = URLComponents(url: Url, resolvingAgainstBaseURL: false)!

    if let Id = OffId {
    components.queryItems = [URLQueryItem(name: "Id", value: "\(Id)")]
    guard let ComponentsUrl = components.url?.absoluteString else{return}
    AlamofireCall(Url: ComponentsUrl, HTTP: .put, parameters: nil, Err: {_ in})
    }
    }
    
}
