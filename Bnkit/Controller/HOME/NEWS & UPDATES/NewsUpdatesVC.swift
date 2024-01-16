//
//  NewsUpdatesVC.swift
//  NewsUpdatesVC
//
//  Created by Emoji Technology on 29/09/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit

class NewsUpdatesVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BackgroundColor
        
        let viewControllers = [
        NewsVC(title: "NEWS".localizable),
        UpdatesVC(title: "UPDATES".localizable)
        ]
            
        let pagingViewController = PagingViewController(viewControllers: viewControllers)
        pagingViewController.menuItemSize = .fixed(width: view.frame.width / CGFloat(viewControllers.count), height: ControlWidth(140))
        
        pagingViewController.menuInsets = UIEdgeInsets(top: ControlY(70), left: 0, bottom: 0, right: 0)
        pagingViewController.indicatorOptions = .visible(height: ControlWidth(3), zIndex: 0, spacing: UIEdgeInsets(top: 0, left: 0, bottom: ControlY(68), right: 0), insets: UIEdgeInsets(top: 0, left: 0, bottom: ControlY(70), right: 0))
            
        pagingViewController.indicatorColor = HistoryTxet
        pagingViewController.borderColor = HistoryTxet
        pagingViewController.menuBackgroundColor = BackgroundColor
            
        pagingViewController.selectedFont = UIFont.systemFont(ofSize: ControlWidth(17))
        pagingViewController.selectedBackgroundColor = BackgroundColor
        pagingViewController.selectedTextColor = HistoryTxet
            
        pagingViewController.font = UIFont.systemFont(ofSize: ControlWidth(16))
        pagingViewController.textColor =  CalculatorDetaIls
        pagingViewController.backgroundColor = BackgroundColor
            
        pagingViewController.menuItemSpacing = ControlWidth(10)
    
        pagingViewController.view.addSubview(TopBackView)
        TopBackView.frame = CGRect(x: ControlX(5), y: ControlY(20), width: view.frame.width - ControlWidth(10), height: ControlWidth(50))
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
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
}

