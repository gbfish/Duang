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

//        setViewController(DuangTableViewController.TableType.Profile, systemItem: UITabBarSystemItem.MostRecent, tag: 0)
//        setViewController(DuangTableViewController.TableType.Settings, systemItem: UITabBarSystemItem.Featured, tag: 1)
//        setViewController(DuangTableViewController.TableType.ProfileEdit, systemItem: UITabBarSystemItem.TopRated, tag: 2)
        
        
        
//        viewControllers?.append(getViewController(DuangTableViewController.TableType.Settings))
//        viewControllers?.append(getViewController(DuangTableViewController.TableType.ProfileEdit))
//        
//        
//        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
//        viewController.tableType = DuangTableViewController.TableType.Settings
//        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Favorites, tag: 0)
////        return UINavigationController(rootViewController: viewController)
        
        
        
        viewControllers = [getViewController(DuangTableViewController.TableType.Profile, systemItem: UITabBarSystemItem.Contacts, tag: 3), getViewController(DuangTableViewController.TableType.Profile, systemItem: UITabBarSystemItem.Contacts, tag: 3)]
        

    }
    
    func getViewController(tableType: DuangTableViewController.TableType, systemItem: UITabBarSystemItem, tag: NSInteger) -> UINavigationController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.tableType = tableType
        viewController.tabBarItem = UITabBarItem(title: "MMEE", image: UIImage(named: "TabBar_person"), tag: 1)
        return UINavigationController(rootViewController: viewController)
    }
    
    
//    func setViewController(tableType: DuangTableViewController.TableType, systemItem: UITabBarSystemItem, tag: NSInteger) {
//        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
//        viewController.tableType = tableType
//        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: systemItem, tag: tag)
//        viewControllers?.append(UINavigationController(rootViewController: viewController))
//    }
}
