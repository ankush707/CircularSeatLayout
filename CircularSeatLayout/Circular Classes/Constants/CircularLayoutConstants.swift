//
//  LayoutConstants.swift
//
//  CircularSeatLayout
//
//  Created by Ankush on 21/10/22.
//

import Foundation
import UIKit

//MARK: - Constants
class LayoutConstants: NSObject {
    
    //View Sizes
    
    static let stageWidth = 220.0
    static let centerStageHeight = 100.0
    static let doneBtnWidth = 100.0
    static let doneBtnHeight = 56.0
    
    //Seat Layout Constants
    static let spaceInCircles = 12
    static let radiusOfCircle = 120
    static let seatButtonSize: CGFloat = 15
    
    //Scroll View Zoom Constants
    static let maximumZoomScale: CGFloat = 4
    static let doubleTapZoomScale: CGFloat = 2
    static let minimumZoomScale: CGFloat = 0.4
    
    // Screen Size
    static let screenSize: CGRect = UIScreen.main.bounds
}

class LayoutImages : NSObject {
    //Images Strings
    static let closeStr = "close"
    static let stageStr = "festival"
}

class LayoutStrings : NSObject {
    //Procced Button String
    static let proccedStr = "Done"
}

class LayoutFonts : NSObject {
    //SEATS LAYOUT FONT AND COLORS
    static let fontNameStr = "HelveticaNeue-Bold"
}

class LayoutColors : NSObject {
    
    static let mainViewColor = UIColor.white
    static let stageViewColor = UIColor(red: 233/255, green: 109/255, blue: 88/255, alpha: 1)

    static let seatEmptyTextColor = UIColor.clear
    static let seatEmptyBackgroundColor = UIColor.clear
    static let seatEmptyBorderColor = UIColor.clear.cgColor
    
    static let seatUnselectedTextColor = UIColor.black
    static let seatUnselectedBackgroundColor = UIColor.clear
    static let seatUnselectedBorderColor = UIColor.black.cgColor
    
    static let seatSelectedTextColor = UIColor.black
    static let seatSelectedBackgroundColor = UIColor.systemPink
    static let seatSelectedBorderColor = UIColor.black.cgColor
    
    static let seatRowTitleTextColor = UIColor.red
    static let seatRowTitleBackgroundColor = UIColor.clear
    static let seatRowTitleBorderColor = UIColor.clear.cgColor
    
    static let seatUnavailableColor = UIColor.lightGray
}

//Seat constants for button
class ConstantKeys {
    static let ROW = "ROW"
    static let COLUMN = "COLUMN"
    static let seatTitle = "seatTitle"
    static let seatBlocked = "seatBlocked"
    
    //Messages
    static let numGreaterThenZero = "Number of seats should be greater then zero"
    static let pleaseEnterSeats = "Please enter number of seats"
    static let pleaseSelectMinimum  = "Please select minimum"
    static let pleaseSelectSeats = "Please select seats"
}

