//
//  screenType.swift
//  
//
//  Created by Mahmoud Abd El Tawab on 7/27/19.
//

import UIKit
//
//func ControlWidth(_ ControlW:CGFloat) -> CGFloat {
//let width = 375.0
//let widthRat:CGFloat = UIScreen.main.bounds.width / CGFloat(width)
//let W = ControlW * widthRat
//return W
//}

func ControlWidth(_ ControlW:CGFloat) -> CGFloat {
let Screen = UIDevice.current.userInterfaceIdiom != .phone ? UIScreen.main.bounds.height:UIScreen.main.bounds.width
let ControlH = UIDevice.current.userInterfaceIdiom != .phone ? CGFloat(667.0):CGFloat(375.0)
return ControlW * Screen / ControlH
}

func ControlHeight(_ ControlH:CGFloat) -> CGFloat {
let height = 667.0
let heightRat:CGFloat = UIScreen.main.bounds.height/CGFloat(height)
let H = ControlH * heightRat
return H
}

func ControlX(_ ControlX:CGFloat) -> CGFloat {
let width = 375.0
let widthRat:CGFloat = UIScreen.main.bounds.maxX / CGFloat(width)
let X = ControlX * widthRat
return X
}

func ControlY(_ ControlY:CGFloat) -> CGFloat {
let height = 667.0
let heightRat:CGFloat = UIScreen.main.bounds.maxY / CGFloat(height)
let Y = ControlY * heightRat
return Y
}

