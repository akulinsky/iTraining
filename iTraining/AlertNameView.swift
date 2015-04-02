//
//  AlertNameView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/25/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class AlertNameView: BaseContextView, UITextFieldDelegate {
    
    // MARK:
    // MARK: property
    var blockName: ( (String) -> () )?
    private var keyboardNotification: AKKeyboardNotification?
    
    private var name: String? {
        
        get {
            return self.tvName.text
        }
        
        set {
            self.tvName.text = newValue
        }
    }
    
    private lazy var substrateUserView: UIView = {
        
        var view: UIView = UIView(frame: CGRectMake(20, self.separatorView.edgeY + (self.contentView.frame.size.height - self.separatorView.edgeY - 60) / 2, self.contentView.frame.size.width - 40, 50))
        view.backgroundColor = UIColor.clearColor()
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Utils.colorDarkBorder.CGColor
        
        return view
        }()
    
    private lazy var tvName: UITextField = {
        
        var text = UITextField(frame: CGRectMake(10, 0, self.substrateUserView.frame.size.width - 20, self.substrateUserView.frame.size.height))
        text.backgroundColor = UIColor.clearColor()
        text.returnKeyType = UIReturnKeyType.Done
        text.autocorrectionType = UITextAutocorrectionType.No
        text.delegate = self
        text.placeholder = NSLocalizedString("***Name", comment:"")
        
        return text
        }()
    
    
    // MARK:
    // MARK: init
    override init(window: UIWindow) {
        
        super.init(window: window)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChangeNotification:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
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
        
        self.contentView.addSubview(self.substrateUserView)
        self.substrateUserView.addSubview(self.tvName)
        
        self.tvName.becomeFirstResponder()
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
        
        self.substrateUserView.frame = CGRectMake(20, self.separatorView.edgeY + (self.contentView.frame.size.height - self.separatorView.edgeY - 60) / 2, self.contentView.frame.size.width - 40, 50)
        self.tvName.frame = CGRectMake(10, 0, self.substrateUserView.frame.size.width - 20, self.substrateUserView.frame.size.height)
    }
    
    override func willAlertCancel() {
        
        if self.blockName != nil &&  self.name != nil {
            self.blockName!(self.name!)
        }
    }
    
    class func show(name: String?, blockName: ( (name: String) -> () )) {
        let window: UIWindow = UIApplication.sharedApplication().windows[0] as UIWindow
        var contextView = AlertNameView(window: window)
        contextView.blockName = blockName
        
        if let oldName = name {
            contextView.name = oldName
        }
        
        window.addSubview(contextView)
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
}
