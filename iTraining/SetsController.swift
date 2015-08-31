//
//  SetsController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/31/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit
import CoreData

class SetsController: BaseViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK:
    // MARK: property
    private var fetchedResults: NSFetchedResultsController?
    var exerciseItem: ExerciseItem?
    
    private lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRectMake(0, self.heightHeader, self.view.frame.size.width, self.view.frame.size.height - self.heightHeader), style: UITableViewStyle.Plain)
        object.delegate = self
        object.dataSource = self
        object.backgroundColor = UIColor.clearColor()
        object.separatorStyle = UITableViewCellSeparatorStyle.None
        object.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleWidth
        object.allowsSelectionDuringEditing = true
        object.editing = true
        
        return object
        }()
    
    // MARK:
    // MARK: methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("***ContextMenuView_EditSets", comment:"")
        self.fetchedResults = DataManager.fetchedResultsControllerForSetsItems(exerciseItem: self.exerciseItem)
        self.fetchedResults!.delegate = self
        
        self.view.addSubview(self.tableView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "clickBtnAdd:")
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
    
    private func changePositionItems() {
        
        var sectionInfo = self.fetchedResults!.sections![0] as! NSFetchedResultsSectionInfo
        
        var index = 1
        for item in sectionInfo.objects {
            
            if let obj = item as? SetsItem {
                obj.position = index
                ++index
            }
        }
    }
    
    private func changePositionItems(items: [SetsItem]) {
        
        var index = 0
        for item in items {
            item.position = index
            ++index
        }
    }
    
    // MARK: - Action
    func clickBtnAdd(sender: UIBarButtonItem) {
        
        AlertSetsView.show(nil, reps: nil, blockValue: { (weight, reps) -> () in
            
            var item: SetsItem = DataManager.createItem(nameItem: CoreDataObjectNames.SetsItem) as! SetsItem
            item.weight = weight
            item.reps = reps
            item.exercise = self.exerciseItem!
            item.position = self.fetchedResults!.fetchedObjects!.count
            
            DataManager.save()
        })
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var sectionInfo = self.fetchedResults!.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier) as? SetsCell
        
        if cell == nil {
            cell = SetsCell(style: UITableViewCellStyle.Default, reuseIdentifier: TableViewCell.identifier)
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
        
        if var todos = self.fetchedResults!.fetchedObjects as? [SetsItem] {
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
        
        if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? SetsItem {
            AlertSetsView.show(item.weight.floatValue, reps: item.reps.integerValue, blockValue: { (weight, reps) -> () in
                
                item.weight = weight
                item.reps = reps
                DataManager.save()
            })
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
