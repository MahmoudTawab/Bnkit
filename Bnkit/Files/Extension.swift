//
//  Extension.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 2/22/21.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import AVKit
import Foundation

extension TimeInterval {
func Difference(from interval : TimeInterval) -> String {
let calendar = NSCalendar.current
let date = Date(timeIntervalSince1970: interval)
if calendar.isDateInYesterday(date) { return "Yesterday" }
else if calendar.isDateInToday(date) { return "Today" }
else {
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "d MMMM,yyyy"
return dateFormatter.string(from: date)
}
}
}
   
extension String {
  var localizable:String {
    return NSLocalizedString(self, comment: "")
  }
    
  func TextNull() -> Bool {
  if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0 {
  return true
  }
  return false
  }
    
  func NumAR() -> String{
    var sum = ""
    let letters = self.map { String($0) }
    for letter in letters {
    if (Int(letter) != nil) {
    let persianNumber = ["۰","۱","۲","۳","٤","۵","٦","۷","۸","۹"]
    sum = sum+persianNumber[Int("\(letter)")!]
    } else {
    sum = sum+letter
    }
    }
    return sum
 }
    
  func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
  let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
  let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
  return ceil(boundingBox.height)
  }
    
    func SizeOf_String( font: UIFont) -> CGSize {
    let fontAttribute = [NSAttributedString.Key.font: font]
    let size = self.size(withAttributes: fontAttribute)  // for Single Line
    return size;
    }
    
    var isValidCivilID: Bool {
        do {
        let regex = try NSRegularExpression(pattern: "(2|3)[0-9][0-9][0-1][0-9][0-3][0-9](0|1|2|3|8)[0-9]\\d\\d\\d\\d\\d", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
        return false
        }
    }
}

extension UILabel {
    func decideTextDirection() {
    let tagScheme = [NSLinguisticTagScheme.language]
    let tagger    = NSLinguisticTagger(tagSchemes: tagScheme, options: 0)
    tagger.string = self.text
    let lang      = tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language,
                                          tokenRange: nil, sentenceRange: nil)

    if lang?.rawValue.range(of:"ar") != nil {
    self.textAlignment = NSTextAlignment.right
    } else {
    self.textAlignment = NSTextAlignment.left
    }
    }
}

extension UITableView {
    func animateTable() {
    let cells = visibleCells
    let tableHeight: CGFloat = bounds.size.height
    for i in cells {
    let cell: UITableViewCell = i as UITableViewCell
    cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
    }
    var index = 0
    for a in cells {
    let cell: UITableViewCell = a as UITableViewCell
    UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
    cell.transform = CGAffineTransform(translationX: 0, y: 0);
    }, completion: nil)
    index += 1
    }
    }
    
    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
    if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
    if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    closure()
    }
    }
    }
    }

}

    public func Formatter(date:String , Format :String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = Format
    dateFormatterPrint.locale = "lang".localizable == "en" ? Locale(identifier: "en") : Locale(identifier: "ar")
    let datee = dateFormatterGet.date(from: date) ?? Date()
    return dateFormatterPrint.string(from: datee)
    }


extension UIImage {
    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
                            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)

        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)

        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
    }
    
    func imageWithImage(scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
}

extension UIView {
      
      func startShimmeringEffect(animationSpeed: Float = 1.4,repeatCount: Float = 1000) {
        
        let lightColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1).cgColor
        let blackColor = UIColor.black.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blackColor, lightColor, blackColor]
        gradientLayer.frame = CGRect(x: -self.bounds.size.width, y: -self.bounds.size.height, width: 3 * self.bounds.size.width, height: 3 * self.bounds.size.height)
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations =  [0.35, 0.50, 0.65] //[0.4, 0.6]
        self.layer.mask = gradientLayer
        
        // Add animation over gradient Layer  ->4
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = CFTimeInterval(animationSpeed)
        animation.repeatCount = repeatCount
        CATransaction.setCompletionBlock { [weak self] in
          guard let strongSelf = self else { return }
          strongSelf.layer.mask = nil
        }
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        CATransaction.commit()
      }
      
      func stopShimmeringEffect() {
        self.layer.mask = nil
      }
    
    func Shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
                    
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)

        shake.fromValue = fromValue
        shake.toValue = toValue
                
        layer.add(shake, forKey: "position")
    }
}



extension UIScrollView {
    func updateContentViewSize(_ spasing:CGFloat) {
        DispatchQueue.main.async {
        var newHeight: CGFloat = 0
            for view in self.subviews {
            let ref = view.frame.origin.y + view.frame.height
            if ref > newHeight {
                newHeight = ref
            }
        }
        let oldSize = self.contentSize
        let newSize = CGSize(width: oldSize.width, height: newHeight + spasing)
        self.contentSize = newSize
        }
    }
}
