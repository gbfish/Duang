//
//  DuangTableViewController.swift
//  Duang
//
//  Created by David Yu on 15/3/17.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DuangTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableType = TableType.Profile
        
        checkTableType()
    }
    
    
    func checkTableType() {
        switch tableType {
        case TableType.Profile:
            
            var section = DuangTableDataSection()
            
            var row = DuangTableDataRow()
            row.rowType = DuangTableDataRow.RowType.UserBig
            row.titleString = "My Name"
            
            row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Arity0(showEditUser)
            
            section.rowArray.append(row)
            
            duangTableData.sectionArray.append(section)
            
            section = DuangTableDataSection()
            
            row = DuangTableDataRow()
            row.rowType = DuangTableDataRow.RowType.Button
            row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Arity0(tapAction)
            
            
            //                section.sectionName = "the name of section"
            section.rowArray.append(row)
            
            ////
            let row1 = DuangTableDataRow()
            row1.rowType = DuangTableDataRow.RowType.RightDetail
            row1.titleString = "Name"
            row1.detailString = "David"
            row1.didSelectFunc = DuangTableDataRow.DidSelectFunc.Arity0(tapAction2)
            
            //                let section = DuangTableDataSection()
            section.rowArray.append(row1)
            
            ////
            
            duangTableData.sectionArray.append(section)
            
        }
    }

    var titleString = ""
    
    enum TableType{
        case Profile 
    }
    
    var tableType: TableType = TableType.Profile {
        didSet {
            if tableType != oldValue {
                checkTableType()
            }
        }
    }

    
    /*
    var tableType: TableType = TableType.Profile {
        didSet {
            switch tableType {
            case TableType.Profile:
                
                var section = DuangTableDataSection()
                
                var row = DuangTableDataRow()
                row.rowType = DuangTableDataRow.RowType.UserBig
                row.titleString = "My Name"
                
                row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Arity0(showEditUser)
                
                section.rowArray.append(row)
                
                duangTableData.sectionArray.append(section)
                
                section = DuangTableDataSection()
                
                row = DuangTableDataRow()
                row.rowType = DuangTableDataRow.RowType.Button
                row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Arity0(tapAction)
                
                
//                section.sectionName = "the name of section"
                section.rowArray.append(row)
                
                ////
                let row1 = DuangTableDataRow()
                row1.rowType = DuangTableDataRow.RowType.RightDetail
                row1.titleString = "Name"
                row1.detailString = "David"
                row1.didSelectFunc = DuangTableDataRow.DidSelectFunc.Arity0(tapAction2)
                
//                let section = DuangTableDataSection()
                section.rowArray.append(row1)
                
                ////
                
                duangTableData.sectionArray.append(section)
                
            }
        }
    }*/
    
    func tapAction() {
        println("tapAction")
    }
    
    func tapAction2() {
        println("tapAction2")
    }
    
    // MARK: - TableView Data
    
    var duangTableData = DuangTableData()
    
    // MARK: - TableView
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return duangTableData.sectionArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duangTableData.sectionArray[section].rowArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row]
        switch row.rowType {
        case DuangTableDataRow.RowType.UserBig:
            return 100.0
        case DuangTableDataRow.RowType.Button:
            return 50.0
        case DuangTableDataRow.RowType.RightDetail:
            return 50.0
        }
    }
    
    private struct CellIdentifier {
        static let UserBig = "DuangTableCellUserBig"
        static let Button = "DuangTableCellButton"
        static let RightDetail = "RightDetail"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row]
        switch row.rowType {
        case DuangTableDataRow.RowType.UserBig:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.UserBig, forIndexPath: indexPath) as DuangTableCellUserBig
            cell.userAvatarImageView.image = UIImage(named: "placeholder_user")
            cell.userNameLabel.text = row.titleString
            return cell
        case DuangTableDataRow.RowType.Button:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Button, forIndexPath: indexPath) as DuangTableCellButton
            return cell
        case DuangTableDataRow.RowType.RightDetail:
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: CellIdentifier.RightDetail)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.text = row.titleString
            cell.detailTextLabel?.text = row.detailString
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let didSelectFunc = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].didSelectFunc
        switch didSelectFunc {
        case DuangTableDataRow.DidSelectFunc.Nothing:
            println("Nothing")
        case let DuangTableDataRow.DidSelectFunc.Arity0(didSelectFuncAction):
            didSelectFuncAction()
        default:
            break
        }
        
    }
    
    // MARK: - Did Select Func
    
    func showEditUser() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DuangTableViewController") as DuangTableViewController
        viewController.tableType = TableType.Profile
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
}
