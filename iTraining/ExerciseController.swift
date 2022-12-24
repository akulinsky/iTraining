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
    fileprivate var fetchedResults: NSFetchedResultsController<NSFetchRequestResult>?
    var exerciseItem: ExerciseItem?
    
    fileprivate lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRect(x: 0, y: self.bottomLineView.edgeY,
                                                width: self.view.frame.size.width, height: self.view.frame.size.height - self.bottomLineView.edgeY),
                                              style: UITableView.Style.plain)
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
        button.addTarget(self, action: #selector(ExerciseController.clickBtnOption(_:)), for: UIControl.Event.touchUpInside)
        
        return button
        }()
    
    fileprivate lazy var lblTitle: UILabel = {
       
        let label: UILabel = UILabel(frame: CGRect(x: 20, y: self.heightHeader + 5, width: self.view.frame.width - 40, height: 38))
        label.backgroundColor = UIColor.clear
        label.textColor = Utils.colorDarkText
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = NSTextAlignment.left
        label.adjustsFontSizeToFitWidth = true
        label.text = "Empty"
        
        return label
    }()
    
    fileprivate lazy var lblBreakTime: UILabel = {
        
        let label: UILabel = UILabel(frame: CGRect(x: 20, y: self.lblTitle.edgeY, width: self.view.frame.width - 40, height: 30))
        label.backgroundColor = UIColor.clear
        label.textColor = Utils.colorDarkText
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.left
        label.text = "BreakTime Empty"
        
        return label
        }()
    
    fileprivate lazy var btnBeginExercise: UIButton = {
        
        let button: UIButton = UIButton(frame: CGRect(x: 20, y: self.lblBreakTime.edgeY + 10, width: self.view.frame.width - 40, height: 50))
        button.setTitle(NSLocalizedString("***ExerciseController_BtnBeginExercise", comment:""), for: UIControl.State())
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.setTitleColor(Utils.colorLightText, for: UIControl.State.highlighted)
        button.addTarget(self, action: #selector(clickBtnBeginExercise(_:)), for: UIControl.Event.touchUpInside)
        button.backgroundColor = Utils.colorGreen
        
        return button
        }()
    
    fileprivate lazy var bottomLineView: UIView = {
        
        var bottomLine: UIView = UIView(frame: CGRect(x: 0, y: self.btnBeginExercise.edgeY + 10, width: self.view.frame.size.width, height: 1))
        bottomLine.backgroundColor = UIColorMakeRGB(red: 229, green: 229, blue: 229)
        bottomLine.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleTopMargin]
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
        
        let min: Int = self.exerciseItem!.breakTime.intValue / 60
        let sec: Int = self.exerciseItem!.breakTime.intValue % 60
        let strBreakTime = NSString(format: "%d.%02d", min, sec)
        let str = NSString(format: NSLocalizedString("***ExerciseController_BreakTime", comment:"") as NSString, strBreakTime)
        self.lblBreakTime.text = NSLocalizedString(str as String, comment:"")
    }
    
    // MARK: - Action
    @objc func clickBtnOption(_ sender: UIButton) {
        
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
                AlertSelectBreakTime.show(TimeInterval(self.exerciseItem!.breakTime.intValue), blockValue: { (value) -> () in
                    self.exerciseItem!.breakTime = NSNumber(value: value)
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
    
    @objc func clickBtnBeginExercise(_ sender: UIButton) {
        print("clickBtnBeginExercise")
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
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

}
