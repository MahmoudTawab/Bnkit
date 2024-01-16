//
//  AddProfIleImage.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/9/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class AddProfIleImage: UIView , AVCapturePhotoCaptureDelegate {
    
    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var cellId = "cellId"
    var images = [UIImage]()
    var index = IndexPath(item: 0, section: 0)

    override init(frame: CGRect) {
    super.init(frame:frame)
    backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6027932363)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        addSubview(DismissButton)
        addSubview(DoneButton)
        addSubview(CameraView)
        addSubview(CapturePhotoButton)
        addSubview(ChangeCamera)
        addSubview(FlashButton)
        addSubview(ImageView)
        addSubview(CancelButton)
        addSubview(SaveButton)

        DismissButton.frame = CGRect(x: ControlWidth(60), y: ControlY(30), width: ControlWidth(60), height: ControlWidth(60))
        
        CameraView.frame = CGRect(x: ControlX(25), y: ControlY(120.0), width: frame.width - ControlX(50), height: ControlHeight(320))
 
        DoneButton.frame = CGRect(x: frame.maxX - ControlWidth(120), y: DismissButton.frame.minY, width: DismissButton.frame.width, height: DismissButton.frame.height)
        
        DismissButton.layer.cornerRadius = ControlWidth(30)
        DoneButton.layer.cornerRadius = ControlWidth(30)
        
        CapturePhotoButton.frame = CGRect(x: CameraView.center.x - ControlHeight(30), y: CameraView.frame.maxY - ControlY(75), width: ControlWidth(60), height: ControlWidth(60))
        
        ChangeCamera.frame = CGRect(x: CameraView.frame.maxX - ControlX(45), y: CameraView.frame.minY + ControlY(16), width: ControlWidth(30), height: ControlWidth(30))
        
        FlashButton.frame = CGRect(x: ControlX(45), y: CameraView.frame.minY + ControlY(16), width: ControlWidth(28), height: ControlWidth(28))
        
        ImageView.frame = CGRect(x: CameraView.frame.minX, y: CameraView.frame.minY , width: CameraView.frame.width, height: CameraView.frame.height)
        
        CancelButton.frame = CGRect(x: ImageView.frame.maxX - ControlX(45), y: ImageView.frame.minY + ControlY(17), width: ControlWidth(25), height: ControlWidth(25))
        
        SaveButton.frame = CGRect(x: ImageView.frame.minX + ControlX(15), y: ImageView.frame.maxY - ControlY(47), width: ControlWidth(80), height: ControlWidth(36))
          
        addSubview(collectionView)
        collectionView.frame = CGRect(x: CameraView.frame.minX, y: ControlY(475.0), width: CameraView.frame.width, height: ControlHeight(100))
        
        addSubview(LibraryButton)
        LibraryButton.frame = CGRect(x: center.x - ControlWidth(90), y: ControlY(603.0), width: ControlWidth(180), height: ControlHeight(40))
        LibraryButton.layer.cornerRadius = LibraryButton.frame.height / 2
        
        self.reloadData()
        self.startCamera()
    }
    
    var ProfIle : ProfIleVC?
    var SignUp : SignUpController?
    
    lazy var DismissButton : UIButton = {
        let Button = UIButton(type: .system)
        let image = UIImage(named: "group269")?.withInset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.tintColor = .white
        Button.setBackgroundImage(image, for: .normal)
        return Button
    }()
    

    lazy var DoneButton : UIButton = {
        let Button = UIButton(type: .system)
        let image = UIImage(named: "group272")?.withInset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        Button.setBackgroundImage(image, for: .normal)
        Button.tintColor = .white
        Button.backgroundColor = #colorLiteral(red: 0.7962622643, green: 0.9145382047, blue: 0.8632406592, alpha: 1)
        return Button
    }()


    func startCamera() {
    captureSession = AVCaptureSession()
    captureSession.sessionPreset = .photo
    cameraOutput = AVCapturePhotoOutput()

    if let device = AVCaptureDevice.default(for: .video),
    let input = try? AVCaptureDeviceInput(device: device) {
    if (captureSession.canAddInput(input)) {
    captureSession.addInput(input)
    if (captureSession.canAddOutput(cameraOutput)) {
    captureSession.addOutput(cameraOutput)
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    previewLayer.cornerRadius = ControlHeight(30)
    previewLayer.frame = CameraView.bounds
    CameraView.layer.addSublayer(previewLayer)
    captureSession.startRunning()
    }
    } else {
    print("issue here : captureSesssion.canAddInput")
    }
    } else {
    print("some problem here")
    }
    }


    lazy var CameraView: UIView = {
        let View = UIView()
        View.backgroundColor = .black
        View.layer.masksToBounds = true
        View.layer.cornerRadius = ControlHeight(30)
        return View
    }()
    
    lazy var CapturePhotoButton : UIButton = {
        let Button = UIButton(type: .system)
        let image = UIImage(named: "Oval")?.withInset(UIEdgeInsets(top: ControlY(2), left: ControlY(2), bottom: ControlY(2), right: ControlY(2)))
        Button.setBackgroundImage(image, for: .normal)
        Button.addTarget(self, action: #selector(ActionCapturePhoto), for: .touchUpInside)
        return Button
    }()
    
    
    @objc func ActionCapturePhoto() {
    let settings = AVCapturePhotoSettings()
    guard let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first else{return}
    let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                                     kCVPixelBufferWidthKey as String: 160,
                                     kCVPixelBufferHeightKey as String: 160,
                                     ]
    settings.flashMode = flashMode
    settings.previewPhotoFormat = previewFormat
    self.cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    lazy var FlashButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.tintColor = .white
        Button.setImage(UIImage(named: "boltSlash"), for: .normal)
        Button.addTarget(self, action: #selector(ActionFlash), for: .touchUpInside)
        return Button
    }()
    
   var flashMode = AVCaptureDevice.FlashMode.off
   var Num = Int()
   @objc func ActionFlash() {
    switch flashMode {
    case .auto:
    Num = 1
    flashMode = .off
    FlashButton.tintColor = .white
    FlashButton.setImage(UIImage(named: "boltSlash"), for: .normal)
    break
    case .off:
    Num = 2
    flashMode = .on
    FlashButton.tintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    FlashButton.setImage(UIImage(named: "bolt"), for: .normal)
    break
    case .on:
    Num = 3
    flashMode = .auto
    FlashButton.tintColor = .white
    FlashButton.setImage(UIImage(named: "bolt"), for: .normal)
    break
    default: break
    }
    }
    

    lazy var ImageView:UIImageView = {
        let ImageView = UIImageView()
        ImageView.contentMode = .scaleAspectFill
        ImageView.layer.masksToBounds = true
        ImageView.alpha = 0
        ImageView.layer.cornerRadius = ControlHeight(30)
        return ImageView
    }()
    
    lazy var CancelButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.backgroundColor = .clear
        Button.tintColor = .white
        Button.alpha = 0
        Button.setImage(UIImage(named: "group269"), for: .normal)
        Button.addTarget(self, action: #selector(CancelAction), for: .touchUpInside)
        return Button
    }()
    
    @objc func CancelAction() {
    ImageView.alpha = 0
    ImageView.image = nil
    CancelButton.alpha = 0
    SaveButton.alpha = 0
    collectionView.reloadData()
    }
    

    lazy var SaveButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.backgroundColor = .clear
        Button.alpha = 0
        Button.setTitleColor(.white, for: .normal)
        Button.setTitle("Save".localizable, for: .normal)
        Button.addTarget(self, action: #selector(ActionSave), for: .touchUpInside)
        Button.titleLabel?.font = UIFont.systemFont(ofSize: ControlWidth(16))
        return Button
    }()
    
    @objc func ActionSave() {
        guard let image = ImageView.image else {return}
        let Library = PHPhotoLibrary.shared()
         Library.performChanges({
         PHAssetChangeRequest.creationRequestForAsset(from:image)
         }) { (success, err) in
         if let err = err {
         print("Failed to save image to photo library:",err)
         return
         }
        self.images.removeAll()
        self.fetchPhotos()
        DispatchQueue.main.async {
        let SaveLabel = UILabel()
        SaveLabel.text = "SavedSuccessfully".localizable
        SaveLabel.font = UIFont(name: "Campton-SemiBold" ,size: ControlWidth(28))
        SaveLabel.textAlignment = .center
        SaveLabel.clipsToBounds = true
        SaveLabel.layer.cornerRadius = ControlHeight(15)
        SaveLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        SaveLabel.numberOfLines = 0
        SaveLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        SaveLabel.frame = CGRect(x: self.center.x - ControlX(110), y: self.center.y + ControlY(300), width:  ControlWidth(220), height: ControlHeight(120))
        self.addSubview(SaveLabel)
        SaveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
        SaveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
        SaveLabel.frame = CGRect(x: self.center.x - ControlX(110), y: self.center.y - ControlY(60), width:  ControlWidth(220), height: ControlHeight(120))
        }) { (completed) in
        UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options:.curveEaseOut, animations: {
        SaveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        SaveLabel.alpha = 0
        }) { (completed) in
        SaveLabel.removeFromSuperview()
        }
        }
        }
        }
    }
    
    lazy var ChangeCamera : UIButton = {
        let Button = UIButton(type: .system)
        Button.backgroundColor = .clear
        Button.tintColor = .white
        Button.setImage(UIImage(named: "CameraRotate"), for: .normal)
        Button.addTarget(self, action: #selector(ActionChangeCamera), for: .touchUpInside)
        return Button
    }()

    @objc func ActionChangeCamera() {
    guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }
    captureSession.beginConfiguration()
    defer { captureSession.commitConfiguration() }

    var newDevice: AVCaptureDevice?
    if input.device.position == .back {
    flashMode = .off
    FlashButton.alpha = 0
    newDevice = getFrontCamera()
    } else {
    if Num == 2 {
    flashMode = .on
    }else if Num == 3 {
    flashMode = .auto
    }
    FlashButton.alpha = 1
    newDevice = getBackCamera()
    }

    var deviceInput: AVCaptureDeviceInput!
    do {
    deviceInput = try AVCaptureDeviceInput(device: newDevice!)
    } catch let error {
    print(error.localizedDescription)
    return
    }

    captureSession.removeInput(input)
    captureSession.addInput(deviceInput)
    }

    func getFrontCamera() -> AVCaptureDevice? {
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first
    }

    func getBackCamera() -> AVCaptureDevice? {
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let error = error {
    print(error.localizedDescription)
    }

    if let imageData = photo.fileDataRepresentation(), let dataImage = UIImage(data: imageData) {
        
//  if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
//  let dataProvider = CGDataProvider(data: dataImage as CFData)
//  let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
//  let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: .right)
        
    self.ImageView.image = dataImage
    self.ImageView.alpha = 1
    self.CancelButton.alpha = 1
    self.SaveButton.alpha = 1
    collectionView.reloadData()
    }
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.backgroundColor = .clear
        vc.dataSource = self
        vc.delegate = self
        vc.showsHorizontalScrollIndicator = false
        vc.register(PhotosCell.self, forCellWithReuseIdentifier: cellId)
        return vc
    }()
    
    lazy var LibraryButton : UIButton = {
        let Button = UIButton(type: .system)
        Button.setTitle("PHOTOLIBRARY".localizable, for: .normal)
        Button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        Button.backgroundColor = #colorLiteral(red: 0.9445008636, green: 0.6436805129, blue: 0.655623138, alpha: 1)
        Button.titleLabel?.textAlignment = .center
        Button.titleLabel?.font = UIFont(name: "Campton-SemiBold", size: ControlWidth(17))
        return Button
    }()
    
   }


extension AddProfIleImage : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    fileprivate func reloadData() {
    DispatchQueue.main.async(execute: { () -> Void in
    let photos = PHPhotoLibrary.authorizationStatus()
    if photos == .notDetermined {
    PHPhotoLibrary.requestAuthorization({status in
    if status == .authorized{
    self.fetchPhotos()
    } else {
    let alert = UIAlertController(title: "Photos Access Denied", message: "App needs access to photos library.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    })
    } else if photos == .authorized {
    self.fetchPhotos()
    }
    })
    }
    

    fileprivate func assetFetckOptions() -> PHFetchOptions {
    let FetchOptions = PHFetchOptions()
    let sortDescriptor  = NSSortDescriptor(key: "creationDate", ascending: false)
    FetchOptions.sortDescriptors = [sortDescriptor]
    return FetchOptions
    }
    
    
    fileprivate func fetchPhotos() {
    let allPhotos =  PHAsset.fetchAssets(with: .image, options: assetFetckOptions())
    DispatchQueue.global(qos: .userInitiated).async {
    allPhotos.enumerateObjects { (asset, count, stop) in
    let iamgeManager = PHImageManager.default()
    let iamgeSize = CGSize(width: 600, height: 600)
    let Options = PHImageRequestOptions()
    Options.isSynchronous = true
    iamgeManager.requestImage(for: asset, targetSize: iamgeSize, contentMode: .aspectFit, options: Options) { (image, info) in
    if let image = image {
    self.images.append(image)
    if count == allPhotos.count - 1 {
    DispatchQueue.main.async {
    self.collectionView.reloadData()
    }
    }
    }
    }
    }
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotosCell
        cell.PhotosImageView.image = images[indexPath.item]
        cell.clipsToBounds = true
        cell.layer.cornerRadius = ControlHeight(12)
        
        if self.ImageView.alpha == 0 {
        if indexPath.item == self.index.item {
        ImageView.image = images[index.item]
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options:[], animations: {
        cell.IsSelected.isHidden = false
        cell.PhotosImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
        }else{
        cell.IsSelected.isHidden = true
        cell.PhotosImageView.transform = .identity
        }
        }else{
        cell.IsSelected.isHidden = true
        cell.PhotosImageView.transform = .identity
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    index.item = indexPath.item
    collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ControlWidth(101), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ControlWidth(8)
    }
    
}

class PhotosCell: UICollectionViewCell {
    
    lazy var PhotosImageView:UIImageView = {
            let ImageView = UIImageView()
            ImageView.contentMode = .scaleAspectFill
            ImageView.clipsToBounds = true
            ImageView.backgroundColor = NotifNew
            return ImageView
    }()
        

    lazy var IsSelected:UIImageView = {
            let ImageView = UIImageView()
            ImageView.image = UIImage(named: "selectedImageGallery")
            ImageView.contentMode = .scaleAspectFill
            ImageView.isHidden = true
            return ImageView
    }()

        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            addSubview(PhotosImageView)
            PhotosImageView.frame = self.bounds
            
            addSubview(IsSelected)
            IsSelected.frame = self.bounds
        
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
