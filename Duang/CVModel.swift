//
//  CVModel.swift
//  Duang
//
//  Created by YU GUOBIN on 15/6/8.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class CVModel
{
    var mSectionGroupArray = [CVMSectionGroup]()
    
    func createASectionGroup() {
        
        var mCell = CVMCell()
        mCell.cellType = CVMCell.CellType.Space(color: UIColor.redColor())
        mCell.height = 50
        
        var mCellGroup = CVMCellGroup()
        mCellGroup.mCellArray.append(mCell)
        
        var mSection = CVMSection()
        mSection.mCellGroupArray.append(mCellGroup)
        
        var mSectionGroup = CVMSectionGroup()
        mSectionGroup.isHeader = true
        mSectionGroup.mSectionArray.append(mSection)
        
        mSectionGroup.width = 500
        mSectionGroup.calculateSizeWidth()
        
        mSectionGroupArray.append(mSectionGroup)
        
        
        check()
    }
    
    func check() -> Bool {
        for mSectionGroup in mSectionGroupArray {
            if mSectionGroup.width == 0 || mSectionGroup.height == 0 {
                return false
            }
            for mSection in mSectionGroup.mSectionArray {
                if mSection.width == 0 || mSection.height == 0 {
                    return false
                }
                for mCellGroup in mSection.mCellGroupArray {
                    if mCellGroup.width == 0 || mCellGroup.height == 0 {
                        return false
                    }
                    for mCell in mCellGroup.mCellArray {
                        if mCell.width == 0 || mCell.height == 0 {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
}