//
//  DuangTableViewController.swift
//  Duang
//
//  Created by David Yu on 15/3/17.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class DuangTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableType = TableType.Profile
    }
    
    enum TableType{
        case Profile
    }
    
    var tableType: TableType = TableType.Profile {
        didSet {
            switch tableType {
            case TableType.Profile:
                
                let row = DuangTableDataRow()
                row.rowType = DuangTableDataRow.RowType.Button
                row.didSelectFunc = DuangTableDataRow.DidSelectFunc.Arity0(tapAction)
                
                let section = DuangTableDataSection()
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
    }
    
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
        return duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].heightForRow
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row]
        switch row.rowType {
        case DuangTableDataRow.RowType.Button:
            let cell = tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier, forIndexPath: indexPath) as DuangTableCellButton
            return cell
        case DuangTableDataRow.RowType.RightDetail:
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: row.cellIdentifier)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.text = row.titleString
            cell.detailTextLabel?.text = row.detailString
            return cell
        }
        
        
//        let cellIdentifier = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].cellIdentifier
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
//        
////        var cellIdentifier = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].cellIdentifier
////        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
//        duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].setCell(cell)
//        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let didSelectFunc = duangTableData.sectionArray[indexPath.section].rowArray[indexPath.row].didSelectFunc
        switch didSelectFunc {
        case DuangTableDataRow.DidSelectFunc.Nothing:
            println("Nothing")
        case let DuangTableDataRow.DidSelectFunc.Arity0(fff):
        
            fff()
        default:
            break
        }
        
    }
    
    
}
