//
//  CustomClasses.swift
//
//  CircularSeatLayout
//
//  Created by Ankush on 21/10/22.
//

import Foundation
import UIKit

//MARK: - Custom Button Class

open class CustomSeatButton : UIButton {
    
    var rowIndex : String!
    var columnIndex : String!
    
}

//MARK: - ShapeView Class

class ShapeView: UIView {

    override class var layerClass: Swift.AnyClass { return CAShapeLayer.self }

    lazy var shapeLayer: CAShapeLayer = { self.layer as! CAShapeLayer }()

}
