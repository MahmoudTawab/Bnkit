//
//  CustomerServiceVC.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/6/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import CoreData
import Photos
import AVFoundation
import FirebaseStorage
import AudioToolbox
import FirebaseAuth
import FirebaseFirestore
import MobileCoreServices
import FlagPhoneNumber

class CustomerServiceVC: UIViewController , UICollectionViewDelegateFlowLayout , UITextViewDelegate , ChatMessageDelegate , MediaBrowserDelegate , UIGestureRecognizerDelegate, UICollectionViewDataSource , UIViewControllerTransitioningDelegate ,GrowingTextViewDelegate, CommentInputViewDelegate {
    
    let cellId = "cellId"
    var messages = [Message]()
    var sections = [GroupedSection<Date, Message>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    view.backgroundColor = BackgroundColor
 
    view.addSubview(TopBackView)
    TopBackView.frame = CGRect(x: ControlX(10), y: ControlY(40), width: view.frame.width - ControlX(20), height: ControlHeight(50))
            
    TopBackView.addSubview(ActivityIndicator)
    ActivityIndicator.frame = CGRect(x: view.frame.maxX - ControlHeight(45), y: ControlY(10), width: ControlHeight(30), height: ControlHeight(30))
        
    view.addSubview(inputContainerView)
    inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    textViewBottomConstraint = inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    textViewBottomConstraint?.isActive = true
        
    view.addSubview(CollectionView)
    CollectionView.topAnchor.constraint(equalTo: TopBackView.bottomAnchor, constant: ControlHeight(20)).isActive = true
    CollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    CollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    CollectionView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: ControlY(-5)).isActive = true
                
    view.addSubview(ScrollLastIndex)
    ScrollLastIndex.rightAnchor.constraint(equalTo: view.rightAnchor , constant: ControlX(-10)).isActive = true
    ScrollLastIndex.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: ControlY(-60)).isActive = true
    ScrollLastIndex.widthAnchor.constraint(equalToConstant: ControlWidth(36)).isActive = true
    ScrollLastIndex.heightAnchor.constraint(equalToConstant: ControlHeight(36)).isActive = true

    readTimestampAction()
        
    view.addSubview(Alert)
    Alert.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,object: nil, queue: OperationQueue.main,using: keyboardWillShowNotification)
        
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,object: nil, queue: OperationQueue.main,
        using: keyboardWillHideNotification)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShowNotification(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        textViewBottomConstraint.constant = -keyboardSize.height
        view.layoutIfNeeded()
        animateViewMoving()
        
        if sections.count != 0 {
        if self.ScrollLastIndex.alpha == 0 {
        self.CollectionView.scrollToItem(at: IndexPath(item: (self.sections.last?.rows.count ?? 0) - 1, section: self.sections.count - 1), at: .bottom, animated: true)
        }
        }
    }
    
    func keyboardWillHideNotification(notification: Notification) {
        self.textViewBottomConstraint.constant = 0
        animateViewMoving()
    }
    
    func animateViewMoving() {
        let movementDuration:TimeInterval = 0.5
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        UIView.commitAnimations()
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if sections.count != 0 {
    let visibleCells: [IndexPath] = CollectionView.indexPathsForVisibleItems
    let lastIndexPath = IndexPath(item: (sections.last?.rows.count ?? 0) - 1, section: sections.count - 1)
    if visibleCells.contains(lastIndexPath) {
    ScrollAnimate(Show: false)
    }else{
    ScrollAnimate(Show: true)
    }
    }
    }
    
    lazy var TopBackView: TopView = {
        let View = TopView()
        View.textColor = LabelForeground
        View.Space = ControlHeight(4)
        View.FontSize = ControlWidth(30)
        View.text = "CUSTOMERSERVICE".localizable
        View.Button.addTarget(self, action: #selector(ButtonAction), for: .touchUpInside)
        return View
    }()
    
    @objc func ButtonAction() {
    self.navigationController?.popViewController(animated: true)
    }
    
    lazy var CollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = ControlWidth(15)
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.dataSource = self
        vc.delegate = self
        vc.alwaysBounceVertical = true
        vc.backgroundColor = BackgroundColor
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.register(ServiceCell.self, forCellWithReuseIdentifier: cellId)
        vc.register(ReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Kind")
        return vc
    }()


    lazy var ScrollLastIndex : UIButton = {
        let Button = UIButton(type: .system)
        Button.setImage(UIImage(named: "scroll_down"), for: .normal)
        Button.alpha = 0
        Button.backgroundColor = .clear
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.addTarget(self, action: #selector(ActionLastIndex), for: .touchUpInside)
        return Button
    }()
    
    @objc func ActionLastIndex(animated:Bool = false) {
    if sections.count != 0 {
    self.CollectionView.scrollToItem(at: IndexPath(item: (self.sections.last?.rows.count ?? 0) - 1, section: self.sections.count - 1), at: .bottom, animated: animated)
    self.ScrollAnimate(Show: false)
    }
    }
    
    func ScrollAnimate(Show: Bool) {
    if ScrollLastIndex.alpha == 0 {
    UIView.animate(withDuration: 0.2) {
    self.ScrollLastIndex.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    }
    }
    UIView.transition(with: ScrollLastIndex, duration: 0.4, options: .transitionCrossDissolve, animations: {
    self.ScrollLastIndex.transform = Show ? CGAffineTransform(scaleX: 1, y: 1):CGAffineTransform(scaleX: 1, y: 1)
    self.ScrollLastIndex.transform = Show ? CGAffineTransform(rotationAngle: .pi * 2):CGAffineTransform(rotationAngle: 0)
    self.ScrollLastIndex.alpha = Show ? 1:0
    })
    }

    
    func readTimestampAction() {
        
    if Reachability.isConnectedToNetwork() {
    let db = Firestore.firestore()
    guard let uid = GetUserObject().uid else{return}
        
    db.collection("Messages").document(uid).addSnapshotListener { (querySnapshot, err) in
    if let err = err {
    self.Error(err.localizedDescription)
    } else {

    self.NullData.removeFromSuperview()
    guard let data = querySnapshot!.data() else {return}
                            
    if let Detail = data["Messages"] as? [[String: Any]] {
    let NumberMedia = data["NumberMedia"] as? Int ?? 0
        
    if NumberMedia != 0 {
    self.NumberMedia = NumberMedia
    }
        
    self.messages = Detail.map { (query) -> Message in
    return Message(dictionary: query)
    }
    
    DispatchQueue.main.async {
        
    self.sections = GroupedSection.group(rows: self.messages, by: { self.firstDayOfMonth(date: Date(timeIntervalSince1970: $0.date ?? TimeInterval()))})

    self.sections.sort { lhs, rhs in lhs.sectionItem < rhs.sectionItem }
        
    self.thumbs = self.multiVideos()
    self.mediaArray = self.multiVideos()
    self.CollectionView.reloadData()
    self.ActionLastIndex(animated:true)
    }
    }
    }
    }
            
    }else{
    view.addSubview(NullData)
    NullData.frame = CGRect(x: 0, y: ControlY(130), width: view.frame.width, height: view.frame.height - ControlHeight(200))
    self.Error("InternetNotAvailable".localizable)
    }
    }

    
    private var textViewBottomConstraint: NSLayoutConstraint!
    lazy var inputContainerView : CommentInputView = {
    let chatInput = CommentInputView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: ControlWidth(58)))
    chatInput.delegate = self
    chatInput.TextView.delegate = self
    chatInput.translatesAutoresizingMaskIntoConstraints = false
    return chatInput
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let section = self.sections[section]
    return section.rows.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ServiceCell
        
    let section = self.sections[indexPath.section]
    let headline = section.rows[indexPath.row]
        
    cell.chatLogController = self
    cell.Delegate = self
                    
    cell.message = headline

    setupCell(cell: cell, message: headline)
    if let text = headline.text {
    cell.bubbleWidth?.constant = estimateFrameForText(txet:text).width + ControlWidth(35)
    cell.MessagesTV.isHidden = false
    cell.MessagesTV.text = headline.text
    cell.MessagesTV.decideTextDirection()
    }else if headline.imageUrl != nil || headline.imageVideo != nil {
    cell.bubbleWidth?.constant = view.frame.width - ControlWidth(100)
    cell.MessagesTV.isHidden = true
    }
    cell.playButton.isHidden = headline.videoUrl == nil
    return cell
    }
    


    private func setupCell(cell:ServiceCell ,message:Message) {
        
    if let seconds = message.date {
    let timestamDate = Date(timeIntervalSince1970: seconds)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    cell.DateLabel.text = dateFormatter.string(from: timestamDate)
    }
        
    if message.isIncoming ?? true {
//    outgoing Color1
    cell.ViewBubble.backgroundColor = #colorLiteral(red: 0.9789747596, green: 0.6830342412, blue: 0.6927182078, alpha: 1)

    cell.bubbleViewright?.isActive = true
    cell.bubbleViewleft?.isActive = false
    }else{
//    incoming Color2
    cell.ViewBubble.backgroundColor = #colorLiteral(red: 0.7962622643, green: 0.9145382047, blue: 0.8632406592, alpha: 1)
        
    cell.bubbleViewright?.isActive = false
    cell.bubbleViewleft?.isActive = true
    }
        
        
    if message.imageUrl != nil || message.imageVideo != nil {
    cell.activityIndicatorView.startAnimating()
        
    if let ImageVideo = message.imageVideo {
    if let VideoImage = URL(string: ImageVideo) {
    cell.messageImageView.sd_setImage(with: VideoImage) { (Image, Error, type, URL) in
    if Image != nil {
    cell.activityIndicatorView.stopAnimating()
    }
    }
    }
    }

    if let ImageUrl = message.imageUrl {
    if let Image = URL(string: ImageUrl) {
    cell.messageImageView.sd_setImage(with: Image) { (Image, Error, type, URL) in
    if Image != nil {
    cell.activityIndicatorView.stopAnimating()
    }
    }
    }
    }

    cell.messageImageView.isHidden = false
    cell.DateLabel.textColor = .lightGray
    }else{
    cell.messageImageView.isHidden = true
    cell.DateLabel.textColor = .white
    }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height:CGFloat = ControlHeight(80)
        
    let section = self.sections[indexPath.section]
    let headline = section.rows[indexPath.row]
        
    if let txet = headline.text {
    height = estimateFrameForText(txet: txet).height + ControlHeight(35)
    }else {
    height = ControlHeight(250)
    }

    return CGSize(width: collectionView.frame.width , height: height)
    }

    
    private func estimateFrameForText(txet:String) -> CGRect {
    let size = CGSize(width: view.frame.width - ControlWidth(100), height: ControlHeight(1000))
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    return  NSString(string: txet).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: ControlWidth(15))], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Kind", for: indexPath) as! ReusableView
        let section = self.sections[indexPath.section]
        let date = section.sectionItem

        view.Label.text = date.timeIntervalSince1970.Difference(from: date.timeIntervalSince1970)
        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: ControlHeight(50))
    }
    
    func ImageAction(_ cell: ServiceCell) {
    if let index = CollectionView.indexPath(for: cell) {
    let section = self.sections[index.section]
    let headline = section.rows[index.row]
    if headline.videoUrl != nil {
    cell.handlePlay()
    }else{
    let browser = MediaBrowser(delegate: self)
    browser.setCurrentIndex(at: headline.NumberMedia ?? 0)
    browser.displayMediaNavigationArrows = true
    browser.enableSwipeToDismiss = false
    let nc = UINavigationController(rootViewController: browser)
    nc.modalPresentationStyle = .custom
    nc.transitioningDelegate = self
    present(nc, animated: true)
    }
    }
    }
    
    var mediaArray = [Media]()
    var thumbs = [Media]()
    func numberOfMedia(in mediaBrowser: MediaBrowser) -> Int {
    return thumbs.count
    }
    
    func thumbnail(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
    return thumbs[index]
    }

    func media(for mediaBrowser: MediaBrowser, at index: Int) -> Media {
    return mediaArray[index]
    }
    
    func multiVideos() -> [Media] {
    var photos = [Media]()
        
    _ = messages.filter { (Messa) -> Bool in
    if let imageUrl = Messa.imageUrl {
    let photo = webMediaPhoto(url: imageUrl, caption: nil)
    photos.append(photo)
    return true
    }else{
    return false
    }
    }
        
    _ = messages.filter { (Messa) -> Bool in
    if let videoUrl = Messa.videoUrl , let imageVideo = Messa.imageVideo {
    let video = webMediaVideo(url: videoUrl, previewImageURL: imageVideo)
    photos.append(video)
    return true
    }else{
    return false
    }
    }
    
    return photos
    }
    
    func multiVideoThumbs() -> [Media] {
    var photos = [Media]()
    _ = messages.filter { (Messa) -> Bool in
    if let imageUrl = Messa.imageVideo {
    let photo = webMediaPhoto(url: imageUrl, caption: nil)
    photo.isVideo = true
    photos.append(photo)
    return true
    }else{
    return false
    }
    }
    return photos
    }
    
    @objc func didSendItems() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.modalPresentationStyle = .custom
    imagePicker.transitioningDelegate = self
        
    let alertStyle = UIDevice.current.userInterfaceIdiom == .pad ? UIAlertController.Style.alert:UIAlertController.Style.actionSheet
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        
    let alertCamera = UIAlertAction(title: "Camera".localizable, style: .default) { action in
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
    imagePicker.sourceType = .camera
    imagePicker.showsCameraControls = true
    self.inputContainerView.TextView.resignFirstResponder()
    self.present(imagePicker, animated: true)
    } else {
    print("Camera not available.")
    }
    }
    let alertPhoto = UIAlertAction(title: "Photo".localizable, style: .default) { action in
    imagePicker.sourceType = .photoLibrary
    imagePicker.mediaTypes = [kUTTypeImage as String]
    imagePicker.allowsEditing = true
    self.inputContainerView.TextView.resignFirstResponder()
    self.present(imagePicker, animated: true)
    }
    let alertVideo = UIAlertAction(title: "Video".localizable , style: .default) { action in
    imagePicker.sourceType = .savedPhotosAlbum
    imagePicker.mediaTypes = [kUTTypeMovie as String]
    self.inputContainerView.TextView.resignFirstResponder()
    self.present(imagePicker, animated: true)
    }

    let imageCamera = UIImage(named: "camera")
    let imagePhoto = UIImage(named: "photo")
    let imageVideo = UIImage(named: "rectangle")
        
    alertCamera.setValue(imageCamera, forKey: "image");     alert.addAction(alertCamera)
    alertPhoto.setValue(imagePhoto, forKey: "image");       alert.addAction(alertPhoto)
    alertVideo.setValue(imageVideo, forKey: "image");       alert.addAction(alertVideo)
        
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.view.tintColor = LabelForeground
    present(alert, animated: true)
    }

    let transition = CircularTransition()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.startingPoint = CGPoint(x: view.frame.midX, y: view.frame.maxY)
        transition.transtitonMode = .present
        transition.circleColor = .white
        return transition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.startingPoint = CGPoint(x: view.frame.midX, y: view.frame.maxY)
        transition.transtitonMode = .dismiss
        transition.circleColor = .white
        return transition
    }
 
    func didSubmit(for Comment: String) {
    if self.inputContainerView.TextView.text.TextNull() == false {
    self.inputContainerView.Shake()
    }else{
    text = true
    let result = String(Comment.filter {!["\t", "\n"].contains($0)})
    let Properties = ["text":result] as [String : Any]
    SendMessageWithProperties(Properties: Properties as [String : AnyObject])
    }
    }
    
    var text = false
    func SendMessageWithProperties(Properties: [String:AnyObject]) {
        if Reachability.isConnectedToNetwork() {
            
        let db = Firestore.firestore()
        let date = Date().timeIntervalSince1970
        guard let uid = GetUserObject().uid else {return}
            
        var values:[String : Any] = ["date": date ,"OwnerID": uid ,"isIncoming": true]
        Properties.forEach({values[$0] = $1})

        db.collection("Messages").document(uid).getDocument { documentSnapshot, error in
        if documentSnapshot?.data() != nil {
        db.collection("Messages").document(uid).updateData(["Messages": FieldValue.arrayUnion([values])]) { error in
        if let Err = error {
        self.Error(Err.localizedDescription)
        return
        }

        self.NullData.removeFromSuperview()
            
        if self.text {
        self.inputContainerView.TextView.text = ""
        self.text = false
        }else{
        self.ActivityIndicator.stopAnimating()
        }

        }
        }else{
        db.collection("Messages").document(uid).setData(["Messages": values]) { error in
        if let Err = error {
        self.Error(Err.localizedDescription)
        return
        }

        db.collection("Messages").document(uid).updateData(["Messages": FieldValue.arrayUnion([values])]) { error in
        if let Err = error {
        self.Error(Err.localizedDescription)
        return
        }
        self.NullData.removeFromSuperview()
            
        if self.text {
        self.inputContainerView.TextView.text = ""
        self.text = false
        }else{
        self.ActivityIndicator.stopAnimating()
        }
            
        }
        }
        }
        }
        }else{
        self.Error("InternetNotAvailable".localizable)
        }
    }
    
    var NumberMedia = Int()
    func sendMessadewithImageUrl(imageUrl:String) {
    ActivityIndicator.startAnimating()
    let Properties:[String : Any] = ["imageUrl":imageUrl ,"NumberMedia": NumberMedia+1]
    SendMessageWithProperties(Properties: Properties as [String : AnyObject])
    }
    
    
    public func uploadToFirebaseStorageUsingImage(image: UIImage , completion:@escaping ((String) -> Void) ) {
    guard let phone = GetUserObject().phone else{return}
    ActivityIndicator.startAnimating()
    let imageName = NSUUID().uuidString + ".jpg"
    guard let data = image.jpegData(compressionQuality: 0.75) else {return}
    Storag(child: ["DataUser",phone,"Image",imageName], image: data) { (url) in
    completion(url)
    } Err: { (err) in
    self.Error(err)
    }
    }
    
    func handleVideoSelectedForUrl(url:NSURL) {
    guard let phone = GetUserObject().phone else{return}
    ActivityIndicator.startAnimating()
    let filename = NSUUID().uuidString + ".mov"

    let uploadTask = Storage.storage().reference().child("DataUser").child(phone).child("Video").child(filename)
    uploadTask.putFile(from: url as URL, metadata: nil) { (metadata, error) in
    if let error = error {
    self.Error(error.localizedDescription)
    return
    }
    uploadTask.downloadURL(completion: { (url, err) in
    if let err = err {
    self.Error(err.localizedDescription)
    return
    }else{
    if let videoUrl = url?.absoluteString {
    if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url!) {
    self.uploadToFirebaseStorageUsingImage(image: thumbnailImage, completion: { (imageUrl) in
    let Properties:[String : Any] = ["imageVideo":imageUrl,"VideoUrl":videoUrl,"NumberMedia": self.NumberMedia+1]
    self.SendMessageWithProperties(Properties: Properties as [String : AnyObject])
    })
    }
    }
    }
    })
    }
    }
    
    public func thumbnailImageForFileUrl(fileUrl:URL) -> UIImage? {
    let asset = AVAsset(url: fileUrl)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    do{
    let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
    return UIImage(cgImage: thumbnailCGImage)
    }catch let err {
    self.Error(err.localizedDescription)
    }
    return nil
    }
    
    
    func SetUpPopUp(text:String) {
    let PopUp = PopUpView()
    PopUp.text = text
    PopUp.font = ControlWidth(16)
    PopUp.OkeyButton.isHidden = true
    Present(ViewController: self, ToViewController: PopUp)
    }
    
    
    func Error(_ Err:String) {
    self.Alert.SetIndicator(Style: .error)
    ActivityIndicator.stopAnimating()
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
    self.SetUpPopUp(text: Err)
    }
    }
    
    
    lazy var NullData : ViewNullData = {
      let View = ViewNullData(frame: view.bounds)
      View.backgroundColor = .clear
      View.TryAgain.addTarget(self, action: #selector(ActionNullData), for: .touchUpInside)
      return View
    }()
    
    @objc func ActionNullData() {
        readTimestampAction()
    }
    
    let ActivityIndicator:UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .white)
    aiv.hidesWhenStopped = true
    aiv.isHidden = true
    aiv.color = LabelForeground
    return aiv
    }()
    
    lazy var Alert:AlertView = {
        let View = AlertView()
        View.alpha = 0
        View.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        return View
    }()
    
}


extension CustomerServiceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
    if let referenceURL = info[.phAsset] as? PHAsset {
//  let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
//  if let phAsset = referenceURL.firstObject {
    PHImageManager.default().requestAVAsset(forVideo: referenceURL, options: PHVideoRequestOptions(), resultHandler: { (asset, audioMix, info) -> Void in
    if let asset = asset as? AVURLAsset {
    let videoData = NSData(contentsOf: asset.url)
    let videoPath = NSTemporaryDirectory() + "tmpMovie.MOV"
    let videoURL = NSURL(fileURLWithPath: videoPath)
    let writeResult = videoData?.write(to: videoURL as URL, atomically: true)
    if writeResult != nil {
    self.handleVideoSelectedForUrl(url: videoURL)
    }else {
    print("failure")
    }
    }
    })
//    }
    }

        
    if let photo = info[.editedImage] as? UIImage {
    uploadToFirebaseStorageUsingImage(image: photo) { (imageUrl) in
    self.sendMessadewithImageUrl(imageUrl: imageUrl)
    }
    }

    picker.dismiss(animated: true)
    }
    
    
    private func firstDayOfMonth(date: Date) -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year,.month,.day], from: date)
        return calendar.date(from: components)!
    }

    struct GroupedSection<SectionItem : Hashable, RowItem> {

        var sectionItem : SectionItem
        var rows : [RowItem]

        static func group(rows : [RowItem], by criteria : (RowItem) -> SectionItem) -> [GroupedSection<SectionItem, RowItem>] {
            let groups = Dictionary(grouping: rows, by: criteria)
            return groups.map(GroupedSection.init(sectionItem:rows:))
        }
    }
}




  


  


