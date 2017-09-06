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
    fileprivate let cellHeight: CGFloat = 50
    fileprivate let windowObj: UIWindow
    var blockSelectItem: ( (Int, String) -> () )?
    fileprivate var items: [String] = []
    
    fileprivate lazy var backgroundView: UIView = {
       
        var view: UIView = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0.3
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        view.isHidden = true
        
        return view
    }()
    
    fileprivate lazy var contentView: UIView = {
        
        let width: CGFloat = 300
        let height: CGFloat = 250
        
        var view: UIView = UIView(frame: CGRect(x: (self.frame.size.width - width) / 2, y: (self.frame.size.height - height) / 2, width: width, height: height))
        view.backgroundColor = UIColorMakeRGB(red: 250, green: 250, blue: 250)
        view.layer.cornerRadius = 5.0
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        
        return view
        }()
    
    fileprivate lazy var separatorView: UIView = {
        
        var view: UIView = UIView(frame: CGRect(x: 0, y: self.btnCancel.frame.origin.y + self.btnCancel.frame.size.height + 3, width: self.contentView.frame.size.width, height: 1))
        view.backgroundColor = UIColorMakeRGB(red: 220, green: 225, blue: 230)
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
        return view
        }()
    
    fileprivate lazy var btnCancel: UIButton = {
       
        let button = UIButton(frame: CGRect(x: self.contentView.frame.size.width - 75, y: 5, width: 60, height: 30))
        button.setTitle(NSLocalizedString("***Cancel", comment:""), for: UIControlState())
        button.setTitleColor(Utils.colorRed, for: UIControlState())
        button.setTitleColor(UIColor.darkGray, for: UIControlState.highlighted)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(ContextMenuView.clickBtnCancel(_:)), for: UIControlEvents.touchUpInside)
        
        return button
    }()
    
    fileprivate lazy var tableView: UITableView = {
        
        var object: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        //var object: UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        object.delegate = self
        object.dataSource = self
        object.backgroundColor = UIColor.clear
        object.separatorStyle = UITableViewCellSeparatorStyle.none
        object.alwaysBounceVertical = false
        
        return object
        }()
    
    // MARK:
    // MARK: init
    init(window: UIWindow) {
        self.windowObj = window
        super.init(frame: window.frame)
        self.setup()
        NotificationCenter.default.addObserver(self, selector: #selector(ContextMenuView.deviceOrientationDidChangeNotification(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:
    // MARK: methods
    fileprivate func setup() {
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.btnCancel)
        self.contentView.addSubview(self.separatorView)
        self.contentView.addSubview(self.tableView)
        
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform.identity
            }) { (finished) -> Void in
            self.backgroundView.isHidden = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.resize()
    }
    
    func resize() {
        self.contentView.frame = CGRect(x: (self.frame.size.width - self.contentView.frame.size.width) / 2, y: (self.frame.size.height - self.contentView.frame.size.height) / 2,
                                            width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        
        self.btnCancel.frame = CGRect(x: self.contentView.frame.size.width - 75, y: 5, width: 65, height: 30)
        self.separatorView.frame = CGRect(x: 0, y: self.btnCancel.frame.origin.y + self.btnCancel.frame.size.height + 3, width: self.contentView.frame.size.width, height: 1)
        
        self.tableView.frame = CGRect(x: 0, y: self.separatorView.edgeY, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height - self.separatorView.edgeY)
    }
    
    func setItems(_ items: [String]) {
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
    
    func cancelView(index: Int?, itemName: String?) {
        
        self.transform = CGAffineTransform.identity
        self.backgroundView.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }) { (finished) -> Void in
                self.removeFromSuperview()
                
                if self.blockSelectItem != nil && index != nil && itemName != nil {
                    self.blockSelectItem!(index!, itemName!)
                }
        }
    }
    
    class func show(_ items: [String], blockSelectItem: @escaping ( (_ index: Int, _ item: String) -> () )) {
        let window: UIWindow = UIApplication.shared.windows[0] 
        let contextView = ContextMenuView(window: window)
        contextView.blockSelectItem = blockSelectItem
        contextView.setItems(items)
        
        window.addSubview(contextView)
    }
    
    // MARK:
    // MARK: action
    func clickBtnCancel(_ sender: UIButton) {
        
        self.cancelView()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: TableViewCell.identifier)
            cell!.textLabel!.textColor = Utils.colorDarkText
        }
        
        let product = self.items[indexPath.row]
        cell!.textLabel!.text = product
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        
        delay(0.1, closure: { () -> () in
            self.cancelView(index: indexPath.row, itemName: self.items[indexPath.row])
        })
    }
    
    // MARK: - Notification
    func deviceOrientationDidChangeNotification(_ notification: Notification) {
        self.frame = self.windowObj.bounds
    }
}







