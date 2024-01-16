
//
//  iOSDropDown.swift
//
//
//  Created by Jishnu Raj T on 26/04/18.
//  Copyright © 2018 JRiOSdev. All rights reserved.
//
import UIKit

open class DropDown : UIButton {
    
    var Boll = true
    var arrow = Arrow()
    var table = UITableView()
    var shadow = UIView()
    
    public  var selectedIndex: Int?
    
    //MARK: IBInspectable
   @IBInspectable public var rowHeight: CGFloat = ControlHeight(30)
   @IBInspectable public var rowBackgroundColor: UIColor = .white
   @IBInspectable public var selectedRowColor: UIColor = .cyan
   @IBInspectable public var hideOptionsWhenSelect = true
    
    @IBInspectable public var listHeight: CGFloat = ControlHeight(150) {
        didSet {
         
        }
    }
    
    @IBInspectable public var borderColor: UIColor =  UIColor.lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var TitleColor: UIColor =  UIColor.lightGray {
        didSet {
            
        }
    }
    
    @IBInspectable public var SeparatorColor: UIColor =  UIColor.lightGray {
        didSet {
            
        }
    }
    
    
    @IBInspectable public var SelectedTitleColor: UIColor =  UIColor.lightGray {
        didSet {
            
        }
    }
    
    @IBInspectable public var Holder: String = "" {
        didSet {
            LabelTF.text = Holder
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    
    @IBInspectable var FontSize:CGFloat = 0 {
    didSet {
    self.titleLabel?.font = UIFont(name: "Campton-Light", size: FontSize)
    LabelTF.font = UIFont(name: "Campton-Light" ,size: FontSize)
    }
    }
    
    //Variables
    fileprivate var tableheightX: CGFloat = ControlX(100)
    fileprivate var dataArray = [String]()
    public var optionArray = [String]() {
        didSet{
        self.dataArray = self.optionArray
            self.table.reloadData()
        }
    }
    
    public var optionId : [Int]?
    public var optionIds = [Int]() {
        didSet{
        self.optionId = self.optionIds
        self.table.reloadData()
        }
    }
  
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = BackgroundColor
        

        arrow.backgroundColor = .clear
        arrow.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrow)
        arrow.rightAnchor.constraint(equalTo: self.rightAnchor , constant: ControlHeight(-10)).isActive = true
        arrow.centerYAnchor.constraint(equalTo: self.centerYAnchor ,constant: ControlY(2)).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: ControlHeight(20)).isActive = true
        
        contentHorizontalAlignment = "lang".localizable == "en" ? .left : .right
        contentVerticalAlignment = .center
        self.tintColor = TitleColor
        self.setTitleColor(self.TitleColor, for: .normal)
        arrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchAction)))
        addTarget(self, action: #selector(touchAction), for: .touchUpInside)
        
        self.addSubview(self.LabelTF)
        self.LabelTF.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    lazy var LabelTF : UILabel = {
        let Label = UILabel()
        Label.alpha = 0
        Label.textColor = LabelForeground
        Label.backgroundColor = .clear
        return Label
    }()
    
    @objc func ActionTF() {
    UIView.animate(withDuration: 0.25) {
    if (self.titleLabel?.text?.TextNull() == true) {
    self.LabelTF.frame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
    self.LabelTF.alpha = 1
    }else{
    self.LabelTF.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
    self.setTitleColor(self.TitleColor, for: .normal)
    self.LabelTF.alpha = 0
    }
    }
    }
    
    let activityIndicator:UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .white)
    aiv.hidesWhenStopped = true
    aiv.color = LabelForeground
    return aiv
    }()
    
    //MARK: Closures
    fileprivate var didSelectCompletion: (String, Int ,Int) -> () = {selectedText, index , id  in }
    fileprivate var TableWillAppearCompletion: () -> () = { }
    fileprivate var TableDidAppearCompletion: () -> () = { }
    fileprivate var TableWillDisappearCompletion: () -> () = { }
    fileprivate var TableDidDisappearCompletion: () -> () = { }


    public func showList() {
        
        TableWillAppearCompletion()
        
        table = UITableView(frame: CGRect(x: self.frame.minX,
                                          y: self.frame.minY,
                                          width: self.frame.width,
                                          height: self.frame.height))
        shadow = UIView(frame: CGRect(x: self.frame.minX,
                                      y: self.frame.minY,
                                      width: self.frame.width,
                                      height: self.frame.height))
        
        self.activityIndicator.center = self.center
        shadow.backgroundColor = .clear
        
        table.dataSource = self
        table.delegate = self
        table.alpha = 0
        table.layer.cornerRadius = 3
        table.backgroundColor = rowBackgroundColor
        table.rowHeight = rowHeight
        
        self.superview?.insertSubview(shadow, belowSubview: self)
        self.superview?.insertSubview(table, belowSubview: self)
        table.superview?.insertSubview(activityIndicator, belowSubview: self)
        
        self.isSelected = true

        DispatchQueue.main.async {
        if self.dataArray.count != 0 {
        self.table.separatorColor = self.SeparatorColor
        self.activityIndicator.stopAnimating()
        if self.listHeight > self.rowHeight * CGFloat(self.dataArray.count) {
        self.tableheightX = self.rowHeight * CGFloat(self.dataArray.count)
        }else{
        self.tableheightX = self.listHeight
        }
        UIView.animate(withDuration: 0.8,delay: 0,usingSpringWithDamping: 0.4,initialSpringVelocity: 0.1,options: .curveEaseInOut) {
        self.table.frame = CGRect(x: self.frame.minX,y: self.frame.maxY+ControlY(5),width: self.frame.width,height: self.tableheightX)
        self.table.alpha = 1
        self.shadow.frame = self.table.frame
        self.activityIndicator.center = self.table.center
        self.shadow.dropShadow()
        self.arrow.position = .up
        }
        }else{
        self.table.separatorColor = .clear
        self.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.8,delay: 0,usingSpringWithDamping: 0.4,initialSpringVelocity: 0.1,options: .curveEaseInOut) {
        self.table.frame = CGRect(x: self.frame.minX,y: self.frame.maxY+ControlY(5),width: self.frame.width,height: self.listHeight)
        self.table.alpha = 1
        self.shadow.frame = self.table.frame
        self.activityIndicator.center = self.table.center
        self.shadow.dropShadow()
        self.arrow.position = .up
        }
        }
        }
    }
    
    
    public func hideList() {
        
        TableWillDisappearCompletion()
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.frame.minX,
                                                  y: self.frame.minY,
                                                  width: self.frame.width,
                                                  height: 0)
                        self.shadow.alpha = 0
                        self.shadow.frame = self.table.frame
                        self.arrow.position = .down
                        self.activityIndicator.stopAnimating()
        },
                        completion: { (didFinish) -> Void in
                        self.shadow.removeFromSuperview()
                        self.table.removeFromSuperview()
                        self.isSelected = false
                        self.Boll = true
                        self.TableDidDisappearCompletion()
        })
    }
    
    @objc public func touchAction() {
        isSelected ?  hideList() : showList()
    }
    
    //MARK: Actions Methods
    public func didSelect(completion: @escaping (_ selectedText: String, _ index: Int , _ id:Int ) -> ()) {
        didSelectCompletion = completion
    }
    
    public func listWillAppear(completion: @escaping () -> ()) {
        TableWillAppearCompletion = completion
    }
    
    public func listDidAppear(completion: @escaping () -> ()) {
        TableDidAppearCompletion = completion
    }
    
    public func listWillDisappear(completion: @escaping () -> ()) {
        TableWillDisappearCompletion = completion
    }
    
    public func listDidDisappear(completion: @escaping () -> ()) {
        TableDidDisappearCompletion = completion
    }
    
}
    
///MARK: UITableViewDataSource
extension DropDown: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DropDownCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if indexPath.row != selectedIndex {
            cell?.backgroundColor = rowBackgroundColor
        }else {
            cell?.backgroundColor = selectedRowColor
        }
        
        cell?.textLabel?.text = "\(dataArray[indexPath.row])"
        cell?.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = HistoryTxet
        cell?.textLabel?.textAlignment = "lang".localizable == "en" ? .left : .right
        cell?.textLabel?.font = UIFont(name: "Campton-Medium", size: FontSize)
        return cell!
    }
    
}
//MARK: UITableViewDelegate
extension DropDown: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndex = (indexPath as NSIndexPath).row
    let selectedText = self.dataArray[self.selectedIndex!]
    tableView.cellForRow(at: indexPath)?.alpha = 0
    UIView.animate(withDuration: 0.4,
                       animations: { () -> Void in
                        tableView.cellForRow(at: indexPath)?.alpha = 1.0
                        tableView.cellForRow(at: indexPath)?.backgroundColor = self.selectedRowColor
        } ,
                       completion: { (didFinish) -> Void in
                        self.setTitle( "\(selectedText)", for: .normal)
                        self.setTitleColor(self.SelectedTitleColor, for: .normal)
                        self.ActionTF()
                        tableView.reloadData()
    })
    if hideOptionsWhenSelect {
    touchAction()
    }
    if let selected = optionArray.firstIndex(where: {$0 == selectedText}) {
    if let id = optionId?[selected] {
    didSelectCompletion(selectedText, selected , id )
    }else{
    didSelectCompletion(selectedText, selected , 0)
    }
    }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    DispatchQueue.main.async {
    if self.Boll {
    self.table.animateTable()
    self.Boll = false
    }
    }
    }

}

//MARK: Arrow
enum Position {
    case left
    case down
    case right
    case up
}

class Arrow: UIView {
    
    var position: Position = .down {
        didSet{
            switch position {
            case .left:
                self.transform = CGAffineTransform(rotationAngle: -.pi/2)
                break
            case .down:
                self.transform = CGAffineTransform(rotationAngle: .pi*2)
                break
            case .right:
                self.transform = CGAffineTransform(rotationAngle: .pi/2)
                break
            case .up:
                self.transform = CGAffineTransform(rotationAngle: .pi)
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let image = UIImageView()
        let Image = UIImage(named: "LeftAndRight")?.withInset(UIEdgeInsets(top: ControlY(6), left: ControlX(6), bottom: ControlY(6), right: ControlX(6)))
        image.image = Image
        image.contentMode = .scaleAspectFill
        image.transform = CGAffineTransform(rotationAngle: -.pi/2)
        image.tintColor = LabelForeground
        image.frame = self.bounds
        addSubview(image)
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
}
