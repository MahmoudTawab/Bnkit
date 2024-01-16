//
//  Color.swift
//  Bnkit
//
//  Created by Mahmoud Tawab on 9/29/20.
//  Copyright © 2020 Mahmoud Tawab. All rights reserved.
//

  import UIKit

  extension UIColor {
  public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
  if #available(iOS 13.0, *) {
  return UIColor {
  switch $0.userInterfaceStyle {
  case .dark:
  return dark
  default:
  return light
  }
  }
  }else if #available(iOS 12.0, *) {
  if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
  return dark
  } else {
  return light
  }
  } else {
  return light
  }
  }
  }

  struct MyColors {
    static let x6A6A6A = #colorLiteral(red: 0.4391748011, green: 0.4392418265, blue: 0.4391601086, alpha: 1)
    static let x6A6A7A = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    static let x202024 = #colorLiteral(red: 0.1352293193, green: 0.2222653031, blue: 0.4640625715, alpha: 1)
    static let xFEFEFE = #colorLiteral(red: 0.9999127984, green: 1, blue: 0.9998814464, alpha: 1)
    static let x202010 = #colorLiteral(red: 0.1842939854, green: 0.1843264103, blue: 0.1842868626, alpha: 1)
    static let x202020 = #colorLiteral(red: 0.1254901960784314, green: 0.1254901960784314, blue: 0.1254901960784314, alpha: 1)
    static let x202000 = #colorLiteral(red: 0.0570415564, green: 0.05760632428, blue: 0.05760632428, alpha: 1)
    static let x202040 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let x205040 = #colorLiteral(red: 0.4233468771, green: 0.519071877, blue: 0.7063246369, alpha: 1)
    static let x405040 = #colorLiteral(red: 0.7453938127, green: 0.8536149859, blue: 0.9157326818, alpha: 1)
    static let x505040 = #colorLiteral(red: 0.6326062679, green: 0.8368911147, blue: 0.7435064912, alpha: 1)
    static let x6A646A = #colorLiteral(red: 0.9254091382, green: 0.9255421162, blue: 0.9253799319, alpha: 1)
  }

  var LabelForeground: UIColor {
  return UIColor.dynamicColor(light: MyColors.x6A6A6A, dark: MyColors.xFEFEFE)
  }

  var AboutTitle: UIColor {
  return UIColor.dynamicColor(light: MyColors.x202024, dark: MyColors.xFEFEFE)
  }

  var LogInColors: UIColor {
  return UIColor.dynamicColor(light: MyColors.x205040, dark: MyColors.xFEFEFE)
  }

  var ProfIleColors: UIColor {
  return UIColor.dynamicColor(light: MyColors.x6A6A6A, dark: MyColors.x205040)
  }

  var AboutColors: UIColor {
  return UIColor.dynamicColor(light: MyColors.x202024, dark: MyColors.x405040)
  }

  var PersonalDetail: UIColor {
  return UIColor.dynamicColor(light: MyColors.x405040, dark: MyColors.xFEFEFE)
  }

  var PersonalDetailText: UIColor {
  return UIColor.dynamicColor(light: MyColors.x505040, dark: MyColors.xFEFEFE)
  }

  var tabBarForeground: UIColor {
  return UIColor.dynamicColor(light: MyColors.xFEFEFE, dark: MyColors.x202000)
  }

  var TextViewForeground: UIColor {
  return UIColor.dynamicColor(light: MyColors.xFEFEFE, dark: MyColors.x202040)
  }

  var BackgroundColor: UIColor {
  return UIColor.dynamicColor(light: MyColors.xFEFEFE, dark: MyColors.x202020)
  }

  var HistoryTxet: UIColor {
  return UIColor.dynamicColor(light: MyColors.x202020, dark: MyColors.xFEFEFE)
  }

  var HistoryButton: UIColor {
  return UIColor.dynamicColor(light: MyColors.x6A646A, dark: MyColors.x202010)
  }

  var NotifReadable: UIColor {
  return UIColor.dynamicColor(light: MyColors.x6A6A7A, dark: MyColors.x6A6A6A)
  }

  var NotifNew: UIColor {
  return UIColor.dynamicColor(light: MyColors.x6A6A6A, dark: MyColors.x6A6A7A)
  }

  var CalculatorDetaIls: UIColor {
  return UIColor.dynamicColor(light: MyColors.x6A6A6A, dark: MyColors.x6A646A)
  }
