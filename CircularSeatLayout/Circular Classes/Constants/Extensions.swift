//
//  Extensions.swift
//
//  CircularSeatLayout
//
//  Created by Ankush on 21/10/22.
//

import Foundation
import UIKit

//MARK: - Extension to check if string is number
extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}

extension UIViewController {

    func showToast(message : String, colorCustom: UIColor) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 175 , y: self.view.frame.size.height-140, width: 350, height: 46))
    toastLabel.backgroundColor = colorCustom
    toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: LayoutFonts.fontNameStr, size: 14)
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}
    
}
