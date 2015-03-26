//
//  AlertNameView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/25/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class AlertNameView: UIView, UITextFieldDelegate {

    // MARK:
    // MARK: property
    private let windowObj: UIWindow
    var blockName: ( (String) -> () )?
    private var name: String = ""
    //private var keyboardSize: CGSize?
    private var keyboardNotification: AKKeyboardNotification?
    
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
        let height: CGFloat = 200
        
        var view: UIView = UIView(frame: CGRectMake((self.frame.size.width - width) / 2, (self.frame.size.height - height) / 2, width, height))
        view.backgroundColor = UIColorMakeRGB(red: 250, green: 250, blue: 250)
        view.layer.cornerRadius = 5.0
        view.layer.borderColor = UIColor.darkGrayColor().CGColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        
        return view
        }()
    
    private lazy var separatorView: UIView = {
        
        var view: UIView = UIView(frame: CGRectMake(0, self.btnDone.frame.origin.y + self.btnDone.frame.size.height + 3, self.contentView.frame.size.width, 1))
        view.backgroundColor = UIColorMakeRGB(red: 220, green: 225, blue: 230)
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        return view
        }()
    
    private lazy var btnDone: UIButton = {
        
        let button = UIButton(frame: CGRectMake(self.contentView.frame.size.width - 75, 5, 60, 30))
        button.setTitle(NSLocalizedString("***Done", comment:""), forState: UIControlState.Normal)
        button.setTitleColor(Utils.colorRed, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: "clickBtnDone:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        }()
    
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
        text.placeholder = "Name"
        
        return text
    }()
    
    // MARK:
    // MARK: init
    init(window: UIWindow) {
        self.windowObj = window
        super.init(frame: window.frame)
        self.setup()
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
    private func setup() {
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.btnDone)
        self.contentView.addSubview(self.separatorView)
        self.contentView.addSubview(self.substrateUserView)
        self.substrateUserView.addSubview(self.tvName)
        
        self.tvName.becomeFirstResponder()
        
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
        
        var positionContentViewY = (self.frame.size.height - self.contentView.frame.size.height) / 2
        if self.keyboardNotification != nil {
            let heightKB = self.keyboardNotification!.screenFrameBegin.height
            positionContentViewY = (self.frame.height - heightKB - self.contentView.frame.height) / 2
        }
        
        self.contentView.frame = CGRectMake((self.frame.size.width - self.contentView.frame.size.width) / 2, positionContentViewY,
            self.contentView.frame.size.width, self.contentView.frame.size.height)
        
        self.btnDone.frame = CGRectMake(self.contentView.frame.size.width - 75, 5, 65, 30)
        self.separatorView.frame = CGRectMake(0, self.btnDone.frame.origin.y + self.btnDone.frame.size.height + 3, self.contentView.frame.size.width, 1)
        
        self.substrateUserView.frame = CGRectMake(20, self.separatorView.edgeY + (self.contentView.frame.size.height - self.separatorView.edgeY - 60) / 2, self.contentView.frame.size.width - 40, 50)
        self.tvName.frame = CGRectMake(10, 0, self.substrateUserView.frame.size.width - 20, self.substrateUserView.frame.size.height)
    }
    
    func cancelView() {
        self.cancelView(name: nil)
    }
    
    func cancelView(#name: String?) {
        
        self.transform = CGAffineTransformIdentity
        self.backgroundView.hidden = true
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }) { (finished) -> Void in
                self.removeFromSuperview()
                
                if self.blockName != nil && name != nil {
                    self.blockName!(name!)
                }
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
    
    // MARK:
    // MARK: action
    func clickBtnDone(sender: UIButton) {
        
        self.cancelView(name: self.tvName.text)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.cancelView(name: self.tvName.text)
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
