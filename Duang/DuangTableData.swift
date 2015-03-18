//
//  DuangTableData.swift
//  Duang
//
//  Created by David Yu on 15/3/17.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation
import UIKit

class DuangTableData {
    var sectionArray = [DuangTableDataSection]()
}

// MARK: - Father Data Array

class DuangTableDataSection {
    var sectionName = ""
    var rowArray = [DuangTableDataRow]()
}

// MARK: - Father Data Item

class DuangTableDataRow {
    enum RowType{
        case UserBig
        case UserSmall
        
        case Button
        
//        case DefaultImage
        case DefaultRightDetail
    }
    var rowType = RowType.Button
    
    // MARK: - 
    
    var titleString = ""
    var detailString = ""
    
    // MARK: - Did Select Func
    
    enum DidSelectFunc {
        case Nothing
        case Function1 ( Void -> Void )
//        case Function2 ( (Int, String) -> Void)
    }
    var didSelectFunc = DidSelectFunc.Nothing
}