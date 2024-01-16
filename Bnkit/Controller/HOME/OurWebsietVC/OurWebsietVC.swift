//
//  OurWebsietVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 10/25/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import WebKit

enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class OurWebsietVC: UIViewController , WKUIDelegate, WKNavigationDelegate {
    
    lazy var webView: WKWebView = {
        let web = WKWebView()
        web.isOpaque = false
        web.uiDelegate = self
        web.navigationDelegate = self
        web.backgroundColor = BackgroundColor
        web.scrollView.showsVerticalScrollIndicator = false
        return web
    }()
    
    lazy var View: UIView = {
        let View = UIView()
        View.layer.cornerRadius = ControlHeight(15)
        View.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:))))
        return View
    }()
    
    lazy var TopView: UIView = {
        let View = UIView()
        View.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        View.layer.shadowPath = UIBezierPath(rect: View.bounds).cgPath
        View.layer.shadowRadius = 3
        View.layer.shadowOffset = .zero
        View.layer.shadowOpacity = 1
        View.layer.cornerRadius = ControlHeight(3)
        View.layer.masksToBounds = false
        return View
    }()
    
    lazy var ViewLine: UIView = {
        let View = UIView()
        View.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return View
    }()
    
    lazy var ButtonBack : UIButton = {
        let Button = UIButton(type: .system)
        let Image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: ControlY(10), left: ControlX(10), bottom: ControlY(10), right: ControlX(10)))
        Button.tintColor = HistoryTxet
        Button.backgroundColor = .clear
        Button.setBackgroundImage(Image, for: .normal)
        Button.addTarget(self, action: #selector(ActionBack), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionBack() {
    webView.goBack()
    if let currentURL = self.webView.url?.absoluteString {
    Label.text = currentURL
    }
    }
    
    lazy var ButtonDismiss : UIButton = {
        let Button = UIButton(type: .system)
        Button.backgroundColor = .clear
        Button.tintColor = HistoryTxet
        Button.setTitle("X", for: .normal)
        Button.titleLabel?.font = UIFont(name: "ArialRoundedMTBold" ,size: ControlWidth(19))
        Button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        Button.addTarget(self, action: #selector(ActionDismiss), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionDismiss() {
    UIView.animate(withDuration: 0.2) {
    self.visualEffectView.effect = nil
    self.dismiss(animated: true)
    }
    }
    
    lazy var Label : UILabel = {
        let Label = UILabel()
        Label.font = UIFont(name: "Campton-Light" ,size: ControlWidth(16))
        Label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        Label.textAlignment = .center
        Label.backgroundColor = .clear
        return Label
    }()

    
    override func viewDidLoad() {
    super.viewDidLoad()
    View.backgroundColor = BackgroundColor
        
    if let url = defaults.string(forKey: "website") {
    if let string = URL(string: url) {
    Label.text = url
    self.webView.load(URLRequest(url:string))
    }
    }
        
    setupCard()
        
    view.addSubview(View)
    View.frame = CGRect(x: 0, y: ControlY(40), width: view.frame.width, height: view.frame.height - ControlHeight(20))
        
    View.addSubview(TopView)
    TopView.frame = CGRect(x: view.center.x - ControlWidth(45), y: ControlY(5), width: ControlWidth(90), height: ControlHeight(5))

    View.addSubview(ButtonBack)
    ButtonBack.frame = CGRect(x: ControlX(15), y: ControlY(20), width: ControlHeight(30), height: ControlHeight(30))
    View.addSubview(ButtonDismiss)
    ButtonDismiss.frame = CGRect(x: View.frame.maxX - ControlHeight(45), y: ControlY(20), width: ControlHeight(30), height: ControlHeight(30))
    View.addSubview(Label)
    Label.frame = CGRect(x: ControlX(55), y: ControlY(20), width: View.frame.width - ControlWidth(110), height: ControlHeight(30))

    View.addSubview(ViewLine)
    ViewLine.frame = CGRect(x: ControlX(20), y: ControlY(60), width: View.frame.width - ControlWidth(40), height: ControlHeight(1))
        
    View.addSubview(webView)
    webView.frame = CGRect(x: 0, y: ViewLine.frame.maxY, width: View.frame.width, height: View.frame.height - ControlHeight(80))

    webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    Label.startShimmeringEffect()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
    if  Float(webView.estimatedProgress) == 1 {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    self.Label.stopShimmeringEffect()
    }
    }else{
    Label.startShimmeringEffect()
    }
    }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if let currentURL = self.webView.url?.absoluteString {
    Label.text = currentURL
    }
    }
    
    
    var visualEffectView:UIVisualEffectView!
    var endCardHeight:CGFloat = 0
    var startCardHeight:CGFloat = 0
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    func setupCard() {
    endCardHeight = self.view.frame.height - ControlHeight(40)
    startCardHeight = 0
    visualEffectView = UIVisualEffectView()
    visualEffectView.frame = self.view.frame
    self.view.addSubview(visualEffectView)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
    UIView.animate(withDuration: 0.9) {
    self.visualEffectView.effect = UIBlurEffect(style: .dark)
    }
    }
    }
     
    private var currentState: State = .open
    private var animationProgress = [CGFloat]()
    @objc func handleCardPan (recognizer:UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
    animateTransitionIfNeeded(state: currentState.opposite, duration:  0.9)
    runningAnimations.forEach { $0.pauseAnimation() }
    animationProgress = runningAnimations.map { $0.fractionComplete }
    case .changed:
    let translation = recognizer.translation(in: View)
    var fraction = -translation.y / endCardHeight
    if currentState == .open { fraction *= -1 }
    if runningAnimations[0].isReversed { fraction *= -1 }

    for (index, animator) in runningAnimations.enumerated() {
    animator.fractionComplete = fraction + animationProgress[index]
    }
    case .ended:
    let yVelocity = recognizer.velocity(in: View).y
    let shouldClose = yVelocity > 0
    if yVelocity == 0 {
    runningAnimations.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
    break
    }
    switch currentState {
    case .open:
    if !shouldClose && !runningAnimations[0].isReversed { runningAnimations.forEach { $0.isReversed = !$0.isReversed } }
    if shouldClose && runningAnimations[0].isReversed { runningAnimations.forEach { $0.isReversed = !$0.isReversed } }
    case .closed:
    if shouldClose && !runningAnimations[0].isReversed { runningAnimations.forEach { $0.isReversed = !$0.isReversed } }
    if !shouldClose && runningAnimations[0].isReversed { runningAnimations.forEach { $0.isReversed = !$0.isReversed } }
    }
    runningAnimations.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
    default:
    break
    }
    }
    
    func animateTransitionIfNeeded (state:State, duration:TimeInterval) {
    guard runningAnimations.isEmpty else { return }
        
    let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.9) {
    switch state {
    case .open:
    self.View.frame.origin.y = self.view.frame.height - self.endCardHeight
    
    case .closed:
    self.View.frame.origin.y = self.view.frame.height - self.startCardHeight
    }
    }
        
    frameAnimator.addCompletion { position in
    switch position {
    case .start:
    self.currentState = state.opposite
    case .end:
    self.currentState = state
    case .current:
    ()
    default:
    break
    }
        
    switch self.currentState {
    case .open:
    self.View.frame.origin.y = self.view.frame.height - self.endCardHeight
    case .closed:
    self.View.frame.origin.y = self.view.frame.height - self.startCardHeight
    self.dismiss(animated: false)
    }
        
    self.runningAnimations.removeAll()
    }
    
    frameAnimator.startAnimation()
    runningAnimations.append(frameAnimator)
    let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
    switch state {
    case .open:
    self.View.layer.cornerRadius = ControlHeight(15)
    case .closed:
    self.View.layer.cornerRadius = ControlHeight(5)
    }
    }
    cornerRadiusAnimator.startAnimation()
    runningAnimations.append(cornerRadiusAnimator)
        
    let EffectAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
    switch state {
    case .open:
    self.visualEffectView.effect = UIBlurEffect(style: .dark)
    case .closed:
    self.visualEffectView.effect = nil
    }
    }
        
    EffectAnimator.startAnimation()
    runningAnimations.append(EffectAnimator)
    }

}

