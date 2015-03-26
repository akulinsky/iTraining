//
//  ContextMenuView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/24/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class ContextMenuView: UIView, UITableViewDataSource, UITableViewDelegate {

    // MARK:
    // MARK: property
    private let cellHeight: CGFloat = 50
    private let windowObj: UIWindow
    var blockSelectItem: ( (Int, String) -> () )?
    private var items: [String] = []
    
    private lazy var backgroundView: UIView = {
       
        var view: UIView = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.3
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        view.hidden = true
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        
        let width: CGFloat = 300
        let height: CGFloat = 250
        
        var view: UIView = UIView(frame: CGRectMake((self.frame.size.width - width) / 2, (self.frame.size.height - height) / 2, width, height))
        view.backgroundColor = UIColorMakeRGB(red: 250, green: 250, blue: 250)
        view.layer.cornerRadius = 5.0
        view.layer.borderColor = UIColor.darkGrayColor().CGColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        
        return view
        }()
    
    private lazy var separatorView: UIView = {
        
        var view: UIView = UIView(frame: CGRectMake(0, self.btnCancel.frame.origin.y + self.btnCancel.frame.size.height + 3, self.contentView.frame.size.width, 1))
        view.backgroundColor = UIColorMakeRGB(red: 220, green: 225, blue: 230)
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        return view
        }()
    
    private lazy var btnCancel: UIButton = {
       
        let button = UIButton(frame: CGRectMake(self.contentView.frame.size.width - 75, 5, 60, 30))
        button.setTitle(NSLocalizedString("***Cancel", comment:""), forState: UIControlState.Normal)
        button.setTitleColor(Utils.colorRed, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: "clickBtnCancel:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        //var object: UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        object.delegate = self
        object.dataSource = self
        object.backgroundColor = UIColor.clearColor()
        object.separatorStyle = UITableViewCellSeparatorStyle.None
        object.alwaysBounceVertical = false
        
        return object
        }()
    
    // MARK:
    // MARK: init
    init(window: UIWindow) {
        self.windowObj = window
        super.init(frame: window.frame)
        self.setup()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChangeNotification:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK:
    // MARK: methods
    private func setup() {
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.btnCancel)
        self.contentView.addSubview(self.separatorView)
        self.contentView.addSubview(self.tableView)
        
        self.transform = CGAffineTransformMakeScale(0.01, 0.01)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransformIdentity
            }) { (finished) -> Void in
            self.backgroundView.hidden = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.resize()
    }
    
    func resize() {
        self.contentView.frame = CGRectMake((self.frame.size.width - self.contentView.frame.size.width) / 2, (self.frame.size.height - self.contentView.frame.size.height) / 2,
                                            self.contentView.frame.size.width, self.contentView.frame.size.height)
        
        self.btnCancel.frame = CGRectMake(self.contentView.frame.size.width - 75, 5, 65, 30)
        self.separatorView.frame = CGRectMake(0, self.btnCancel.frame.origin.y + self.btnCancel.frame.size.height + 3, self.contentView.frame.size.width, 1)
        
        self.tableView.frame = CGRectMake(0, self.separatorView.edgeY, self.contentView.frame.size.width, self.contentView.frame.size.height - self.separatorView.edgeY)
    }
    
    func setItems(items: [String]) {
        self.items = items
        var height = self.separatorView.edgeY + (self.cellHeight * CGFloat(items.count))
        
        if height > self.frame.size.height - 100 {
            height = self.frame.size.height - 100
        }
        
        self.contentView.frame.size.height = height
        
        self.tableView.reloadData()
    }
    
    func cancelView() {
        self.cancelView(index: nil, itemName: nil)
    }
    
    func cancelView(#index: Int?, itemName: String?) {
        
        self.transform = CGAffineTransformIdentity
        self.backgroundView.hidden = true
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }) { (finished) -> Void in
                self.removeFromSuperview()
                
                if self.blockSelectItem != nil && index != nil && itemName != nil {
                    self.blockSelectItem!(index!, itemName!)
                }
        }
    }
    
    class func show(items: [String], blockSelectItem: ( (index: Int, item: String) -> () )) {
        let window: UIWindow = UIApplication.sharedApplication().windows[0] as UIWindow
        var contextView = ContextMenuView(window: window)
        contextView.blockSelectItem = blockSelectItem
        contextView.setItems(items)
        
        window.addSubview(contextView)
    }
    
    // MARK:
    // MARK: action
    func clickBtnCancel(sender: UIButton) {
        
        self.cancelView()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(TableViewCell.identifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: TableViewCell.identifier)
            cell!.textLabel!.textColor = Utils.colorDarkText
        }
        
        let product = self.items[indexPath.row]
        cell!.textLabel!.text = product
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: true)
        
        delay(0.1, { () -> () in
            self.cancelView(index: indexPath.row, itemName: self.items[indexPath.row])
        })
    }
    
    // MARK: - Notification
    func deviceOrientationDidChangeNotification(notification: NSNotification) {
        self.frame = self.windowObj.bounds
    }
}







