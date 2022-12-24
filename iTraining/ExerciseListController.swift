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
    fileprivate var fetchedResults: NSFetchedResultsController<NSFetchRequestResult>?
    var trainingGroupItem: TrainingGroupItem?
    
    let heightTitleCell = 22
    let heightExerciseCell = 44
    
    fileprivate lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRect(x: 0, y: self.heightHeader, width: self.view.frame.size.width, height: self.view.frame.size.height - self.heightHeader), style: UITableView.Style.plain)
        object.delegate = self
        object.dataSource = self
        object.backgroundColor = UIColor.clear
        object.separatorStyle = UITableViewCell.SeparatorStyle.none
        object.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleWidth]
        object.allowsSelectionDuringEditing = true
        
        return object
        }()
    
    fileprivate lazy var btnOption: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        button.setImage(UIImage(named: "dots-hor_red"), for: UIControl.State())
        button.setImage(UIImage(named: "dots-hor"), for: UIControl.State.highlighted)
        button.addTarget(self, action: #selector(clickBtnOption(_:)), for: UIControl.Event.touchUpInside)
        
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
        if self.tableView.isEditing {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target:
                                                                        self, action: #selector(clickBtnDone(_:)))
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.btnOption)
        }
    }
    
    fileprivate func changePositionItems() {
        
        let sectionInfo = self.fetchedResults!.sections![0]
        
        var index = 1
        for item in sectionInfo.objects! {
            
            if let obj = item as? BaseItem {
                obj.position = NSNumber(value: index)
                index += 1
            }
        }
    }
    
    fileprivate func changePositionItems(_ items: [BaseItem]) {
        
        var index = 0
        for item in items {
            item.position = NSNumber(value: index)
            index += 1
        }
    }
    
    // MARK: - Action
    @objc func clickBtnOption(_ sender: UIButton) {
        
        let items = [NSLocalizedString("***ContextMenuView_Edit", comment:""),
            NSLocalizedString("***ContextMenuView_NewExercise", comment:""),
            NSLocalizedString("***ContextMenuView_NewTitleExercise", comment:"")]
        
        ContextMenuView.show(items, blockSelectItem: { (index, item) -> () in
            if index == 0 {
                self.tableView.setEditing(true, animated: true)
                self.showRightBarButton()
                self.tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
            }
            else if index == 1 {
                
                AlertNameView.show(nil, blockName: { (name) -> () in
                    if !name.isEmpty {
                        //self.changePositionItems()
                        let item: ExerciseItem = DataManager.createItem(nameItem: CoreDataObjectNames.ExerciseItem) as! ExerciseItem
                        item.title = name
                        if let trainingGroupItem = self.trainingGroupItem {
                            item.trainingGroup = trainingGroupItem
                        }
                        item.position = NSNumber(value: self.fetchedResults!.fetchedObjects!.count)
                        
                        DataManager.save()
                    }
                })
            }
            else if index == 2 {
                
                AlertNameView.show(nil, blockName: { (name) -> () in
                    if !name.isEmpty {
                        //self.changePositionItems()
                        let item: ExerciseTitle = DataManager.createItem(nameItem: CoreDataObjectNames.ExerciseTitle) as! ExerciseTitle
                        item.title = name
                        if let trainingGroupItem = self.trainingGroupItem {
                            item.trainingGroup = trainingGroupItem
                        }
                        item.position = NSNumber(value: self.fetchedResults!.fetchedObjects!.count)
                        
                        DataManager.save()
                    }
                })
            }
        })
    }
    
    @objc func clickBtnDone(_ sender: UIBarButtonItem) {
        self.tableView.setEditing(false, animated: true)
        self.showRightBarButton()
        self.tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.fade)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResults!.sections![section] 
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let identifierCell = "cell \(indexPath.section) - \(indexPath.row)"
        
        //var cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier) as? BaseCell
        var cell: BaseCell?
        
        if let _ = self.fetchedResults!.fetchedObjects![indexPath.row] as? ExerciseItem {
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? BaseCell
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifierExerciseTitle) as? BaseCell
        }
        
        if cell == nil {
            
            if let _ = self.fetchedResults!.fetchedObjects![indexPath.row] as? ExerciseItem {
                cell = ExerciseListCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCell.identifier)
            }
            else {
                cell = ExerciseTitleCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCell.identifierExerciseTitle)
            }
        }
        
        cell!.setData(self.fetchedResults!.object(at: indexPath))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var heightCell = self.heightTitleCell
        if self.tableView.isEditing {
            heightCell = self.heightExerciseCell
        }
        else if let _ = self.fetchedResults!.fetchedObjects![indexPath.row] as? ExerciseItem {
            heightCell = self.heightExerciseCell
        }
        
        return CGFloat(heightCell)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if tableView.isEditing {
            return true
        }
        else if let _ = self.fetchedResults!.fetchedObjects![indexPath.row] as? ExerciseItem {
            return true
        }
        return false
    }
    
    var isMovingItem: Bool = false
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        isMovingItem = true
        
        if var todos = self.fetchedResults!.fetchedObjects as? [BaseItem] {
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
        
        if self.tableView.isEditing {
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
            if let item = self.fetchedResults!.fetchedObjects![indexPath.row] as? ExerciseItem {
                let controller = ExerciseController()
                controller.exerciseItem = item
                self.navigationController?.navigationBar.tintColor = Utils.colorRed
                self.navigationController!.pushViewController(controller, animated: true)
            }
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




