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

        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.tableType = DuangTableViewController.TableType.Profile
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.title = "Mee"
        
        
        viewControllers = [navigationController, navigationController]
        
        /*
        FirstViewController *obj_FirstViewController = [[FirstViewController alloc]initWithNibName:@"FirstViewController" bundle:nil];
        SecondViewController *obj_SecondViewController = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
        ThirdViewController *obj_ThirdViewController = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];
        
        navigation1 = [[UINavigationController alloc] initWithRootViewController:obj_FirstViewController];
        navigation2 = [[UINavigationController alloc] initWithRootViewController:obj_SecondViewController];
        navigation3 = [[UINavigationController alloc] initWithRootViewController:obj_ThirdViewController];
        
        navigation1.title=@"Home";
        navigation2.title=@"Second";
        
        MainTabBar = [[UITabBarController alloc] init];
        MainTabBar.delegate=self;
        [MainTabBar setViewControllers:[NSArray   arrayWithObjects:navigation1,navigation2,navigation3,nil]];
        MainTabBar.view.frame=self.view.frame;
        MainTabBar.selectedIndex=0;
        [self.view addSubview:MainTabBar.view]
*/
    }
    
    @IBOutlet weak var mainTabBar: UITabBar! {
        didSet {
            

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
