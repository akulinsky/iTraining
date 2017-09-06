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
    fileprivate let windowObj: UIWindow
    var blockSelectDate: ( (Date) -> () )?
    
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
        
        return view
        }()
    
    fileprivate lazy var separatorView: UIView = {
        
        var view: UIView = UIView(frame: CGRect(x: 0, y: self.btnDone.frame.origin.y + self.btnDone.frame.size.height + 3, width: self.contentView.frame.size.width, height: 1))
        view.backgroundColor = UIColorMakeRGB(red: 220, green: 225, blue: 230)
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
        return view
        }()
    
    fileprivate lazy var btnDone: UIButton = {
        
        let button = UIButton(frame: CGRect(x: self.contentView.frame.size.width - 65, y: 5, width: 60, height: 30))
        button.setTitle(NSLocalizedString("***Done", comment:""), for: UIControlState())
        button.setTitleColor(Utils.colorRed, for: UIControlState())
        button.setTitleColor(UIColor.darkGray, for: UIControlState.highlighted)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(AlertSelectDateView.clickBtnDone(_:)), for: UIControlEvents.touchUpInside)
        
        return button
        }()
    
    fileprivate lazy var datePicker: UIDatePicker = {
        
        var view: UIDatePicker = UIDatePicker(frame: CGRect.zero)
        view.addTarget(self, action: #selector(AlertSelectDateView.resultDatePicker(_:)), for: UIControlEvents.valueChanged)
        view.datePickerMode = UIDatePickerMode.date
        
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
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:
    // MARK: methods
    fileprivate func setup() {
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.btnDone)
        self.contentView.addSubview(self.separatorView)
        self.contentView.addSubview(self.datePicker)
        
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform.identity
            }) { (finished) -> Void in
                self.backgroundView.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AlertSelectDateView.deviceOrientationDidChangeNotification(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = CGRect(x: (self.frame.size.width - self.contentView.frame.size.width) / 2, y: (self.frame.size.height - self.contentView.frame.size.height) / 2,
            width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        
        self.btnDone.frame = CGRect(x: self.contentView.frame.size.width - 65, y: 5, width: 60, height: 30)
        
        self.datePicker.frame = CGRect(x: 10, y: self.separatorView.frame.origin.y + self.separatorView.frame.size.height + 15, width: self.contentView.frame.size.width - 20, height: 50)
    }
    
    class func showDatePicker(mode: UIDatePickerMode, date: Date?, minDate: Date?, maxDate: Date?, blockSelectDate: @escaping ( (Date) -> () ) ) {
        let window: UIWindow = UIApplication.shared.windows[0] 
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
    func clickBtnDone(_ sender: UIButton) {
        //println("clickBtnCancel")
        
        self.transform = CGAffineTransform.identity
        self.backgroundView.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
        
        if self.blockSelectDate != nil {
            self.blockSelectDate!(self.datePicker.date)
        }
    }
    
    func resultDatePicker(_ sender: UIDatePicker) {
        print(sender.date)
    }
    
    // MARK: - Notification
    func deviceOrientationDidChangeNotification(_ notification: Notification) {
        self.frame = self.windowObj.bounds
    }

}




