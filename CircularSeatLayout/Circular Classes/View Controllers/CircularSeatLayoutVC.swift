//
//  CircularSeatLayoutVC.swift
//
//  CircularSeatLayout
//
//  Created by Ankush on 21/10/22.
//

import Foundation
import UIKit

protocol DataProtocol {
    
    func passSeatsData(seatsArr: [[String:String?]])
}

class CircularSeatLayoutVC : UIViewController,UIScrollViewDelegate {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    var delegate: DataProtocol?
    private var stageVw : UIImageView = UIImageView()
    private var layoutMainVw: UIView = UIView()
    
    //Arc angle
    private var arc = CGFloat(4 * Double.pi / 4)
    
    //Seat selected Array
    private var pickedSeatsArr : [[String:String?]] = []
    
    //image Strings
    var closeImageStr = ""
    var stageNameStr = ""
    
    //Procced Button String
    var doneBtnTitleStr = ""
    
    //Seat Array and Number of seats can be selected
    var totalSeatsCount = 2
    var seatArr : [ColumnModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()
        self.createBgVw()
        self.setupZoom()
    }
    
    private func setupZoom() {
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = LayoutConstants.minimumZoomScale
        self.scrollView.maximumZoomScale = LayoutConstants.maximumZoomScale
        self.scrollView.setZoomScale(LayoutConstants.minimumZoomScale, animated: true)
        self.scrollView.zoomScale = LayoutConstants.minimumZoomScale
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGest)
    }
    
    
    private func getData() {
        if let path = Bundle.main.path(forResource: "jsn", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let dictArr = jsonResult as? [[String: AnyObject]] {
                    // do stuff
                    for data in dictArr {
                        seatArr.append(ColumnModel(jsonDict: data))
                    }
                    print(seatArr)
                    
                }
            } catch {
                // handle error
            }
        }
    }
}

//MARK: - Adding background, stage image

extension CircularSeatLayoutVC {
    
    private func createBgVw() {
        
        let mainViewX = LayoutConstants.screenSize.width*4
        let mainViewY = LayoutConstants.screenSize.height + 100
        
        self.scrollView.backgroundColor = LayoutColors.mainViewColor
        self.layoutMainVw = UIView(frame: CGRect(x: 0, y: 0, width: mainViewX, height: mainViewY))
        self.layoutMainVw.backgroundColor = LayoutColors.mainViewColor
        
        //Adding stage in center
        
        let imageViewX = (mainViewX)/2 - LayoutConstants.stageWidth/2
        let imageViewY = mainViewY - LayoutConstants.centerStageHeight - 44
        
        self.stageVw = UIImageView(frame: CGRect(x: imageViewX, y: imageViewY, width: LayoutConstants.stageWidth, height: LayoutConstants.centerStageHeight))
        self.stageVw.image = UIImage(named: LayoutImages.stageStr)
        
        if self.stageNameStr != "" {
            self.stageVw.image = UIImage(named: self.stageNameStr)
        } else {
            self.stageVw.image = UIImage(named: LayoutImages.stageStr)
        }
        
        self.stageVw.contentMode = .scaleAspectFill
        self.stageVw.clipsToBounds = true
        //self.imageVw.tintColor = LayoutColors.stageViewColor
        
        //Adding done button
        let doneBtnX = 18.0
        let doneBtnY = 44.0
        let frframeDoneBtn = CGRect(x: doneBtnX, y: doneBtnY, width: LayoutConstants.doneBtnWidth, height: LayoutConstants.doneBtnHeight - 10)
        
        let doneBtn = UIButton.init(frame: frframeDoneBtn)
        
        doneBtn.clipsToBounds      = true
        doneBtn.backgroundColor = LayoutColors.stageViewColor
        doneBtn.layer.cornerRadius = 5
        doneBtn.setTitleColor(UIColor.white , for: .normal)
        doneBtn.titleLabel!.font   = UIFont(name: LayoutFonts.fontNameStr, size: 24.0)
        
        if self.doneBtnTitleStr != "" {
            doneBtn.setTitle(self.doneBtnTitleStr, for: .normal)
        } else {
            doneBtn.setTitle(LayoutStrings.proccedStr, for: .normal)
        }
        
        doneBtn.addTarget(self, action: #selector(self.doneBtnAction), for: .touchUpInside)
        self.view.addSubview(doneBtn)
        
        
        //Adding close button
        let frframeCloseBtn = CGRect(x: LayoutConstants.screenSize.width - 68, y: 44, width: LayoutConstants.doneBtnHeight , height: LayoutConstants.doneBtnHeight )
        
        let closeBtn = UIButton.init(frame: frframeCloseBtn)
        
        closeBtn.clipsToBounds      = true
        closeBtn.backgroundColor = .clear
        closeBtn.layer.cornerRadius = 4
        closeBtn.backgroundColor = .white
        
        if self.closeImageStr != "" {
            closeBtn.setImage(UIImage.init(named: self.closeImageStr), for: .normal)
        } else {
            closeBtn.setImage(UIImage.init(named: LayoutImages.closeStr), for: .normal)
        }
        
        closeBtn.addTarget(self, action: #selector(self.backBtnAction), for: .touchUpInside)
        self.view.addSubview(closeBtn)
        
        
        //Adding views to main view
        self.layoutMainVw.addSubview(self.stageVw)
        self.addSeats()
        self.scrollView.addSubview(self.layoutMainVw)
    }
    
    @objc func doneBtnAction(mybutton: UIButton) {
        if self.pickedSeatsArr.count == self.totalSeatsCount {
            self.dismiss(animated: true) {
                self.delegate?.passSeatsData(seatsArr: self.pickedSeatsArr)
            }
        } else if self.pickedSeatsArr.count < self.totalSeatsCount {
            self.showToast(message: "\(ConstantKeys.pleaseSelectMinimum) \(self.pickedSeatsArr.count+1)", colorCustom: .green)
        }else {
            self.showToast(message: ConstantKeys.pleaseSelectSeats, colorCustom: .green)
        }
        
    }
    
    @objc func backBtnAction(mybutton: UIButton) {
        
        //If viewcontroller is presented
        self.dismiss(animated: true)
        
        //If navigation is used
        //self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Scroll View Gesture and functions

extension CircularSeatLayoutVC {
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if self.scrollView.zoomScale > 1 {
            self.scrollView.zoom(to: zoomRectForScale(scale: LayoutConstants.minimumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            self.scrollView.setZoomScale(LayoutConstants.doubleTapZoomScale, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = self.layoutMainVw.frame.size.height / scale
        zoomRect.size.width  = self.layoutMainVw.frame.size.width  / scale
        let newCenter = self.layoutMainVw.convert(center, from: self.scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.layoutMainVw
    }
    
}


//MARK: - Creating  Seat layout and Adding seats
extension CircularSeatLayoutVC {
    
    private func drawSeatLayoutCircle(radiusCircle: CGFloat) {
        let circle = ShapeView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0),
                                              radius: radiusCircle * 2,
                                              startAngle: 4 * .pi / 4,
                                              endAngle: 0.0,
                                              clockwise: true).cgPath
        circle.shapeLayer.fillColor = UIColor.clear.cgColor
        self.layoutMainVw.addSubview(circle)
        circle.centerXAnchor.constraint(equalTo: self.layoutMainVw.centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: self.layoutMainVw.bottomAnchor).isActive = true
    }
    
    func addSeats() {
        for i in 0...seatArr.count-1 {
            self.arc  = CGFloat(4 * Double.pi / 4)
            
            let radiusFinal = CGFloat(LayoutConstants.radiusOfCircle + (i * LayoutConstants.spaceInCircles))
            
            
            self.drawSeatLayoutCircle(radiusCircle: radiusFinal)
            self.makeSeatBtns(seatsCount: (seatArr[i].rows?.count ?? 0) + 1, radiusCircle: radiusFinal, circleIndex: i, seatArr: seatArr[i].rows)
        }
    }
}

//MARK: - Seats Layout positions and adding buttons on those positions
extension CircularSeatLayoutVC {
    
    private func makeSeatBtns(seatsCount: Int, radiusCircle: CGFloat, circleIndex: Int, seatArr: [RowModel]?) {
        for index in 1...seatsCount {
            let point: CGPoint  = getArcBoundrPoints(seatsCount: seatsCount, radiusCircle: radiusCircle)
            
            if index != seatsCount {
                if let seatObj = seatArr?[index-1] as? RowModel {
                    self.createSeatBtns(point: point, index: index, seatsCount: seatsCount, circleIndex: circleIndex, seatObj: seatObj)
                }
            }
        }
    }
    
    private func getArcBoundrPoints(seatsCount: Int, radiusCircle: CGFloat) -> (CGPoint) {
        
        self.arc += CGFloat(4 * Double.pi / 4) / CGFloat(seatsCount)
        
        let point   = CGPoint(x: 0 + (radiusCircle * 2 * cos(self.arc)), y: 0 + (radiusCircle * 2 * sin(self.arc)))
        return (point)
    }
    
    
    private func createSeatBtns(point: CGPoint, index: Int, seatsCount: Int, circleIndex: Int, seatObj: RowModel) {
        
        let frframe = CGRect(x: self.layoutMainVw.frame.size.width/2 + point.x - (LayoutConstants.seatButtonSize/2), y: self.layoutMainVw.frame.size.height + point.y - (LayoutConstants.seatButtonSize/2) - 50, width: LayoutConstants.seatButtonSize, height: LayoutConstants.seatButtonSize)
        
        let seatBtn = CustomSeatButton.init(frame: frframe)
        seatBtn.layer.borderWidth  = 1
        seatBtn.clipsToBounds      = true
        
        if let columnX = self.seatArr[circleIndex].column {
            seatBtn.columnIndex = columnX
        }
        if let rowX = self.seatArr[circleIndex].rows?[index-1].seatTitle {
            seatBtn.rowIndex = rowX
        } else {
            seatBtn.rowIndex = nil
        }
        
        seatBtn.layer.cornerRadius = LayoutConstants.seatButtonSize / 2
        seatBtn.titleLabel!.font   = UIFont(name: LayoutFonts.fontNameStr, size: LayoutConstants.seatButtonSize/2)
        
        var isSeatOpen = true
        
        if index == seatsCount {
            seatBtn.backgroundColor    = LayoutColors.seatEmptyBackgroundColor
            seatBtn.layer.borderColor  = LayoutColors.seatEmptyBorderColor
            seatBtn.setTitleColor(LayoutColors.seatEmptyTextColor , for: .normal)
            seatBtn.setTitle("", for: .normal)
        } else {
            
            if let seatNumber = seatObj.seatTitle {
                if seatNumber.isNumber {
                    seatBtn.backgroundColor    = LayoutColors.seatUnselectedBackgroundColor
                    seatBtn.layer.borderColor  = LayoutColors.seatUnselectedBorderColor
                    seatBtn.setTitleColor(LayoutColors.seatUnselectedTextColor , for: .normal)
                    seatBtn.setTitle(seatNumber, for: .normal)
                    
                    if let unavali = seatObj.seatBlocked, unavali == false {
                        isSeatOpen = false
                        seatBtn.backgroundColor    = LayoutColors.seatUnavailableColor
                    }
                    
                } else {
                    seatBtn.backgroundColor    = LayoutColors.seatRowTitleBackgroundColor
                    seatBtn.layer.borderColor  = LayoutColors.seatRowTitleBorderColor
                    seatBtn.setTitleColor(LayoutColors.seatRowTitleTextColor , for: .normal)
                    seatBtn.setTitle(seatNumber, for: .normal)
                    seatBtn.titleLabel!.font   = UIFont(name: LayoutFonts.fontNameStr, size: LayoutConstants.seatButtonSize/2 + 6)
                    isSeatOpen = false
                }
            } else {
                seatBtn.backgroundColor    = LayoutColors.seatEmptyBackgroundColor
                seatBtn.layer.borderColor  = LayoutColors.seatEmptyBorderColor
                seatBtn.setTitleColor(LayoutColors.seatEmptyTextColor , for: .normal)
                seatBtn.setTitle("", for: .normal)
                isSeatOpen = false
            }
        }
        
        if isSeatOpen {
            seatBtn.addTarget(self, action: #selector(self.seatBtnAction), for: .touchUpInside)
        }
        
        
        self.layoutMainVw.addSubview(seatBtn)
        let horizontalConstraint1    = seatBtn.centerXAnchor.constraint(equalTo: self.layoutMainVw.centerXAnchor)
        let verticalConstraint1      = seatBtn.centerYAnchor.constraint(equalTo: self.layoutMainVw.bottomAnchor)
        NSLayoutConstraint.activate([horizontalConstraint1, verticalConstraint1])
    }
    
    @objc func seatBtnAction(mybutton: CustomSeatButton) {
        
        var tempSelectedArr : [[String: String?]] = self.pickedSeatsArr
        var skipViewAll = 1
        if self.pickedSeatsArr.count == self.totalSeatsCount{
            
            for obj in self.pickedSeatsArr {
                if let columnS = mybutton.columnIndex {
                    if let rowS = mybutton.rowIndex {
                        
                        if obj[ConstantKeys.ROW] == rowS && obj[ConstantKeys.COLUMN] == columnS {
                            
                            tempSelectedArr.removeAll { newobj in
                                columnS == newobj[ConstantKeys.COLUMN] && rowS == newobj[ConstantKeys.ROW]
                                
                            }
                            skipViewAll = 2
                            
                            //Clear button color
                            let viewsN = self.layoutMainVw.subviews
                            for view in viewsN {
                                
                                //Clearing all seats colors
                                if let btn : CustomSeatButton = view as? CustomSeatButton {
                                    
                                    if btn.rowIndex == rowS && btn.columnIndex == columnS {
                                        btn.backgroundColor = LayoutColors.seatUnselectedBackgroundColor
                                    }
                                }
                            }
                            
                            break
                        }
                    }
                }
            }
            
            
            
            if skipViewAll == 2 {
                self.pickedSeatsArr = tempSelectedArr
            } else if skipViewAll == 1 {
                //Clear button color
                let views = self.layoutMainVw.subviews
                for view in views {
                    
                    //Clearing all seats colors
                    if let btn : CustomSeatButton = view as? CustomSeatButton {
                        
                        for obj in self.pickedSeatsArr {
                            if let columnS = obj[ConstantKeys.COLUMN] {
                                if let rowS = obj[ConstantKeys.ROW] {
                                    
                                    if btn.rowIndex == rowS && btn.columnIndex == columnS {
                                        btn.backgroundColor = LayoutColors.seatUnselectedBackgroundColor
                                    }
                                }
                            }
                        }
                    }
                }
                
                //Clearing all seats
                tempSelectedArr = []
                self.pickedSeatsArr = []
                
                if let columnS = mybutton.columnIndex {
                    if let rowS = mybutton.rowIndex {
                        self.pickedSeatsArr.append([ConstantKeys.COLUMN: columnS, ConstantKeys.ROW: rowS])
                    } else {
                        self.pickedSeatsArr.append([ConstantKeys.COLUMN: columnS, ConstantKeys.ROW: nil])
                    }
                }
                mybutton.backgroundColor = LayoutColors.seatSelectedBackgroundColor
            }
            
            
        } else {
            
            //Clear button color
            let views = self.layoutMainVw.subviews
            for view in views {
                
                //Clearing all seats colors
                if let btn : CustomSeatButton = view as? CustomSeatButton {
                    
                    if let columnS = mybutton.columnIndex {
                        if let rowS = mybutton.rowIndex {
                            
                            if btn.rowIndex == rowS && btn.columnIndex == columnS {
                                btn.backgroundColor = LayoutColors.seatUnselectedBackgroundColor
                                tempSelectedArr.removeAll { newobj in
                                    columnS == newobj[ConstantKeys.COLUMN] && rowS == newobj[ConstantKeys.ROW]
                                }
                                
                            }
                        }
                    }
                }
            }
            
            if tempSelectedArr.count < self.pickedSeatsArr.count {
                self.pickedSeatsArr = tempSelectedArr
            } else {
                if let columnS = mybutton.columnIndex {
                    if let rowS = mybutton.rowIndex {
                        self.pickedSeatsArr.append([ConstantKeys.COLUMN: columnS, ConstantKeys.ROW: rowS])
                    } else {
                        self.pickedSeatsArr.append([ConstantKeys.COLUMN: columnS, ConstantKeys.ROW: nil])
                    }
                }
                mybutton.backgroundColor = LayoutColors.seatSelectedBackgroundColor
            }
        }
    }
}


