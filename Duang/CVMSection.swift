//
//  CVMSection.swift
//  Duang
//
//  Created by YU GUOBIN on 15/6/8.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class CVMSection
{
    var mCellGroupArray = [CVMCellGroup]()
    
    // MARK: - Size
    
    var width: Int = 0
    var height: Int = 0
    
    var estimateWidth: Int {
        get {
            var returnValue: Int = 0
            for mCellGroup in mCellGroupArray {
                returnValue = returnValue + mCellGroup.estimateWidth
            }
            return returnValue
        }
    }
    
    var estimateHeight: Int {
        var returnValue: Int = 0
        for mCellGroup in mCellGroupArray {
            if returnValue < mCellGroup.estimateHeight {
                returnValue = mCellGroup.estimateHeight
            }
        }
        return returnValue
    }
    
    func calculateSizeWidth() {
        var sumEstimateWidth: Int = 0
        var flexibleCount: Int = 0
        for mCellGroup in mCellGroupArray {
            if mCellGroup.estimateWidth == 0 {
                flexibleCount++
            } else {
                sumEstimateWidth = sumEstimateWidth + mCellGroup.estimateWidth
            }
        }
        var flexibleWidth: Int = 0
        var flexibleWidthCorrection: Int = 0
        if flexibleCount > 0 {
            flexibleWidth = (width - sumEstimateWidth) / flexibleCount
            flexibleWidthCorrection = width - sumEstimateWidth - (flexibleWidth * (flexibleCount - 1))
        }
        var isFirst = true
        
        for mCellGroup in mCellGroupArray {
            if mCellGroup.estimateWidth == 0 {
                if isFirst {
                    isFirst = false
                    mCellGroup.width = flexibleWidthCorrection
                } else {
                    mCellGroup.width = flexibleWidth
                }
            } else {
                mCellGroup.width = mCellGroup.estimateWidth
            }
            mCellGroup.height = height
            
            mCellGroup.calculateSizeWidth()
        }
    }
}