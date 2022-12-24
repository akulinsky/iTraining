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
    fileprivate var fetchedResults: NSFetchedResultsController<NSFetchRequestResult>?
    var exerciseItem: ExerciseItem?
    
    fileprivate lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRect(x: 0, y: self.heightHeader, width: self.view.frame.size.width, height: self.view.frame.size.height - self.heightHeader), style: UITableView.Style.plain)
        object.delegate = self
        object.dataSource = self
        object.backgroundColor = UIColor.clear
        object.separatorStyle = UITableViewCell.SeparatorStyle.none
        object.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleWidth]
        object.allowsSelectionDuringEditing = true
        object.isEditing = true
        
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(SetsController.clickBtnAdd(_:)))
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
    
    fileprivate func changePositionItems() {
        
        let sectionInfo = self.fetchedResults!.sections![0] 
        
        var index = 1
        for item in sectionInfo.objects! {
            
            if let obj = item as? SetsItem {
                obj.position = NSNumber(value: index)
                index += 1
            }
        }
    }
    
    fileprivate func changePositionItems(_ items: [SetsItem]) {
        
        var index = 0
        for item in items {
            item.position = NSNumber(value: index)
            index += 1
        }
    }
    
    // MARK: - Action
    @objc func clickBtnAdd(_ sender: UIBarButtonItem) {
        
        AlertSetsView.show(nil, reps: nil, blockValue: { (weight, reps) -> () in
            
            let item: SetsItem = DataManager.createItem(nameItem: CoreDataObjectNames.SetsItem) as! SetsItem
            item.weight = NSNumber(value: weight)
            item.reps = NSNumber(value: reps)
            item.exercise = self.exerciseItem!
            item.position = NSNumber(value: self.fetchedResults!.fetchedObjects!.count)
            
            DataManager.save()
        })
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResults!.sections![section] 
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? SetsCell
        
        if cell == nil {
            cell = SetsCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCell.identifier)
        }
        
        cell!.setData(self.fetchedResults!.object(at: indexPath))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    var isMovingItem: Bool = false
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        isMovingItem = true
        
        if var todos = self.fetchedResults!.fetchedObjects as? [SetsItem] {
            let todo = todos[sourceIndexPath.row]
            todos.remove(at: sourceIndexPath.row)
            todos.insert(todo, at: destinationIndexPath.row)
            
            self.changePositionItems(todos)
            
            DataManager.save()
        }
        
        isMovingItem = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DataManager.removeItem(self.fetchedResults!.object(at: indexPath) as! NSManagedObject)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        
        if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? SetsItem {
            AlertSetsView.show(item.weight.floatValue, reps: item.reps.intValue, blockValue: { (weight, reps) -> () in
                
                item.weight = NSNumber(value: weight)
                item.reps = NSNumber(value: reps)
                DataManager.save()
            })
        }
    }
    
    // MARK:
    // MARK: NSFetchedResultsController Delegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if isMovingItem {
            return
        }
        
        switch type {
            
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tableView.insertRows(at: [newIndexPath], with: UITableView.RowAnimation.fade)
            }
        case .move:
            if let indexPath = indexPath {
                if let newIndexPath = newIndexPath {
                    self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                    self.tableView.insertRows(at: [newIndexPath], with: UITableView.RowAnimation.fade)
                }
            }
        case .update:
            if let indexPath = indexPath {
                if let cell = self.tableView.cellForRow(at: indexPath) as? BaseCell{
                    cell.setData(anObject as AnyObject)
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if isMovingItem {
            return
        }
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if isMovingItem {
            return
        }
        self.tableView.endUpdates()
    }

}
