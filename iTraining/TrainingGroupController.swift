//
//  TrainingGroupController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit
import CoreData

class TrainingGroupController: BaseViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK:
    // MARK: property
    private var fetchedResults: NSFetchedResultsController?
    var trainingItem: TrainingItem?
    
    private lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRectMake(0, self.heightHeader, self.view.frame.size.width, self.view.frame.size.height - self.heightHeader), style: UITableViewStyle.Plain)
        object.delegate = self
        object.dataSource = self
        object.backgroundColor = UIColor.clearColor()
        object.separatorStyle = UITableViewCellSeparatorStyle.None
        object.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleWidth
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
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("***TrainingGroupController_Title", comment:"")
        self.fetchedResults = DataManager.fetchedResultsControllerForTrainingGroupItems(trainingItem: self.trainingItem)
        //self.fetchedResults = DataManager.fetchedResultsControllerForTrainingGroupItems(trainingItem: nil)
        self.fetchedResults!.delegate = self
        
        self.view.addSubview(self.tableView)
        
        self.showRightBarButton()
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
        
        var sectionInfo = self.fetchedResults!.sections![0] as! NSFetchedResultsSectionInfo
        
        var index = 1
        for item in sectionInfo.objects {
            
            if let obj = item as? TrainingGroupItem {
                obj.position = index
                ++index
            }
        }
    }
    
    private func changePositionItems(items: [TrainingGroupItem]) {
        
        var index = 0
        for item in items {
            item.position = index
            ++index
        }
    }
    
    // MARK: - Action
    func clickBtnOption(sender: UIButton) {
        
        let items = [NSLocalizedString("***ContextMenuView_Edit", comment:""),
            NSLocalizedString("***ContextMenuView_NewTrainingGroup", comment:"")]
        
        ContextMenuView.show(items, blockSelectItem: { (index, item) -> () in
            if index == 0 {
                self.tableView.setEditing(true, animated: true)
                self.showRightBarButton()
            }
            if index == 1 {
                
                AlertNameView.show(nil, blockName: { (name) -> () in
                    if !name.isEmpty {
                        //self.changePositionItems()
                        var item: TrainingGroupItem = DataManager.createItem(nameItem: CoreDataObjectNames.TrainingGroupItem) as! TrainingGroupItem
                        item.title = name
                        if let trainingItem = self.trainingItem {
                            item.training = trainingItem
                        }
                        item.position = self.fetchedResults!.fetchedObjects!.count
                        
                        DataManager.save()
                    }
                })
            }
        })
    }
    
    func clickBtnDone(sender: UIBarButtonItem) {
        self.tableView.setEditing(false, animated: true)
        self.showRightBarButton()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionInfo = self.fetchedResults!.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier) as? TrainingGroupCell
        
        if cell == nil {
            cell = TrainingGroupCell(style: UITableViewCellStyle.Default, reuseIdentifier: TableViewCell.identifier)
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
        
        if var todos = self.fetchedResults!.fetchedObjects as? [TrainingGroupItem] {
            let todo = todos[sourceIndexPath.row]
            todos.removeAtIndex(sourceIndexPath.row)
            todos.insert(todo, atIndex: destinationIndexPath.row)
            
            self.changePositionItems(todos)
            
            DataManager.save()
        }
        
        isMovingItem = false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            DataManager.removeItem(self.fetchedResults!.objectAtIndexPath(indexPath) as! NSManagedObject)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true)
        
        if self.tableView.editing {
            if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? TrainingGroupItem {
                AlertNameView.show(item.title, blockName: { (name) -> () in
                    if !name.isEmpty {
                        item.title = name
                        DataManager.save()
                    }
                })
            }
        }
        else {
            let controller = ExerciseListController()
            if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? TrainingGroupItem {
                controller.trainingGroupItem = item
            }
            self.navigationController!.navigationBar.tintColor = Utils.colorRed
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
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TrainingGroupCell{
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




