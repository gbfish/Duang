//
//  MainTabBarController.swift
//  Duang
//
//  Created by YU GUOBIN on 15/3/22.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [getViewController(DuangTableViewController.TableType.Feed, itemTitle: TabBarTitle.Feed, itemImageName: "TabBar_Feed", tag: 0),
            getViewController(DuangTableViewController.TableType.Profile, itemTitle: TabBarTitle.Profile, itemImageName: "TabBar_person", tag: 1)]
        

    }
    
    func getViewController(tableType: DuangTableViewController.TableType, itemTitle: String, itemImageName: String, tag: NSInteger) -> UINavigationController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.tableType = tableType
        viewController.tabBarItem = UITabBarItem(title: itemTitle, image: UIImage(named: itemImageName), tag: 1)
        return UINavigationController(rootViewController: viewController)
    }
}
