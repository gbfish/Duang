//
//  CVMCellGroup.swift
//  Duang
//
//  Created by YU GUOBIN on 15/6/8.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class CVMCellGroup
{
    var mCellArray = [CVMCell]()
    
    // MARK: - Size
    
    var width: Int = 0
    var height: Int = 0
    
    var estimateWidth: Int {
        var returnValue: Int = 0
        for mCell in mCellArray {
            if returnValue < mCell.width {
                returnValue = mCell.width
            }
        }
        return returnValue
    }
    
    var estimateHeight: Int {
        get {
            var returnValue: Int = 0
            for mCell in mCellArray {
                returnValue = returnValue + mCell.height
            }
            return returnValue
        }
    }
    
    func calculateSizeWidth() {
        var sumEstimateHeight: Int = 0
        var flexibleCount: Int = 0
        for mCell in mCellArray {
            if mCell.height == 0 {
                flexibleCount++
            } else {
                sumEstimateHeight = sumEstimateHeight + mCell.height
            }
        }
        var flexibleHeight: Int = 0
        var flexibleHeightCorrection: Int = 0
        if flexibleCount > 0 {
            flexibleHeight = (height - sumEstimateHeight) / flexibleCount
            flexibleHeightCorrection = height - sumEstimateHeight - (flexibleHeight * (flexibleCount - 1))
        }
        var isFirst = true
        
        for mCell in mCellArray {
            if mCell.height == 0 {
                if isFirst {
                    isFirst = false
                    mCell.height = flexibleHeightCorrection
                } else {
                    mCell.height = flexibleHeight
                }
            }
            mCell.width = width
        }
    }
}