//
//  CircularTransition.swift
//  Picker
//
//  Created by Mahmoud Abd El Tawab on 4/1/19.
//  Copyright © 2019 Mahmoud Tawab. All rights reserved.
//

import UIKit

class CircularTransition: NSObject {

    var  circle = UIView()
    var startingPoint = CGPoint.zero {
    didSet{
    circle.center = startingPoint
    }
    }
    var circleColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var duration = 0.7
    enum CircularTransitioMode:Int {
        case present, dismiss, pop
    }
    var transtitonMode:CircularTransitioMode = .present
    
}

extension CircularTransition:UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerview = transitionContext.containerView
        
        if transtitonMode == .present {
            if let presentedview = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedview.center
                let viewSize = presentedview.frame.size
                circle = UIView()
                circle.frame = frmeForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerview.addSubview(circle)
                presentedview.center = startingPoint
                presentedview.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedview.alpha = 0
                containerview.addSubview(presentedview)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    presentedview.transform = CGAffineTransform.identity
                    presentedview.alpha = 1
                    presentedview.center = viewCenter
                }, completion: { (success:Bool) in
                    transitionContext.completeTransition(success)
                })
            }
        }else{
            let transitionModeKey = (transtitonMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            if let returngView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returngView.center
                let viewSize = returngView.frame.size
                circle.frame = frmeForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returngView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returngView.center = self.startingPoint
                    returngView.alpha = 0
                    
                    if self.transtitonMode == .pop {
                        containerview.insertSubview(returngView, belowSubview: returngView)
                        containerview.insertSubview(self.circle, belowSubview: returngView)
                    }
                }, completion: { (success:Bool) in
                    returngView.center = viewCenter
                    returngView.removeFromSuperview()
                    self.circle.removeFromSuperview()
                    transitionContext.completeTransition(success)
            })
            }
            
        }
    }
    
    func frmeForCircle(withViewCenter viewCenter:CGPoint , size viewSize:CGSize , startPoint:CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x , viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y , viewSize.height - startPoint.y)
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
}
