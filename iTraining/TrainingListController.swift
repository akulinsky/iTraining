//
//  TrainingListController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/23/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

class TrainingListController: BaseViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK:
    // MARK: property
    private var fetchedResults: NSFetchedResultsController?
    
    private lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRectMake(0, self.heightHeader, self.view.frame.size.width, self.view.frame.size.height - self.heightHeader), style: UITableViewStyle.Plain)
        object.delegate = self
        object.dataSource = self
        object.backgroundColor = UIColor.clearColor()
        object.separatorStyle = UITableViewCellSeparatorStyle.None
        object.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleWidth]
        object.allowsSelectionDuringEditing = true
        
        return object
        }()
    
    private lazy var btnOption: UIButton = {
       
        let button = UIButton(frame: CGRectMake(0, 0, 30, 40))
        button.setImage(UIImage(named: "dots-hor_red"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "dots-hor"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "clickBtnOption:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    // MARK:
    // MARK: methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("***TrainingListController_Title", comment:"")
        self.fetchedResults = DataManager.fetchedResultsControllerForTrainingItems()
        self.fetchedResults!.delegate = self
        
        self.view.addSubview(self.tableView)
        
        self.showRightBarButton()
        
        self.navigationController?.navigationBar.tintColor = Utils.colorRed
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func reloadData() {
        
    }
    
    override func resizeViews() {
        super.resizeViews()
    }
    
    func showRightBarButton() {
        if self.tableView.editing {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "clickBtnDone:")
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.btnOption)
        }
    }
    
    private func changePositionItems() {
        
        let sectionInfo = self.fetchedResults!.sections![0] 
        
        var index = 1
        for item in sectionInfo.objects! {
            
            if let obj = item as? TrainingItem {
                obj.position = index
                ++index
            }
        }
    }
    
    private func changePositionItems(items: [TrainingItem]) {
        
        var index = 0
        for item in items {
            item.position = index
            ++index
        }
    }
    
    // MARK: - Action
    func clickBtnOption(sender: UIButton) {
        
        let items = [NSLocalizedString("***ContextMenuView_Edit", comment:""),
                     NSLocalizedString("***ContextMenuView_NewTraining", comment:"")]
        
        ContextMenuView.show(items, blockSelectItem: { (index, item) -> () in
            if index == 0 {
                self.tableView.setEditing(true, animated: true)
                self.showRightBarButton()
            }
            if index == 1 {
                
                AlertNameView.show(nil, blockName: { (name) -> () in
                    if !name.isEmpty {
                        //self.changePositionItems()
                        let item: TrainingItem = DataManager.createItem(nameItem: CoreDataObjectNames.TrainingItem) as! TrainingItem
                        item.title = name
                        item.position = self.fetchedResults!.fetchedObjects!.count
                        
                        DataManager.save()
                    }
                })
            }
        })
    }
    
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//        
//        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
//            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "YYYYYYY", reply: { (success, error) -> Void in
//                
//                if error != nil {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        AlertView.showAlert(message: "There was a problem verifying your identity.", cancelFunc: { () -> () in
//                            
//                        })
//                    })
//                    println(error)
//                }
//                
//                if success {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        AlertView.showAlert(message: "You are the device owner!", cancelFunc: { () -> () in
//    
//                        })
//                    })
//                }
//                else {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        AlertView.showAlert(message: "You are not the device owner.", cancelFunc: { () -> () in
//                            
//                        })
//                    })
//                }
//            })
//        }
//        else {
//            AlertView.showAlert(message: "Your device cannot authenticate using TouchID.", cancelFunc: { () -> () in
//                
//            })
//        }
//    }
    
    func clickBtnDone(sender: UIBarButtonItem) {
        self.tableView.setEditing(false, animated: true)
        self.showRightBarButton()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResults!.sections![section] 
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier) as? TrainingListCell
        
        if cell == nil {
            cell = TrainingListCell(style: UITableViewCellStyle.Default, reuseIdentifier: TableViewCell.identifier)
        }
        
        cell!.setData(self.fetchedResults!.objectAtIndexPath(indexPath))
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    var isMovingItem: Bool = false
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        isMovingItem = true
        
        if var todos = self.fetchedResults!.fetchedObjects as? [TrainingItem] {
            let todo = todos[sourceIndexPath.row]
            todos.removeAtIndex(sourceIndexPath.row)
            todos.insert(todo, atIndex: destinationIndexPath.row)
            
            self.changePositionItems(todos)
            
            DataManager.save()
        }
        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            tableView.reloadRowsAtIndexPaths(tableView.indexPathsForVisibleRows()!, withRowAnimation: UITableViewRowAnimation.Fade)
//        })
        
        isMovingItem = false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            DataManager.removeItem(self.fetchedResults!.objectAtIndexPath(indexPath) as! NSManagedObject)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        
        if self.tableView.editing {
            if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? TrainingItem {
                AlertNameView.show(item.title, blockName: { (name) -> () in
                    if !name.isEmpty {
                        item.title = name
                        DataManager.save()
                    }
                })
            }
        }
        else {
            let controller = TrainingGroupController()
            if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? TrainingItem {
                controller.trainingItem = item
            }
            self.navigationController?.navigationBar.tintColor = Utils.colorRed
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    // MARK:
    // MARK: NSFetchedResultsController Delegate
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        if isMovingItem {
            return
        }
        
        switch type {
            
        case .Delete:
            if let indexPath = indexPath {
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            }
        case .Insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        case .Move:
            if let indexPath = indexPath {
                if let newIndexPath = newIndexPath {
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            }
        case .Update:
            if let indexPath = indexPath {
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TrainingListCell{
                    cell.setData(anObject)
                }
            }
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        if isMovingItem {
            return
        }
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if isMovingItem {
            return
        }
        self.tableView.endUpdates()
    }

}






