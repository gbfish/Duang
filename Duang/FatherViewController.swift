//
//  FatherViewController.swift
//  Duang
//
//  Created by David Yu on 15/3/16.
//  Copyright (c) 2015年 David Yu. All rights reserved.
//

import UIKit

class FatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let item = FatherDataItem()
        item.itemType = FatherDataItem.ItemType.Button
        
//        item.buttonAction { () -> () in
//            self.tapAction()
//        }
        
//        item.buttonAction() = tapAction
        
        let fatherDataArray = FatherDataArray()
        fatherDataArray.dataArray.append(item)
        
        fatherData.dataArray.append(fatherDataArray)
        
        
//        let buttonAction = item.buttonAction { () -> () in
//            println("buttonAction")
//        }
    }

    func tapAction() {
        println("tapAction")
    }
    
    // MARK: - TableView Data

    var fatherData = FatherData()
    
    // MARK: - TableView
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fatherData.dataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fatherData.dataArray[section].dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return fatherData.dataArray[indexPath.section].dataArray[indexPath.row].heightForRow
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "FatherCellButton"
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        
        return cell
        /*
        switch editType {
        case EditType.EditCollection:
            if indexPath.section == 0 {
                var cellIdentifier = "TEditViewCellPush"
                var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = editCollectionTitleArray[indexPath.row]
                
                if indexPath.row == 0 {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                    cell.detailTextLabel?.text = editCollectionCollectionName
                } else if indexPath.row == 1 {
                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    cell.detailTextLabel?.text = editCollectionSelectedTopic.topicTitle
                }
                return cell
            } else if indexPath.section == 1 {
                var cell = tableView.dequeueReusableCellWithIdentifier("TEditViewCellButton", forIndexPath: indexPath) as TEditViewCellButton
                cell.buttonLabel.textColor = UIColor.redColor()
                cell.buttonLabel.text = "Delete Collection"
                return cell
            } else {
                return UITableViewCell()
            }
        case EditType.EditTap:
            if indexPath.section == 0 {
                var cellIdentifier = "TEditViewCellPush"
                var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = editTapTitleArray[indexPath.row]
                
                if indexPath.row == 0 {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                    cell.detailTextLabel?.text = editTapTitle
                } else if indexPath.row == 1 {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                    cell.detailTextLabel?.text = editTapDescription
                } else if indexPath.row == 2 {
                    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                    cell.detailTextLabel?.text = editTapSelectedCollection.collectionName
                }
                return cell
            } else if indexPath.section == 1 {
                var cell = tableView.dequeueReusableCellWithIdentifier("TEditViewCellButton", forIndexPath: indexPath) as TEditViewCellButton
                cell.buttonLabel.textColor = UIColor.redColor()
                cell.buttonLabel.text = "Delete Tap"
                return cell
            } else {
                return UITableViewCell()
            }
            
        case EditType.CreateCollection:
            var cellIdentifier = "TEditViewCellPush"
            var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            cell.textLabel?.text = createCollectionTitleArray[indexPath.row]
            
            if indexPath.row == 0 {
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.detailTextLabel?.text = createCollectionCollectionName
            } else if indexPath.row == 1 {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.detailTextLabel?.text = createCollectionSelectedTopic.topicTitle
            }
            return cell
            
        case EditType.SelectTopic:
            var cellIdentifier = "TEditViewCellPush"
            var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            cell.textLabel?.text = TData.sharedInstance.topics[indexPath.row].topicTitle
            if selectTopicSelectedTopic.topicId == TData.sharedInstance.topics[indexPath.row].topicId {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        case EditType.SelectCollection:
            if indexPath.section == 0 {
                var cellIdentifier = "TEditViewCellPush"
                var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = TData.sharedInstance.userCollections[indexPath.row].collectionName
                if selectCollectionSelectedCollection.collectionId == TData.sharedInstance.userCollections[indexPath.row].collectionId {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
                return cell
            } else {
                var cell = tableView.dequeueReusableCellWithIdentifier("TEditViewCellButton", forIndexPath: indexPath) as TEditViewCellButton
                cell.buttonLabel.textColor = TData.color(name: TData.ColorName.TapitureBlue)
                cell.buttonLabel.text = "Create New Collection"
                return cell
            }
            
        case EditType.Input:
            tEditViewCellInput = tableView.dequeueReusableCellWithIdentifier("TEditViewCellInput", forIndexPath: indexPath) as TEditViewCellInput
            tEditViewCellInput.delegate = self
            tEditViewCellInput.inputTextView.text = inputText
            return tEditViewCellInput
        }
*/
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        fatherData.dataArray[indexPath.section].dataArray[indexPath.row].buttonAction()
        
        
//        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
//        switch editType {
//        case EditType.EditCollection:
//            if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
//                showInput("Edit Name", text: editCollectionCollectionName)
//            } else if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
//                showSelectTopic()
//            } else if indexPath == NSIndexPath(forRow: 0, inSection: 1) {
//                deleteCollection()
//            }
//        case EditType.EditTap:
//            if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
//                editTapType = EditTapType.Title
//                showInput("Edit Title", text: editTapTitle)
//            } else if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
//                editTapType = EditTapType.Description
//                showInput("Edit Description", text: editTapDescription)
//            } else if indexPath == NSIndexPath(forRow: 2, inSection: 0) {
//                showSelectCollection()
//            } else if indexPath == NSIndexPath(forRow: 0, inSection: 1) {
//                deleteCollection()
//            }
//            
//        case EditType.CreateCollection:
//            if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
//                showInput("Collection Name", text: createCollectionCollectionName)
//            } else if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
//                showSelectTopic()
//            }
//            
//        case EditType.SelectTopic:
//            delegate?.tEditViewControllerSelectedTopic(TData.sharedInstance.topics[indexPath.row])
//            navigationController?.popViewControllerAnimated(true)
//        case EditType.SelectCollection:
//            if indexPath.section == 0 {
//                delegate?.tEditViewControllerSelectedCollection(TData.sharedInstance.userCollections[indexPath.row])
//                navigationController?.popViewControllerAnimated(true)
//            } else {
//                showCreateCollection()
//            }
//            
//        case EditType.Input:
//            println("EditType.Input")
//            
//        }
    }


}
