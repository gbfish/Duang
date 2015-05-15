//
//  MainTabBarController.swift
//  Duang
//
//  Created by YU GUOBIN on 15/3/22.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var temViewControllers = [UIViewController]()
        if let viewController = getViewController(DTableViewModel.TableType.WaterfallPhoto(type: DTableViewModel.WaterfallPhotoType.Feed), itemTitle: TabBarTitle.Feed, itemImageName: "TabBar_Images", tag: 0) {
            temViewControllers.append(viewController)
        }
        if let viewController = getViewController(DTableViewModel.TableType.AddPhoto, itemTitle: TabBarTitle.AddPhoto, itemImageName: "TabBar_Add", tag: 1) {
            temViewControllers.append(viewController)
        }
        if let theUser = PFUser.currentUser(), viewController = getViewController(DTableViewModel.TableType.Profile(user: theUser), itemTitle: TabBarTitle.MyProfile, itemImageName: "TabBar_Users", tag: 2) {
            temViewControllers.append(viewController)
        }
        viewControllers = temViewControllers
    }
    
    func getViewController(tableType: DTableViewModel.TableType, itemTitle: String, itemImageName: String, tag: NSInteger) -> UINavigationController? {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
            viewController.dTableViewModel.tableType = tableType
            viewController.tabBarItem = UITabBarItem(title: itemTitle, image: UIImage(named: itemImageName), tag: tag)
            return UINavigationController(rootViewController: viewController)
        }
        return nil
    }
}
