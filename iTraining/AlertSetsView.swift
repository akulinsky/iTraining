//
//  AlertSetsView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 4/1/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class AlertSetsView: BaseContextView, UITextFieldDelegate {

    // MARK:
    // MARK: property
    var blockValue: ( (Float, Int) -> () )?
    private var keyboardNotification: AKKeyboardNotification?
    
    private var weight: Float? {
        
        get {
            return (self.tfWeight.text as NSString).floatValue
        }
        
        set {
            self.tfWeight.text = newValue!.description
        }
    }
    
    private var reps: Int? {
        
        get {
            return (self.tfReps.text as NSString).integerValue
        }
        
        set {
            self.tfReps.text = newValue!.description
        }
    }
    
    private lazy var substrateWeightView: UIView = {
        
        var view: UIView = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.clearColor()
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Utils.colorDarkBorder.CGColor
        return view
        }()
    
    private lazy var tfWeight: UITextField = {
        
        var text: UITextField = UITextField(frame: CGRectZero)
        text.backgroundColor = UIColor.clearColor()
        text.keyboardType = UIKeyboardType.DecimalPad
        text.delegate = self
        text.placeholder = NSLocalizedString("***Weight", comment:"")
        
        return text
        }()
    
    private lazy var substrateRepsView: UIView = {
        
        var view: UIView = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.clearColor()
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Utils.colorDarkBorder.CGColor
        
        return view
        }()
    
    private lazy var tfReps: UITextField = {
        
        var text: UITextField = UITextField(frame: CGRectZero)
        text.backgroundColor = UIColor.clearColor()
        text.keyboardType = UIKeyboardType.NumberPad
        text.delegate = self
        text.placeholder = NSLocalizedString("***Reps", comment:"")
        
        return text
        }()
    
    private lazy var lblSeparator: UILabel = {
        
        let label: UILabel = UILabel(frame: CGRectZero)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = Utils.colorDarkText
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textAlignment = NSTextAlignment.Center
        label.text = "X"
        label.sizeToFit()
        
        return label
        }()
    
    
    // MARK:
    // MARK: init
    override init(window: UIWindow) {
        
        super.init(window: window)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChangeNotification:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChangeNotification:", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK:
    // MARK: methods
    override func setup() {
        super.setup()
        
        self.contentView.addSubview(self.substrateWeightView)
        self.substrateWeightView.addSubview(self.tfWeight)
        self.contentView.addSubview(self.substrateRepsView)
        self.substrateRepsView.addSubview(self.tfReps)
        self.contentView.addSubview(self.lblSeparator)
        
        self.tfWeight.becomeFirstResponder()
        self.resize()
    }
    
    override func resize() {
        super.resize()
        
        var positionContentViewY = (self.frame.size.height - self.contentView.frame.size.height) / 2
        if self.keyboardNotification != nil {
            let heightKB = self.keyboardNotification!.screenFrameBegin.height
            positionContentViewY = (self.frame.height - heightKB - self.contentView.frame.height) / 2
        }
        
        self.contentView.frame = CGRectMake((self.frame.size.width - self.contentView.frame.size.width) / 2, positionContentViewY,
            self.contentView.frame.size.width, self.contentView.frame.size.height)
        
        let widthSubstrate: CGFloat = 80
        
        self.substrateWeightView.frame = CGRectMake((self.contentView.frame.width - widthSubstrate * 2 - self.lblSeparator.frame.width - 20) / 2,
                                                        self.separatorView.edgeY + (self.contentView.frame.size.height - self.separatorView.edgeY - 60) / 2, widthSubstrate, 50)
        self.tfWeight.frame = CGRectMake(10, 0, self.substrateWeightView.frame.size.width - 20, self.substrateWeightView.frame.size.height)
        
        self.lblSeparator.frame = CGRectMake(self.substrateWeightView.edgeX + 10, self.substrateWeightView.frame.origin.y + (self.substrateWeightView.frame.height - self.lblSeparator.frame.height) / 2,
                                                self.lblSeparator.frame.width, self.lblSeparator.frame.height)
        
        self.substrateRepsView.frame = CGRectMake(self.lblSeparator.edgeX + 10, self.substrateWeightView.frame.origin.y, widthSubstrate, 50)
        self.tfReps.frame = CGRectMake(10, 0, self.substrateRepsView.frame.size.width - 20, self.substrateRepsView.frame.size.height)
    }
    
    override func willAlertCancel() {
        
        if self.blockValue != nil && self.weight != nil && self.reps != nil {
            self.blockValue!(self.weight!, self.reps!)
        }
    }
    
    class func show(weight: Float?, reps: Int?, blockValue: ( (weight: Float, reps: Int) -> () )) {
        let window: UIWindow = UIApplication.sharedApplication().windows[0] as UIWindow
        var contextView = AlertSetsView(window: window)
        contextView.blockValue = blockValue
        
        if let weight = weight {
            contextView.weight = weight
        }
        
        if let reps = reps {
            contextView.reps = reps
        }
        
        contextView.reloadData()
        
        window.addSubview(contextView)
    }
    
    func reloadData() {
        if self.tfWeight.text != nil && self.tfReps.text != nil && (self.tfWeight.text as NSString).floatValue > 0.0 && self.tfReps.text.toInt() > 0 {
            self.btnDone.enabled = true
        }
        else {
            self.btnDone.enabled = false
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.cancelView(true)
        return true
    }
    
    // MARK: - Notification
    func deviceOrientationDidChangeNotification(notification: NSNotification) {
        self.frame = self.windowObj.bounds
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        self.keyboardNotification = AKKeyboardNotification(notification)
        
        self.resize()
    }
    
    func keyboardDidHide(notification: NSNotification) {
        self.keyboardNotification = nil
    }
    
    func textDidChangeNotification(notification: NSNotification) {
        if let textField = notification.object as? UITextField {
            if textField == self.tfWeight || textField == self.tfReps {
                self.reloadData()
            }
        }
    }

}
