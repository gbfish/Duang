//
//  DTableViewModelRow.swift
//  Duang
//
//  Created by David Yu on 15/4/21.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class DTableViewModelRow
{
    var heightForRow: CGFloat = 50.0
    
    // MARK: - RowType
    
    enum RowType {
        case Nothing
        case Buttons(buttonItemArray: [ButtonItem])
    }
    
    var rowType = RowType.Nothing
    
    // MARK: - enum DuangTableDataRowButtonItem
    
    enum ButtonItem {
        case ButtonItemTitleImage(style: ButtonItemStyle, buttonText: String, buttonImage: UIImage, function: Function)
        case ButtonItemTitle(style: ButtonItemStyle, buttonText: String, function: Function)
        
        func functionAction() {
            switch self {
            case .ButtonItemTitleImage(_, _, _, let function):
                function.action()
            case .ButtonItemTitle(_, _, let function):
                function.action()
            }
        }
        
        // MARK: - Style
        
        enum ButtonItemStyle {
            case Normal
            case Selected
            case Alert
        }
        
        private func myStyle() -> ButtonItemStyle {
            switch self {
            case .ButtonItemTitle(let style, _, _):
                return style
            case .ButtonItemTitleImage(let style, _, _, _):
                return style
            }
        }
        
        func buttonTextColor() -> UIColor {
            switch myStyle() {
            case .Normal:
                return DuangColor.DarkBlue
            case .Alert:
                return DuangColor.White
            case .Selected:
                return DuangColor.White
            }
        }
        
        func buttonBackgroundColor() -> UIColor {
            switch myStyle() {
            case .Normal:
                return DuangColor.White
            case .Alert:
                return DuangColor.Red
            case .Selected:
                return DuangColor.Orange
            }
        }
        
        func borderColor() -> UIColor {
            switch myStyle() {
            case .Normal:
                return DuangColor.DarkBlue
            case .Alert:
                return DuangColor.DarkBlue
            case .Selected:
                return DuangColor.DarkBlue
            }
        }
    }
    
    // MARK: - Function
    
    enum Function {
        case Nothing
        case Function(argumentCount: NSInteger, function: () -> ())
        case Function1Argument(name: String, function: (Argument) -> (), argument: Argument)
        
        enum Argument {
            case PFObject
        }
        
        func action() {
            switch self {
            case .Function(_, let function):
                function()
            case .Function1Argument(_, let function, let argument):
                function(argument)
            default:
                break
            }
        }
    }
    
    

}
