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
        if let viewController = getViewController(DTableViewModel.TableType.Feed, itemTitle: TabBarTitle.Feed, itemImageName: "TabBar_Images", tag: 0) {
            temViewControllers.append(viewController)
        }
        if let viewController = getViewController(DTableViewModel.TableType.LogIn, itemTitle: TabBarTitle.Users, itemImageName: "TabBar_Users", tag: 1) {
            temViewControllers.append(viewController)
        }
//        if let viewController = getViewController(DuangTableViewController.TableType.AddPost, itemTitle: TabBarTitle.AddPost, itemImageName: "TabBar_Add", tag: 2) {
//            temViewControllers.append(viewController)
//        }
//        if let viewController = getViewController(DuangTableViewController.TableType.Profile, itemTitle: TabBarTitle.Profile, itemImageName: "TabBar_Person", tag: 3) {
//            temViewControllers.append(viewController)
//        }
        viewControllers = temViewControllers
        
    }
    
    func getViewController(tableType: DTableViewModel.TableType, itemTitle: String, itemImageName: String, tag: NSInteger) -> UINavigationController? {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DTableViewController") as? DTableViewController {
            viewController.dTableViewModel.tableType = tableType
            viewController.tabBarItem = UITabBarItem(title: itemTitle, image: UIImage(named: itemImageName), tag: 1)
            return UINavigationController(rootViewController: viewController)
        }
        return nil
    }
    
    
/*
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var temViewControllers = [UIViewController]()
        if let viewController = getViewController(DuangTableViewController.TableType.Feed, itemTitle: TabBarTitle.Feed, itemImageName: "TabBar_Images", tag: 0) {
            temViewControllers.append(viewController)
        }
        if let viewController = getViewController(DuangTableViewController.TableType.Users, itemTitle: TabBarTitle.Users, itemImageName: "TabBar_Users", tag: 1) {
            temViewControllers.append(viewController)
        }
        if let viewController = getViewController(DuangTableViewController.TableType.AddPost, itemTitle: TabBarTitle.AddPost, itemImageName: "TabBar_Add", tag: 2) {
            temViewControllers.append(viewController)
        }
        if let viewController = getViewController(DuangTableViewController.TableType.Profile, itemTitle: TabBarTitle.Profile, itemImageName: "TabBar_Person", tag: 3) {
            temViewControllers.append(viewController)
        }
        viewControllers = temViewControllers
        /*
        viewControllers = [getViewController(DuangTableViewController.TableType.Feed, itemTitle: TabBarTitle.Feed, itemImageName: "TabBar_Images", tag: 0),
            getViewController(DuangTableViewController.TableType.Users, itemTitle: TabBarTitle.Users, itemImageName: "TabBar_Users", tag: 1),
            getViewController(DuangTableViewController.TableType.AddPost, itemTitle: TabBarTitle.AddPost, itemImageName: "TabBar_Add", tag: 2),
            getViewController(DuangTableViewController.TableType.Profile, itemTitle: TabBarTitle.Profile, itemImageName: "TabBar_Person", tag: 3)]
        */

    }
    
    func getViewController(tableType: DuangTableViewController.TableType, itemTitle: String, itemImageName: String, tag: NSInteger) -> UINavigationController? {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as? DuangTableViewController {
            viewController.tableType = tableType
            viewController.tabBarItem = UITabBarItem(title: itemTitle, image: UIImage(named: itemImageName), tag: 1)
            return UINavigationController(rootViewController: viewController)
        }
        return nil
    }*/
}
