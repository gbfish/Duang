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
        case Button
        case RightDetail
    }
    
    var rowType = RowType.Button
    
    // MARK: - 
    
    var titleString = ""
    var detailString = ""
    
    // MARK: - 
    
    var heightForRow: CGFloat {
        get{
            switch rowType {
            case RowType.Button:
                return 50.0
            case RowType.RightDetail:
                return 50.0
            }
        }
    }
    
    var cellIdentifier: String {
        get {
            switch rowType {
            case RowType.Button:
                return "DuangTableCellButton"
            case RowType.RightDetail:
                return "RightDetail"
            }
        }
    }
    
//    func setCell(cell: UITableViewCell) {
//        switch rowType {
//        case RowType.Button:
//            println("setCell - Button")
//        case RowType.RightDetail:
//            cell.textLabel?.text = cellTitle
//            cell.detailTextLabel?.text = cellDetail
//        }
//    }
//    
//    var cell: UITableViewCell {
//        get {
//            
//        }
//    }
    
    // MARK: - Button
    
    var buttonText = ""

    // MARK: - Did Select Func
    
    enum DidSelectFunc {
        case Nothing
        case Arity0 ( Void -> Void )
        case Arity2 ( (Int, String) -> Void)
    }
    var didSelectFunc = DidSelectFunc.Nothing
}