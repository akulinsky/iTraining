//
//  AlertSelectBreakTime.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/31/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class AlertSelectBreakTime: BaseContextView, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK:
    // MARK: property
    var blockValue: ( (NSTimeInterval) -> () )?
    
    private let arrMinutes: [String] = []
    private let arrSeconds: [String] = []
    
    private var selectIndexMinute: Int = 0
    private var selectIndexSecond: Int = 30 / 5
    
    private var timeInterval: NSTimeInterval = 0
    private var value: NSTimeInterval {
        
        get {
            let min: Int = self.selectIndexMinute * 60
            let sec: Int = self.selectIndexSecond * 5
            self.timeInterval = NSTimeInterval(min + sec)
            
            return self.timeInterval
        }
        
        set {
            
            let min: Int = Int(newValue) / 60
            let sec: Int = Int(newValue) % 60
            self.selectIndexMinute = min
            self.selectIndexSecond = sec / 5
            
            self.timeInterval = newValue
        }
    }
    
    private lazy var pickerView: UIPickerView = {
        
        var picker: UIPickerView = UIPickerView(frame: CGRectZero)
        picker.delegate = self
        return picker
        }()
    
    private lazy var lblComma: UILabel = {
        
        let label: UILabel = UILabel(frame: CGRectZero)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = Utils.colorDarkText
        label.font = UIFont.systemFontOfSize(20)
        label.textAlignment = NSTextAlignment.Center
        label.text = ","
        
        return label
        }()
    
    
    // MARK:
    // MARK: init
    override init(window: UIWindow) {
        
        for index in 0...60 {
            self.arrMinutes.append(index.description)
        }
        
        for var index = 0; index < 60; index += 5 {
            self.arrSeconds.append(index.description)
        }
        
        super.init(window: window)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    // MARK: methods
    override func setup() {
        super.setup()
        
        self.contentView.frame.size = CGSizeMake(self.contentView.frame.width, 260)
        
        self.contentView.addSubview(self.pickerView)
        self.pickerView.addSubview(self.lblComma)
    }
    
    func reloadData() {
        
        self.pickerView.selectRow(self.selectIndexMinute, inComponent: 0, animated: false)
        self.pickerView.selectRow(self.selectIndexSecond, inComponent: 1, animated: false)
    }
    
    override func resize() {
        super.resize()
        
        let width: CGFloat = self.contentView.frame.width
        self.pickerView.frame = CGRectMake((self.contentView.frame.width - width) / 2,
                                            self.separatorView.edgeY + (self.contentView.frame.size.height - self.separatorView.edgeY - self.pickerView.frame.height) / 2,
                                            width, self.pickerView.frame.height)
        
        //width = 5
        self.lblComma.sizeToFit()
        self.lblComma.frame = CGRectMake((self.pickerView.frame.width - self.lblComma.frame.width) / 2, (self.pickerView.frame.height - self.lblComma.frame.height) / 2, self.lblComma.frame.width, self.lblComma.frame.height)
    }
    
    override func willAlertCancel() {
        
        if self.blockValue != nil {
            self.blockValue!(self.value)
        }
    }
    
    class func show(value: NSTimeInterval?, blockValue: ( (value: NSTimeInterval) -> () )) {
        let window: UIWindow = UIApplication.sharedApplication().windows[0] as UIWindow
        var contextView = AlertSelectBreakTime(window: window)
        contextView.blockValue = blockValue
        
        if let oldValue = value {
            contextView.value = oldValue
        }
        contextView.reloadData()
        window.addSubview(contextView)
    }
    
    // MARK:
    // MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            self.selectIndexMinute = row
        }
        else {
            self.selectIndexSecond = row
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return (component == 0) ? self.arrMinutes.count : self.arrSeconds.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString: NSAttributedString?
        if component == 0 {
            attributedString = NSAttributedString(string: self.arrMinutes[row], attributes: [NSForegroundColorAttributeName: Utils.colorDarkText])
        }
        else {
            attributedString = NSAttributedString(string: self.arrSeconds[row], attributes: [NSForegroundColorAttributeName: Utils.colorDarkText])
        }
        
        return attributedString
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        var width: CGFloat = 35
        if component == 1 {
            width = 45
        }
        
        return width
    }
    
}








