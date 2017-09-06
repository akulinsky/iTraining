//
//  AlertSetsView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 4/1/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AlertSetsView: BaseContextView, UITextFieldDelegate {

    // MARK:
    // MARK: property
    var blockValue: ( (Float, Int) -> () )?
    fileprivate var keyboardNotification: AKKeyboardNotification?
    
    fileprivate var weight: Float? {
        
        get {
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            let number: NSNumber? = numberFormatter.number(from: self.tfWeight.text!)
            
            var retVal: Float = 0.0
            if let number = number {
                retVal = number.floatValue
            }
            else {
                retVal = (self.tfWeight.text! as NSString).floatValue
            }
            
            return retVal
        }
        
        set {
            self.tfWeight.text = newValue!.description
        }
    }
    
    fileprivate var reps: Int? {
        
        get {
            return (self.tfReps.text! as NSString).integerValue
        }
        
        set {
            self.tfReps.text = newValue!.description
        }
    }
    
    fileprivate lazy var substrateWeightView: UIView = {
        
        var view: UIView = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Utils.colorDarkBorder.cgColor
        return view
        }()
    
    fileprivate lazy var tfWeight: UITextField = {
        
        var text: UITextField = UITextField(frame: CGRect.zero)
        text.backgroundColor = UIColor.clear
        text.keyboardType = UIKeyboardType.decimalPad
        text.delegate = self
        text.placeholder = NSLocalizedString("***Weight", comment:"")
        
        return text
        }()
    
    fileprivate lazy var substrateRepsView: UIView = {
        
        var view: UIView = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Utils.colorDarkBorder.cgColor
        
        return view
        }()
    
    fileprivate lazy var tfReps: UITextField = {
        
        var text: UITextField = UITextField(frame: CGRect.zero)
        text.backgroundColor = UIColor.clear
        text.keyboardType = UIKeyboardType.numberPad
        text.delegate = self
        text.placeholder = NSLocalizedString("***Reps", comment:"")
        
        return text
        }()
    
    fileprivate lazy var lblSeparator: UILabel = {
        
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.clear
        label.textColor = Utils.colorDarkText
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = NSTextAlignment.center
        label.text = "X"
        label.sizeToFit()
        
        return label
        }()
    
    
    // MARK:
    // MARK: init
    override init(window: UIWindow) {
        
        super.init(window: window)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AlertSetsView.deviceOrientationDidChangeNotification(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlertSetsView.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlertSetsView.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AlertSetsView.textDidChangeNotification(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        self.contentView.frame = CGRect(x: (self.frame.size.width - self.contentView.frame.size.width) / 2, y: positionContentViewY,
            width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        
        let widthSubstrate: CGFloat = 80
        
        self.substrateWeightView.frame = CGRect(x: (self.contentView.frame.width - widthSubstrate * 2 - self.lblSeparator.frame.width - 20) / 2,
                                                        y: self.separatorView.edgeY + (self.contentView.frame.size.height - self.separatorView.edgeY - 60) / 2, width: widthSubstrate, height: 50)
        self.tfWeight.frame = CGRect(x: 10, y: 0, width: self.substrateWeightView.frame.size.width - 20, height: self.substrateWeightView.frame.size.height)
        
        self.lblSeparator.frame = CGRect(x: self.substrateWeightView.edgeX + 10, y: self.substrateWeightView.frame.origin.y + (self.substrateWeightView.frame.height - self.lblSeparator.frame.height) / 2,
                                                width: self.lblSeparator.frame.width, height: self.lblSeparator.frame.height)
        
        self.substrateRepsView.frame = CGRect(x: self.lblSeparator.edgeX + 10, y: self.substrateWeightView.frame.origin.y, width: widthSubstrate, height: 50)
        self.tfReps.frame = CGRect(x: 10, y: 0, width: self.substrateRepsView.frame.size.width - 20, height: self.substrateRepsView.frame.size.height)
    }
    
    override func willAlertCancel() {
        
        if self.blockValue != nil && self.weight != nil && self.reps != nil {
            self.blockValue!(self.weight!, self.reps!)
        }
    }
    
    class func show(_ weight: Float?, reps: Int?, blockValue: @escaping ( (_ weight: Float, _ reps: Int) -> () )) {
        let window: UIWindow = UIApplication.shared.windows[0] 
        let contextView = AlertSetsView(window: window)
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
        if self.tfWeight.text != nil && self.tfReps.text != nil && (self.tfWeight.text! as NSString).floatValue > 0.0 && Int(self.tfReps.text!) > 0 {
            self.btnDone.isEnabled = true
        }
        else {
            self.btnDone.isEnabled = false
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.cancelView(true)
        return true
    }
    
    // MARK: - Notification
    func deviceOrientationDidChangeNotification(_ notification: Notification) {
        self.frame = self.windowObj.bounds
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        self.keyboardNotification = AKKeyboardNotification(notification)
        
        self.resize()
    }
    
    func keyboardDidHide(_ notification: Notification) {
        self.keyboardNotification = nil
    }
    
    func textDidChangeNotification(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if textField == self.tfWeight || textField == self.tfReps {
                self.reloadData()
            }
        }
    }

}
