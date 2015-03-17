//
//  FatherData.swift
//  Duang
//
//  Created by David Yu on 15/3/16.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation
import UIKit

class FatherData {
    
    var dataArray = [FatherDataArray]()
}

// MARK: - Father Data Array

class FatherDataArray {
    var sectionName = ""
    var dataArray = [FatherDataItem]()
}

// MARK: - Father Data Item

class FatherDataItem {
    enum ItemType{
        case Button
    }
    
    var itemType = ItemType.Button
    
    var heightForRow: CGFloat {
        get{
            switch itemType {
            case ItemType.Button:
                return 50.0
            }
        }
    }
    
    // MARK: - Button
    
    var buttonText = ""
    
    var saveAction: () -> () = emptyFunc()
    
    func emptyFunc() -> (() -> ()){
//        return
    }
    
    func buttonAction(action:() -> ()) -> (){
        saveAction = action
    }
}