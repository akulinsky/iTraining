//
//  ExerciseListController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit
import CoreData

class ExerciseListController: BaseViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    // MARK:
    // MARK: property
    private var fetchedResults: NSFetchedResultsController?
    var trainingGroupItem: TrainingGroupItem?
    
    let heightTitleCell = 22
    let heightExerciseCell = 44
    
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
        
        self.title = NSLocalizedString("***ExerciseListController_Title", comment:"")
        self.fetchedResults = DataManager.fetchedResultsControllerForExerciseItems(trainingGroupItem: self.trainingGroupItem)
        //self.fetchedResults = DataManager.fetchedResultsControllerForExerciseItems(trainingGroupItem: nil)
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
        
        var sectionInfo = self.fetchedResults!.sections![0] as NSFetchedResultsSectionInfo
        
        var index = 1
        for item in sectionInfo.objects {
            
            if let obj = item as? BaseItem {
                obj.position = index
                ++index
            }
        }
    }
    
    private func changePositionItems(items: [BaseItem]) {
        
        var index = 0
        for item in items {
            item.position = index
            ++index
        }
    }
    
    // MARK: - Action
    func clickBtnOption(sender: UIButton) {
        
        let items = [NSLocalizedString("***ContextMenuView_Edit", comment:""),
            NSLocalizedString("***ContextMenuView_NewExercise", comment:""),
            NSLocalizedString("***ContextMenuView_NewTitleExercise", comment:"")]
        
        ContextMenuView.show(items, blockSelectItem: { (index, item) -> () in
            if index == 0 {
                self.tableView.setEditing(true, animated: true)
                self.showRightBarButton()
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            else if index == 1 {
                
                AlertNameView.show(nil, blockName: { (name) -> () in
                    if !name.isEmpty {
                        //self.changePositionItems()
                        var item: ExerciseItem = DataManager.createItem(nameItem: CoreDataObjectNames.ExerciseItem) as ExerciseItem
                        item.title = name
                        if let trainingGroupItem = self.trainingGroupItem {
                            item.trainingGroup = trainingGroupItem
                        }
                        item.position = self.fetchedResults!.fetchedObjects!.count
                        
                        DataManager.save()
                    }
                })
            }
            else if index == 2 {
                
                AlertNameView.show(nil, blockName: { (name) -> () in
                    if !name.isEmpty {
                        //self.changePositionItems()
                        var item: ExerciseTitle = DataManager.createItem(nameItem: CoreDataObjectNames.ExerciseTitle) as ExerciseTitle
                        item.title = name
                        if let trainingGroupItem = self.trainingGroupItem {
                            item.trainingGroup = trainingGroupItem
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
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionInfo = self.fetchedResults!.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let identifierCell = "cell \(indexPath.section) - \(indexPath.row)"
        
        //var cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier) as? BaseCell
        var cell: BaseCell?
        
        if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? ExerciseItem {
            cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier) as? BaseCell
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifierExerciseTitle) as? BaseCell
        }
        
        if cell == nil {
            
            if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? ExerciseItem {
                cell = ExerciseListCell(style: UITableViewCellStyle.Default, reuseIdentifier: TableViewCell.identifier)
            }
            else {
                cell = ExerciseTitleCell(style: UITableViewCellStyle.Default, reuseIdentifier: TableViewCell.identifierExerciseTitle)
            }
        }
        
        cell!.setData(self.fetchedResults!.objectAtIndexPath(indexPath))
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var heightCell = self.heightTitleCell
        if self.tableView.editing {
            heightCell = self.heightExerciseCell
        }
        else if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? ExerciseItem {
            heightCell = self.heightExerciseCell
        }
        
        return CGFloat(heightCell)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    var isMovingItem: Bool = false
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        isMovingItem = true
        
        if var todos = self.fetchedResults!.fetchedObjects as? [BaseItem] {
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
            DataManager.removeItem(self.fetchedResults!.objectAtIndexPath(indexPath) as NSManagedObject)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true)
        
        if self.tableView.editing {
            if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? BaseItem {
                AlertNameView.show(item.title, blockName: { (name) -> () in
                    if !name.isEmpty {
                        item.title = name
                        DataManager.save()
                    }
                })
            }
        }
        else {
            let controller = ExerciseController()
            if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? ExerciseItem {
                controller.exerciseItem = item
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
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? BaseCell{
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




