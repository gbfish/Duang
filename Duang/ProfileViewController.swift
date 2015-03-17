//
//  ProfileViewController.swift
//  Duang
//
//  Created by YU GUOBIN on 15/3/16.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class ProfileViewController: FatherViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override var fatherData: FatherData {
        get {
            let item = FatherDataItem()
            item.itemType = FatherDataItem.ItemType.Button
            
            //        item.buttonAction { () -> () in
            //            self.tapAction()
            //        }
            
            //        item.buttonAction() = tapAction
            
            let fatherDataArray = FatherDataArray()
            fatherDataArray.dataArray.append(item)
            
            self.fatherData.dataArray.append(fatherDataArray)
            
            return FatherData()
        }
        set {
            
        }
    }

}
