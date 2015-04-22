//
//  DTableViewController.swift
//  Duang
//
//  Created by David Yu on 15/4/21.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DTableViewModelProtocol, DTableViewCellButtonsProtocol
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dTableViewModel.delegate = self
        
        
        setDTableViewModelFunctions()
        
        dTableViewModel.dataWillLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - DTableViewModel
    
    var dTableViewModel = DTableViewModel()
//    var tableType = DTableViewModel.TableType.Landing
    
    // MARK: DTableViewModelProtocol
    
    func dataDidLoad() {
        tableView.reloadData()
    }
    
    // MARK: - TableView
    
    @IBOutlet weak var tableView: UITableView!

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dTableViewModel.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dTableViewModel.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dTableViewModel.titleForHeaderInSection(section)
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerFooterView = view as? UITableViewHeaderFooterView {
            headerFooterView.textLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            headerFooterView.textLabel.text = headerFooterView.textLabel.text?.capitalizedString
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dTableViewModel.heightForRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let modelRow = dTableViewModel.row(indexPath) {
            switch modelRow.rowType {
            case .Buttons(let buttonItemArray):
                if let cell = tableView.dequeueReusableCellWithIdentifier(modelRow.cellIdentifier(), forIndexPath: indexPath) as? DTableViewCellButtons {
                    cell.delegate = self
                    cell.buttonItemArray = buttonItemArray
                    cell.reloadView()
                    return cell
                }
            default:
                break
            }
        }
        return UITableViewCell()

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
//        selectedIndexPath = indexPath
//        duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].tapAction()
        
        
    }
    
    // MARK: - Cell DTableViewCellButtonsProtocol
    
    func dTableViewCellButtonsAction(buttonItem: DTableViewModelRow.ButtonItem) {
        buttonItem.functionAction()
    }
    
    // MARK: - Function
    
    func setDTableViewModelFunctions() {
        switch dTableViewModel.tableType {
        case .Landing:
            dTableViewModel.functionShowSignUp = DTableViewModelRow.Function.Function(argumentCount: 0, function: showSignUp)
            dTableViewModel.functionShowLogIn = DTableViewModelRow.Function.Function(argumentCount: 0, function: showLogIn)
        }
        
        
    }
    
    func showSignUp() {
        println("showSignUp")
    }
    
    func showLogIn() {
        println("showLogIn")
    }
    
    

}
