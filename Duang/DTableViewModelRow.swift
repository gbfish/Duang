//
//  DTableViewModelRow.swift
//  Duang
//
//  Created by David Yu on 15/4/21.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation
import Parse

class DTableViewModelRow
{
    // MARK: - RowType
    
    enum RowType {
        case Nothing
        case Buttons(buttonItemArray: [ButtonItem])
        case Image(heightForRow: CGFloat?, image: UIImage?, imageFile: PFFile?, function: Function?)
        case TextView(heightForRow: CGFloat?, textViewTitle: String?, textViewText: String?, textViewTitleWidth: CGFloat?)
//        case Detail(image: UIImage?, imageFile: PFFile?, isRound: Bool, detailTitle: String?, detailButton: ButtonItem?)
        case DetailImage(image: UIImage?, detailTitle: String?, detailButtonItem: ButtonItem?)
        case DetailUser(user: PFUser?, detailButtonItem: ButtonItem?)
        case Label(text: String?, font: UIFont?)
    }
    
    var rowType = RowType.Nothing
    
    func cellIdentifier() -> String {
        switch rowType {
        case .Buttons(_):
            return "DTableViewCellButtons"
        case .Image(_):
            return "DTableViewCellImage"
        case .DetailImage(_), .DetailUser(_):
            return "DTableViewCellDetail"
        case .Label(_):
            return "DTableViewCellLabel"
        case .TextView(_):
            return "DTableViewCellTextView"
        default:
            return "DefaultCell"
        }
    }
    
    // MARK: - Height For Row
    
    func heightForRow() -> CGFloat {
        switch rowType {
        case .Image(let heightForRow, _, _, _):
            if let theHeightForRow = heightForRow {
                return theHeightForRow
            }
        case .Label(let text, let font):
            if let theText = text, theFont = font {
                return APIManager.sizeForString(theText, font: theFont, width: UIScreen.mainScreen().bounds.width - 10, height: CGFloat.max).height
            } else {
                return 0.0
            }
        case .TextView(let heightForRow, _, _, _):
            if let theHeightForRow = heightForRow {
                return theHeightForRow
            }
        default:
            break
        }
        return 50.0
    }
    
    // MARK: - ButtonItem
    
    enum ButtonItem {
        case ButtonItemTitle(style: ButtonItemStyle, buttonText: String, function: Function)
        case ButtonItemTitleImage(style: ButtonItemStyle, buttonText: String, buttonImage: UIImage, function: Function)
        case ButtonItemTitleSubtitle(style: ButtonItemStyle, buttonTitleText: String, buttonSubtitleText: String, function: Function)
        
        func functionAction() {
            switch self {
            case .ButtonItemTitle(_, _, let function):
                function.action()
            case .ButtonItemTitleImage(_, _, _, let function):
                function.action()
            case .ButtonItemTitleSubtitle(_, _, _, let function):
                function.action()
            }
        }
        
        // MARK: Style
        
        enum ButtonItemStyle {
            case Normal
            case Selected
            case Alert
            
            func buttonTextColor() -> UIColor {
                switch self {
                case .Normal:
                    return DuangColor.DarkBlue
                case .Alert:
                    return DuangColor.White
                case .Selected:
                    return DuangColor.White
                }
            }
            
            func buttonBackgroundColor() -> UIColor {
                switch self {
                case .Normal:
                    return DuangColor.White
                case .Alert:
                    return DuangColor.Red
                case .Selected:
                    return DuangColor.Orange
                }
            }
            
            func borderColor() -> CGColor {
                switch self {
                case .Normal:
                    return DuangColor.DarkBlue.CGColor
                case .Alert:
                    return DuangColor.DarkBlue.CGColor
                case .Selected:
                    return DuangColor.DarkBlue.CGColor
                }
            }
        }
    }
    
    // MARK: - Function
    
    enum Function {
        case Nothing
        case Function(argumentCount: NSInteger, function: () -> ())
        case Function1Argument(argument: Argument, function: (Argument) -> ())
        
        enum Argument {
            case PFObject
            case user(user: PFUser)
        }
        
        func action() {
            switch self {
            case .Function(_, let function):
                function()
            case .Function1Argument(let argument, let function):
                function(argument)
            default:
                break
            }
        }
    }
    
    

}
