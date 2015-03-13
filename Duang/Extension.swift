//
//  Extension.swift
//  Duang
//
//  Created by David Yu on 15/3/11.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setNavigationBarStyle() {
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.barTintColor = DuangColor.NavigationBackground
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: DuangColor.Navigation]
    }
}

extension UIButton {
    func setButtonStyleNormal() {
        setTitleColor(DuangColor.ButtonNormal, forState: UIControlState.Normal)
        backgroundColor = DuangColor.ButtonNormalBackground
    }
    
    func setButtonStyleUnselected() {
        setTitleColor(DuangColor.ButtonUnselected, forState: UIControlState.Normal)
        backgroundColor = DuangColor.ButtonUnselectedBackground
    }
}