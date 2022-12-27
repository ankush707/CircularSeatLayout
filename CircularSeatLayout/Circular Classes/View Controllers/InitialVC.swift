//
//  InitialVC.swift
//  SeatingQHO
//
//  Created by Ankush on 21/10/22.
//

import Foundation
import UIKit

class InitialVC: UIViewController, DataProtocol {
    func passSeatsData(seatsArr: [[String : String?]]) {
        
        if seatsArr.count > 0 {
            
            var tempStr = ""
            for obj in seatsArr {
                
                
                if let column = obj[ConstantKeys.COLUMN] {
                    if let row = obj[ConstantKeys.ROW] {
                            let strTemp = (column ?? "") + "-" + (row ?? "") + ", "
                            
                            tempStr += strTemp
                        }
                    }
            }
            tempStr = String(tempStr.dropLast())
            self.seatLbl.text = String(tempStr.dropLast())
        }
    }
    
    
    @IBOutlet weak var numberOfSeats: UITextField!
    @IBOutlet weak var seatLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
    }
    
    @IBAction func checkSeatLayoutAction(_ sender: Any) {
        
        let totalStr = numberOfSeats.text ?? ""
        
        if !totalStr.isEmpty {
            if totalStr.isNumber {
                if let seatCount = Int(totalStr) {
                    self.openSeatLayout(seatsCount: seatCount)
                } else {
                    self.showToast(message: ConstantKeys.numGreaterThenZero, colorCustom: .green)
                }
            }
            
        } else {
            self.showToast(message: ConstantKeys.pleaseEnterSeats, colorCustom: .green)
        }
    }
    
    func openSeatLayout(seatsCount: Int) {

        //
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : CircularSeatLayoutVC = storyboard.instantiateViewController(withIdentifier: "CircularSeatLayoutVC") as! CircularSeatLayoutVC
            vc.delegate = self
            vc.totalSeatsCount = seatsCount
            vc.modalPresentationStyle = .overFullScreen
            vc.isModalInPresentation = true
            self.present(vc, animated: true, completion: nil)
            
        }
    }
}


extension InitialVC {
    
    func addDoneButtonOnKeyboard()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent

        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))

        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()

        self.numberOfSeats.inputAccessoryView = doneToolbar

    }
    
    @objc func doneButtonAction()
    {
        self.numberOfSeats.resignFirstResponder()
    }
}
