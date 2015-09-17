//
//  AlertSelectDateView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/25/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class AlertSelectDateView: UIView {

    // MARK:
    // MARK: property
    private let windowObj: UIWindow
    var blockSelectDate: ( (NSDate) -> () )?
    
    private lazy var backgroundView: UIView = {
        
        var view: UIView = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.3
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
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
        
        return view
        }()
    
    private lazy var separatorView: UIView = {
        
        var view: UIView = UIView(frame: CGRectMake(0, self.btnDone.frame.origin.y + self.btnDone.frame.size.height + 3, self.contentView.frame.size.width, 1))
        view.backgroundColor = UIColorMakeRGB(red: 220, green: 225, blue: 230)
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        return view
        }()
    
    private lazy var btnDone: UIButton = {
        
        let button = UIButton(frame: CGRectMake(self.contentView.frame.size.width - 65, 5, 60, 30))
        button.setTitle(NSLocalizedString("***Done", comment:""), forState: UIControlState.Normal)
        button.setTitleColor(Utils.colorRed, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: "clickBtnDone:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        }()
    
    private lazy var datePicker: UIDatePicker = {
        
        var view: UIDatePicker = UIDatePicker(frame: CGRectZero)
        view.addTarget(self, action: "resultDatePicker:", forControlEvents: UIControlEvents.ValueChanged)
        view.datePickerMode = UIDatePickerMode.Date
        
        return view
        }()
    
    
    
    // MARK:
    // MARK: init
    init(window: UIWindow) {
        self.windowObj = window
        super.init(frame: window.frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
        self.contentView.addSubview(self.btnDone)
        self.contentView.addSubview(self.separatorView)
        self.contentView.addSubview(self.datePicker)
        
        self.transform = CGAffineTransformMakeScale(0.01, 0.01)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransformIdentity
            }) { (finished) -> Void in
                self.backgroundView.hidden = false
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChangeNotification:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = CGRectMake((self.frame.size.width - self.contentView.frame.size.width) / 2, (self.frame.size.height - self.contentView.frame.size.height) / 2,
            self.contentView.frame.size.width, self.contentView.frame.size.height)
        
        self.btnDone.frame = CGRectMake(self.contentView.frame.size.width - 65, 5, 60, 30)
        
        self.datePicker.frame = CGRectMake(10, self.separatorView.frame.origin.y + self.separatorView.frame.size.height + 15, self.contentView.frame.size.width - 20, 50)
    }
    
    class func showDatePicker(mode mode: UIDatePickerMode, date: NSDate?, minDate: NSDate?, maxDate: NSDate?, blockSelectDate: ( (NSDate) -> () ) ) {
        let window: UIWindow = UIApplication.sharedApplication().windows[0] 
        let alertSelectDateView = AlertSelectDateView(window: window)
        alertSelectDateView.blockSelectDate = blockSelectDate
        alertSelectDateView.datePicker.datePickerMode = mode
        
        if let dateTmp = date {
            alertSelectDateView.datePicker.setDate(dateTmp, animated: true)
        }
        if let dateMinTmp = minDate {
            alertSelectDateView.datePicker.minimumDate  = dateMinTmp
        }
        if let dateMaxTmp = maxDate {
            alertSelectDateView.datePicker.maximumDate = dateMaxTmp
        }
        
        window.addSubview(alertSelectDateView)
    }
    
    // MARK:
    // MARK: action
    func clickBtnDone(sender: UIButton) {
        //println("clickBtnCancel")
        
        self.transform = CGAffineTransformIdentity
        self.backgroundView.hidden = true
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
        
        if self.blockSelectDate != nil {
            self.blockSelectDate!(self.datePicker.date)
        }
    }
    
    func resultDatePicker(sender: UIDatePicker) {
        print(sender.date)
    }
    
    // MARK: - Notification
    func deviceOrientationDidChangeNotification(notification: NSNotification) {
        self.frame = self.windowObj.bounds
    }

}




