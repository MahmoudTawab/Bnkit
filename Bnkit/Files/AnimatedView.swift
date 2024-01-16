//
//  AnimatedView.swift
//  AlertView (iOS)
//
//  Created by Emoji Technology on 21/11/2021.
//

import UIKit

// MARK: Animatable Views
class CancelAnimatedView: UIView {
    
    var circleLayer = CAShapeLayer()
    var crossPathLayer = CAShapeLayer()
    override required init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        var t = CATransform3DIdentity;
        t.m34 = 1.0 / -500.0;
        t = CATransform3DRotate(t, CGFloat(90.0 * .pi / 180.0), 1, 0, 0);
        circleLayer.transform = t
        crossPathLayer.opacity = 0.0
    }
    
    override func layoutSubviews() {
        setupLayers()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var outlineCircle: CGPath  {
        let path = UIBezierPath()
        let startAngle: CGFloat = CGFloat((0) / 180.0 * .pi)  //0
        let endAngle: CGFloat = CGFloat((360) / 180.0 * .pi)   //360
        path.addArc(withCenter: CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.width/2.0), radius: self.frame.size.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        return path.cgPath
    }
    
    fileprivate var crossPath: CGPath  {
        let path = UIBezierPath()
        let factor:CGFloat = self.frame.size.width / 5.0
        path.move(to: CGPoint(x: self.frame.size.height/2.0-factor,y: self.frame.size.height/2.0-factor))
        path.addLine(to: CGPoint(x: self.frame.size.height/2.0+factor,y: self.frame.size.height/2.0+factor))
        path.move(to: CGPoint(x: self.frame.size.height/2.0+factor,y: self.frame.size.height/2.0-factor))
        path.addLine(to: CGPoint(x: self.frame.size.height/2.0-factor,y: self.frame.size.height/2.0+factor))
        
        return path.cgPath
    }
    
    fileprivate func setupLayers() {
        circleLayer.path = outlineCircle
        circleLayer.fillColor = UIColor.clear.cgColor;
        circleLayer.strokeColor = BackgroundColor.cgColor;
        circleLayer.lineCap = CAShapeLayerLineCap.round
        circleLayer.lineWidth = ControlWidth(4);
        circleLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        circleLayer.position = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        self.layer.addSublayer(circleLayer)
        
        crossPathLayer.path = crossPath
        crossPathLayer.fillColor = UIColor.clear.cgColor;
        crossPathLayer.strokeColor = BackgroundColor.cgColor;
        crossPathLayer.lineCap = CAShapeLayerLineCap.round
        crossPathLayer.lineWidth = ControlWidth(4);
        crossPathLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        crossPathLayer.position = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height/2.0)
        self.layer.addSublayer(crossPathLayer)
        
    }
    
    func animate() {
        var t = CATransform3DIdentity;
        t.m34 = 1.0 / -500.0;
        t = CATransform3DRotate(t, CGFloat(90.0 * .pi / 180.0), 1, 0, 0);
        
        var t2 = CATransform3DIdentity;
        t2.m34 = 1.0 / -500.0;
        t2 = CATransform3DRotate(t2, -.pi, 1, 0, 0);
        
        let animation = CABasicAnimation(keyPath: "transform")
        let time = 0.3
        animation.duration = time;
        animation.fromValue = NSValue(caTransform3D: t)
        animation.toValue = NSValue(caTransform3D:t2)
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.circleLayer.add(animation, forKey: "transform")
        
        
        var scale = CATransform3DIdentity;
        scale = CATransform3DScale(scale, 0.3, 0.3, 0)
        
        let crossAnimation = CABasicAnimation(keyPath: "transform")
        crossAnimation.duration = 0.3;
        crossAnimation.beginTime = CACurrentMediaTime() + time
        crossAnimation.fromValue = NSValue(caTransform3D: scale)
        crossAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.8, 0.7, 2.0)
        crossAnimation.toValue = NSValue(caTransform3D:CATransform3DIdentity)
        self.crossPathLayer.add(crossAnimation, forKey: "scale")
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.duration = 0.3;
        fadeInAnimation.beginTime = CACurrentMediaTime() + time
        fadeInAnimation.fromValue = 0.3
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.isRemovedOnCompletion = false
        fadeInAnimation.fillMode = CAMediaTimingFillMode.forwards
        self.crossPathLayer.add(fadeInAnimation, forKey: "opacity")
    }
}


class SuccessAnimatedView: UIView {
    
    let successCircle = CAShapeLayer()
    let checkmark = CAShapeLayer()
    override func draw(_ rect: CGRect) {
    super.draw(rect)

        let backgroundViewBounds = self.bounds
        let backgroundLayer = self.layer

        let checkmarkSideLength = ControlWidth(60)
        let checkmarkPathCenter = CGPoint(x: (backgroundViewBounds.width - checkmarkSideLength) / 2,
                                          y: (backgroundViewBounds.height - checkmarkSideLength) / 2)

        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: checkmarkSideLength * 0.28, y: checkmarkSideLength * 0.53))
        checkmarkPath.addLine(to: CGPoint(x: checkmarkSideLength * 0.42, y: checkmarkSideLength * 0.66))
        checkmarkPath.addLine(to: CGPoint(x: checkmarkSideLength * 0.72, y: checkmarkSideLength * 0.36))
        checkmarkPath.apply(CGAffineTransform.init(translationX: checkmarkPathCenter.x, y: checkmarkPathCenter.y))
        checkmarkPath.lineCapStyle = .square

        checkmark.path = checkmarkPath.cgPath
        checkmark.fillColor = nil
        checkmark.strokeColor = BackgroundColor.cgColor
        checkmark.lineWidth = ControlWidth(4)
        checkmark.lineCap = CAShapeLayerLineCap.round
        backgroundLayer.addSublayer(checkmark)

        let successCircleCenter = CGPoint(x: backgroundViewBounds.midX, y: backgroundViewBounds.midY)
        successCircle.path = UIBezierPath(arcCenter: successCircleCenter,
                                          radius: ControlWidth(50.0),
                                          startAngle: -CGFloat.pi / 2 ,
                                          endAngle: CGFloat.pi / 180 * 270,
                                          clockwise: true).cgPath
        successCircle.fillColor = nil
        successCircle.strokeColor = BackgroundColor.cgColor
        successCircle.lineCap = CAShapeLayerLineCap.round
        successCircle.lineWidth = ControlWidth(4)
        backgroundLayer.addSublayer(successCircle)
        
    }
    
    
    func animate() {
    let animationCheckmark = CABasicAnimation(keyPath: "strokeEnd")
    animationCheckmark.isRemovedOnCompletion = true
    animationCheckmark.fromValue = 0
    animationCheckmark.toValue = 1
    animationCheckmark.fillMode = CAMediaTimingFillMode.both
    animationCheckmark.duration = 0.4
    animationCheckmark.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    checkmark.add(animationCheckmark, forKey: nil)

    let animationCircle = CABasicAnimation(keyPath: "strokeEnd")
    animationCircle.isRemovedOnCompletion = true
    animationCircle.fromValue = 0
    animationCircle.toValue = 1
    animationCircle.fillMode = CAMediaTimingFillMode.both
    animationCircle.duration = 0.7
    animationCircle.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    successCircle.add(animationCircle, forKey: nil)
    }
}


public final class InstagramActivityIndicator: UIView {
    /// Specifies the segment animation duration.
    public var animationDuration: Double = 1
    
    /// Specifies the indicator rotation animatino duration.
    public var rotationDuration: Double = 10
    
    /// Specifies the number of segments in the indicator.
    @IBInspectable
    public var numSegments: Int = 12 {
        didSet {
            updateSegments()
        }
    }
    
    /// Specifies the stroke color of the indicator segments.
    @IBInspectable
    public var strokeColor : UIColor = BackgroundColor {
        didSet {
            segmentLayer?.strokeColor = strokeColor.cgColor
        }
    }
    
    /// Specifies the line width of the indicator segments.
    @IBInspectable
    public var lineWidth : CGFloat = ControlWidth(3) {
        didSet {
            segmentLayer?.lineWidth = lineWidth
            updateSegments()
        }
    }
    
    /// A Boolean value that controls whether the receiver is hidden when the animation is stopped.
    public var hidesWhenStopped: Bool = true
    
    /// A Boolean value that returns whether the indicator is animating or not.
    public private(set) var isAnimating = false
    
    /// the layer replicating the segments.
    private weak var replicatorLayer: CAReplicatorLayer!
    
    /// the visual layer that gets replicated around the indicator.
    private weak var segmentLayer: CAShapeLayer!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // create and add the replicator layer
        let replicatorLayer = CAReplicatorLayer()
        
        layer.addSublayer(replicatorLayer)
        
        // configure the shape layer that gets replicated
        let dot = CAShapeLayer()
        dot.lineCap = CAShapeLayerLineCap.round
        dot.strokeColor = strokeColor.cgColor
        dot.lineWidth = lineWidth
        dot.fillColor = nil
        
        replicatorLayer.addSublayer(dot)
        
        // set the weak variables after being added to the layer
        self.replicatorLayer = replicatorLayer
        self.segmentLayer = dot
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // resize the replicator layer.
        let maxSize = max(0,min(bounds.width, bounds.height))
        replicatorLayer.bounds = CGRect(x: 0, y: 0, width: maxSize, height: maxSize)
        replicatorLayer.position = CGPoint(x: bounds.width/2, y:bounds.height/2)
        
        updateSegments()
    }
    
    /// Updates the visuals of the indicator, specifically the segment characteristics.
    private func updateSegments() {
        guard numSegments > 0, let segmentLayer = segmentLayer else { return }
        
        let angle = 2*CGFloat.pi / CGFloat(numSegments)
        replicatorLayer.instanceCount = numSegments
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        replicatorLayer.instanceDelay = 1.5*animationDuration/Double(numSegments)
        
        let maxRadius = max(0,min(replicatorLayer.bounds.width, replicatorLayer.bounds.height))/2
        let radius: CGFloat = maxRadius - lineWidth/2
        
        segmentLayer.bounds = CGRect(x:0, y:0, width: 2*maxRadius, height: 2*maxRadius)
        segmentLayer.position = CGPoint(x: replicatorLayer.bounds.width/2, y: replicatorLayer.bounds.height/2)
        
        // set the path of the replicated segment layer.
        let path = UIBezierPath(arcCenter: CGPoint(x: maxRadius, y: maxRadius), radius: radius, startAngle: -angle/2 - CGFloat.pi/2, endAngle: angle/2 - CGFloat.pi/2, clockwise: true)
        
        segmentLayer.path = path.cgPath
    }
    
    /// Starts the animation of the indicator.
    public func startAnimating() {
        self.isHidden = false
        isAnimating = true
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.byValue = CGFloat.pi*2
        rotate.duration = rotationDuration
        rotate.repeatCount = Float.infinity
        
        // add animations to segment
        // multiplying duration changes the time of empty or hidden segments
        let shrinkStart = CABasicAnimation(keyPath: "strokeStart")
        shrinkStart.fromValue = 0.0
        shrinkStart.toValue = 0.5
        shrinkStart.duration = animationDuration // * 1.5
        shrinkStart.autoreverses = true
        shrinkStart.repeatCount = Float.infinity
        shrinkStart.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let shrinkEnd = CABasicAnimation(keyPath: "strokeEnd")
        shrinkEnd.fromValue = 1.0
        shrinkEnd.toValue = 0.5
        shrinkEnd.duration = animationDuration // * 1.5
        shrinkEnd.autoreverses = true
        shrinkEnd.repeatCount = Float.infinity
        shrinkEnd.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let fade = CABasicAnimation(keyPath: "lineWidth")
        fade.fromValue = lineWidth
        fade.toValue = 0.0
        fade.duration = animationDuration // * 1.5
        fade.autoreverses = true
        fade.repeatCount = Float.infinity
        fade.timingFunction = CAMediaTimingFunction(controlPoints: 0.55, 0.0, 0.45, 1.0)
        
        replicatorLayer.add(rotate, forKey: "rotate")
        segmentLayer.add(shrinkStart, forKey: "start")
        segmentLayer.add(shrinkEnd, forKey: "end")
        segmentLayer.add(fade, forKey: "fade")
    }
    
    /// Stops the animation of the indicator.
    public func stopAnimating() {
        isAnimating = false
        
        replicatorLayer.removeAnimation(forKey: "rotate")
        segmentLayer.removeAnimation(forKey: "start")
        segmentLayer.removeAnimation(forKey: "end")
        segmentLayer.removeAnimation(forKey: "fade")
        
        if hidesWhenStopped {
            self.isHidden = true
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 180, height: 180)
    }
}

