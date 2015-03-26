//
//  TrainingGroupController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class TrainingGroupController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK:
    // MARK: property
    
    private lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRectMake(0, self.heightHeader, self.view.frame.size.width, self.view.frame.size.height - self.heightHeader), style: UITableViewStyle.Plain)
        object.delegate = self
        object.dataSource = self
        object.backgroundColor = UIColor.clearColor()
        object.separatorStyle = UITableViewCellSeparatorStyle.None
        object.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleWidth
        
        return object
        }()
    
    private var items: Array<String> = []
    
    private lazy var btnOption: UIButton = {
        
        let button = UIButton(frame: CGRectMake(0, 0, 30, 40))
        button.setImage(UIImage(named: "dots-hor_rad"), forState: UIControlState.Normal)
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
        self.view.addSubview(self.tableView)
        
        self.showRightBarButton()
        
        for index in 0...5 {
            self.items.append("item " + String(index))
        }
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
                        self.items.insert(name, atIndex: 0)
                        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                })
            }
        })
        
        //        AlertSelectDateView.showDatePicker(mode: UIDatePickerMode.Time, date: nil, minDate: nil, maxDate: nil) { (newDate) -> () in
        //            println(newDate)
        //        }
    }
    
    func clickBtnDone(sender: UIBarButtonItem) {
        self.tableView.setEditing(false, animated: true)
        self.showRightBarButton()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier) as? TrainingListCell
        
        if cell == nil {
            cell = TrainingListCell(style: UITableViewCellStyle.Default, reuseIdentifier: TableViewCell.identifier)
        }
        
        let product = self.items[indexPath.row]
        cell!.textLabel!.text = product
        
        return cell!
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        var item = self.items[sourceIndexPath.row]
        self.items.removeAtIndex(sourceIndexPath.row)
        self.items.insert(item, atIndex: destinationIndexPath.row)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.items.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true)
    }

}
