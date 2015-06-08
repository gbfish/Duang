//
//  CVMSectionGroup.swift
//  Duang
//
//  Created by YU GUOBIN on 15/6/8.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class CVMSectionGroup
{
    var isHeader = true
    
    var mSectionArray = [CVMSection]()
    
    // MARK: - Size
    
    var width: Int = 0
    var height: Int = 0
    
    var estimateWidth: Int {
        var returnValue: Int = 0
        for mSection in mSectionArray {
            if returnValue < mSection.estimateWidth {
                returnValue = mSection.estimateWidth
            }
        }
        return returnValue
    }
    
    var estimateHeight: Int {
        get {
            var returnValue: Int = 0
            for mSection in mSectionArray {
                returnValue = returnValue + mSection.estimateHeight
            }
            return returnValue
        }
    }
    
    func calculateSizeWidth() {
        for mSection in mSectionArray {
            mSection.width = width
            mSection.height = mSection.estimateHeight
            mSection.calculateSizeWidth()
        }
    }
}