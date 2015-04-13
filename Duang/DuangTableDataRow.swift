//
//  DuangTableDataRow.swift
//  Duang
//
//  Created by YU GUOBIN on 15/4/11.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation

class DuangTableDataRow
{
    
    
    var rowType = RowType.Nothing
    
    
    
    
    // MARK: - enum DuangTableDataRow
    
    enum RowType {
        
        
        case TextView(placeholder: String?)
        case TextField(placeholder: String?)
        
        
        
        
        
        case UserBig(userName: String, userDescription: String, userAvatarPlaceholder: UIImage, userAvatarFile: PFFile?, userBannerPlaceholder: UIImage, userBannerFile: PFFile?, tapAction: () -> ())
        case ImageMutable(photos: PFRelation, tapAction: () -> ())
        case ImageBig(cellHeight: CGFloat, imagePlaceholder: UIImage, imageFile: PFFile?, tapAction: () -> ())
        
        
        case Label(cellHeight: CGFloat, text: String, font: UIFont)
        case Button(buttonText: String, buttonTextColor: UIColor, buttonBackgroundColor: UIColor, tapAction: () -> ())
        case DefaultRightDetail(titleText: String, detailText: String, tapAction: () -> ())
        case Message(ownerAvatarFile: PFFile?, ownerName: String, time: String, message: String)
        
        
        case ImageSmall(imageTitle: String, imagePlaceholder: UIImage, imageFile: PFFile?, isRound: Bool, tapAction: DuangTableDataRowFunction)
        
        case Buttons(buttonArray: [DuangTableDataRowButtonItem], thePFObject: PFObject?)
        
        case Nothing
        
        func cellHeight() -> CGFloat {
            switch self {
            case .UserBig(_):
                return UIScreen.mainScreen().bounds.size.width
            case .ImageMutable:
                return UIScreen.mainScreen().bounds.size.width
            case .ImageBig(let cellHeight, _, _, _):
                return cellHeight
            case .ImageSmall(_):
                return 50.0
            case .TextView(_):
                return 200.0
            case .TextField(_):
                return 50.0
            case .Label(let cellHeight, _, _):
                return cellHeight
            case .Button(_):
                return 50.0
            case .DefaultRightDetail(_):
                return 50.0
            case .Buttons(_):
                return 50.0
            default:
                return 0.0
            }
        }
        
        func cellIdentifier() -> String {
            switch self {
            case .UserBig(_):
                return "DuangTableCellUserBig"
            case .ImageMutable:
                return "DuangTableCellImageMutable"
            case .ImageBig(_):
                return "DuangTableCellImageBig"
            case .ImageSmall(_):
                return "DuangTableCellImageSmall"
            case .TextView(_):
                return "DuangTableCellTextView"
            case .TextField(_):
                return "DuangTableCellTextField"
            case .Label(_):
                return "DuangTableCellLabel"
            case .Button(_):
                return "DuangTableCellButton"
            case .DefaultRightDetail(_):
                return "DefaultCell"
            case .Buttons(_):
                return "DuangTableCellButtons"
            default:
                return "DefaultCell"
            }
        }
        
        func tapAction() {
            switch self {
            case .UserBig(_, _, _, _, _, _, let tapAction):
                tapAction()
            case .ImageBig(_, _, _, let tapAction):
                tapAction()
            case .ImageSmall(_, _, _, _, let tapAction):
                tapAction.functionAction()
            case .Button(_, _, _, let tapAction):
                tapAction()
            case .DefaultRightDetail(_, _, let tapAction):
                tapAction()
                
                
            default:
                break
            }
        }
    }
    
    // MARK: - enum DuangTableDataRowButtonItem
    
    enum DuangTableDataRowButtonItem {
        case ButtonItemTitleImage(style: DuangTableDataRowButtonItemStyle, buttonText: String, buttonImage: UIImage, function: DuangTableDataRowFunction)
        case ButtonItemTitle(style: DuangTableDataRowButtonItemStyle, buttonText: String, function: DuangTableDataRowFunction)
        
        func functionAction() {
            switch self {
            case .ButtonItemTitleImage(_, _, _, let function):
                function.functionAction()
            case .ButtonItemTitle(_, _, let function):
                function.functionAction()
            }
        }
        
        // MARK: - y
        
        enum DuangTableDataRowButtonItemStyle {
            case Normal
            case Selected
            case Alert
        }
        
        private func myStyle() -> DuangTableDataRowButtonItemStyle {
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
    
    // MARK: - enum DuangTableDataRowFunction
    
    enum DuangTableDataRowFunction {
        case Function0(argumentCount: NSInteger, function: () -> ())
        case Function1PFObject(argumentCount: NSInteger, function: (PFObject?) -> (), argument: PFObject?)
        
        func functionAction() {
            switch self {
            case .Function0(let argumentCount, let function):
                function()
            case .Function1PFObject(let argumentCount, let function, let argument):
                function(argument)
            default:
                break
            }
        }
    }
    
    class func function0(function: () -> ()) -> DuangTableDataRowFunction {
        return DuangTableDataRowFunction.Function0(argumentCount: 0, function: function)
    }
    
    class func function1PFObject(function: (PFObject?) -> (), argument: PFObject?) -> DuangTableDataRowFunction {
        return DuangTableDataRowFunction.Function1PFObject(argumentCount: 1, function: function, argument: argument)
    }
}