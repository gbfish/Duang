//
//  CVMCell.swift
//  Duang
//
//  Created by YU GUOBIN on 15/6/8.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class CVMCell
{
    // MARK: - CellType
    
    enum CellType {
        case Space(color: UIColor)
        
    }
    
    var cellType = CellType.Space(color: UIColor.whiteColor())
    
    // MARK: - Size
    
    var width: Int = 0
    var height: Int = 0
}