//
//  ExerciseController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/31/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit
import CoreData

class ExerciseController: BaseViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    // MARK:
    // MARK: property
    private var fetchedResults: NSFetchedResultsController?
    var exerciseItem: ExerciseItem?
    
    private lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRectMake(0, self.bottomLineView.edgeY,
                                                self.view.frame.size.width, self.view.frame.size.height - self.bottomLineView.edgeY),
                                                style: UITableViewStyle.Plain)
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
        button.setImage(UIImage(named: "dots-hor_rad"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "dots-hor"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "clickBtnOption:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        }()
    
    private lazy var lblTitle: UILabel = {
       
        let label: UILabel = UILabel(frame: CGRectMake(20, self.heightHeader + 5, self.view.frame.width - 40, 38))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = Utils.colorDarkText
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textAlignment = NSTextAlignment.Left
        label.adjustsFontSizeToFitWidth = true
        label.text = "Empty"
        
        return label
    }()
    
    private lazy var lblBreakTime: UILabel = {
        
        let label: UILabel = UILabel(frame: CGRectMake(20, self.lblTitle.edgeY, self.view.frame.width - 40, 30))
        label.backgroundColor = UIColor.clearColor()
        label.textColor = Utils.colorDarkText
        label.font = UIFont.systemFontOfSize(16)
        label.textAlignment = NSTextAlignment.Left
        label.text = "BreakTime Empty"
        
        return label
        }()
    
    private lazy var btnBeginExercise: UIButton = {
        
        let button: UIButton = UIButton(frame: CGRectMake(20, self.lblBreakTime.edgeY + 10, self.view.frame.width - 40, 50))
        button.setTitle(NSLocalizedString("***ExerciseController_BtnBeginExercise", comment:""), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitleColor(Utils.colorLightText, forState: UIControlState.Highlighted)
        button.addTarget(self, action: "clickBtnBeginExercise:", forControlEvents: UIControlEvents.TouchUpInside)
        button.backgroundColor = Utils.colorGreen
        
        return button
        }()
    
    private lazy var bottomLineView: UIView = {
        
        var bottomLine: UIView = UIView(frame: CGRectMake(0, self.btnBeginExercise.edgeY + 10, self.view.frame.size.width, 1))
        bottomLine.backgroundColor = UIColorMakeRGB(red: 229, green: 229, blue: 229)
        bottomLine.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        return bottomLine
        }()
    
    // MARK:
    // MARK: methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("***ExerciseController_Title", comment:"")
        self.fetchedResults = DataManager.fetchedResultsControllerForSetsItems(exerciseItem: self.exerciseItem)
        self.fetchedResults!.delegate = self
        
        self.view.addSubview(self.lblTitle)
        self.view.addSubview(self.lblBreakTime)
        self.view.addSubview(self.btnBeginExercise)
        self.view.addSubview(self.bottomLineView)
        self.view.addSubview(self.tableView)
        
        self.reloadData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.btnOption)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func reloadData() {
        self.lblTitle.text = self.exerciseItem!.title
        self.setBreakTime()
    }
    
    override func resizeViews() {
        super.resizeViews()
    }
    
    func setBreakTime() {
        
        let min: Int = self.exerciseItem!.breakTime.integerValue / 60
        let sec: Int = self.exerciseItem!.breakTime.integerValue % 60
        let strBreakTime = NSString(format: "%d.%02d", min, sec)
        var str = NSString(format: NSLocalizedString("***ExerciseController_BreakTime", comment:""), strBreakTime)
        self.lblBreakTime.text = NSLocalizedString(str, comment:"")
    }
    
    // MARK: - Action
    func clickBtnOption(sender: UIButton) {
        
        let items = [NSLocalizedString("***ContextMenuView_EditTitleExercise", comment:""),
                        NSLocalizedString("***ContextMenuView_EditBreakTime", comment:""),
                        NSLocalizedString("***ContextMenuView_EditSets", comment:"")]
        
        ContextMenuView.show(items, blockSelectItem: { (index, item) -> () in
            if index == 0 {
                AlertNameView.show(self.exerciseItem!.title, blockName: { (name) -> () in
                    if !name.isEmpty {
                        
                        self.exerciseItem!.title = name
                        DataManager.save()
                        self.reloadData()
                    }
                })
            }
            else if index == 1 {
                AlertSelectBreakTime.show(NSTimeInterval(self.exerciseItem!.breakTime.integerValue), blockValue: { (value) -> () in
                    self.exerciseItem!.breakTime = value
                    DataManager.save()
                    self.reloadData()
                })
            }
            else if index == 2 {
                let controller = SetsController()
                controller.exerciseItem = self.exerciseItem
                self.navigationController!.navigationBar.tintColor = Utils.colorRed
                self.navigationController!.pushViewController(controller, animated: true)
            }
        })
    }
    
    func clickBtnBeginExercise(sender: UIButton) {
        println("clickBtnBeginExercise")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionInfo = self.fetchedResults!.sections![section] as NSFetchedResultsSectionInfo
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
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

}
