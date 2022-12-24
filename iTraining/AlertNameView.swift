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
    fileprivate var keyboardNotification: AKKeyboardNotification?
    
    fileprivate var name: String? {
        
        get {
            return self.tvName.text
        }
        
        set {
            self.tvName.text = newValue
        }
    }
    
    fileprivate lazy var substrateUserView: UIView = {
        
        var view: UIView = UIView(frame: CGRect(x: 20, y: self.separatorView.edgeY + (self.contentView.frame.size.height - self.separatorView.edgeY - 60) / 2, width: self.contentView.frame.size.width - 40, height: 50))
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Utils.colorDarkBorder.cgColor
        
        return view
        }()
    
    fileprivate lazy var tvName: UITextField = {
        
        var text = UITextField(frame: CGRect(x: 10, y: 0, width: self.substrateUserView.frame.size.width - 20, height: self.substrateUserView.frame.size.height))
        text.backgroundColor = UIColor.clear
        text.returnKeyType = UIReturnKeyType.done
        //text.autocorrectionType = UITextAutocorrectionType.No
        text.delegate = self
        text.placeholder = NSLocalizedString("***Name", comment:"")
        
        return text
        }()
    
    
    // MARK:
    // MARK: init
    override init(window: UIWindow) {
        
        super.init(window: window)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChangeNotification(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
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
        
        self.contentView.frame = CGRect(x: (self.frame.size.width - self.contentView.frame.size.width) / 2, y: positionContentViewY,
            width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        
        self.substrateUserView.frame = CGRect(x: 20, y: self.separatorView.edgeY + (self.contentView.frame.size.height - self.separatorView.edgeY - 60) / 2, width: self.contentView.frame.size.width - 40, height: 50)
        self.tvName.frame = CGRect(x: 10, y: 0, width: self.substrateUserView.frame.size.width - 20, height: self.substrateUserView.frame.size.height)
    }
    
    override func willAlertCancel() {
        
        if self.blockName != nil &&  self.name != nil {
            self.blockName!(self.name!)
        }
    }
    
    class func show(_ name: String?, blockName: @escaping ( (_ name: String) -> () )) {
        guard let window: UIWindow = UIApplication.shared.keyWindow else {
            fatalError("UIWindow == nil")
        }
        
        let contextView = AlertNameView(window: window)
        contextView.blockName = blockName
        
        if let oldName = name {
            contextView.name = oldName
        }
        
        window.addSubview(contextView)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.cancelView(true)
        return true
    }
    
    // MARK: - Notification
    @objc func deviceOrientationDidChangeNotification(_ notification: Notification) {
        self.frame = self.windowObj.bounds
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        self.keyboardNotification = AKKeyboardNotification(notification)
        
        self.resize()
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        self.keyboardNotification = nil
    }
}
