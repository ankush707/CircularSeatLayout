//
//  Models.swift
//
//  CircularSeatLayout
//
//  Created by Ankush on 21/10/22.
//

import Foundation
import UIKit

//MARK: - Models
struct ColumnModel {
    var rows: [RowModel]?
    var column: String?
    
    init(jsonDict: [String: AnyObject]) {
        
        self.column = jsonDict[ConstantKeys.COLUMN] as? String
        
        self.rows = []
        let arr = jsonDict[ConstantKeys.ROW] as? [[String: AnyObject]]
        for obj in arr! {
            rows?.append(RowModel(jsonDict: obj))
        }
        
    }
}

struct RowModel {
    var seatTitle: String?
    var seatBlocked: Bool?
    
    init(jsonDict: [String: AnyObject]) {
        self.seatTitle = jsonDict[ConstantKeys.seatTitle] as? String
        self.seatBlocked = jsonDict[ConstantKeys.seatBlocked] as? Bool
    }
}
