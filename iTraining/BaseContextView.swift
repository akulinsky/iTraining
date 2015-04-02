//
//  BaseContextView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/31/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class BaseContextView: UIView {

    // MARK:
    // MARK: property
    internal let windowObj: UIWindow
    
    internal lazy var backgroundView: UIView = {
        
        var view: UIView = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.3
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        view.hidden = true
        
        return view
        }()
    
    internal lazy var contentView: UIView = {
        
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
    
    internal lazy var separatorView: UIView = {
        
        var view: UIView = UIView(frame: CGRectMake(0, self.btnDone.frame.origin.y + self.btnDone.frame.size.height + 3, self.contentView.frame.size.width, 1))
        view.backgroundColor = UIColorMakeRGB(red: 220, green: 225, blue: 230)
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        return view
        }()
    
    internal lazy var btnDone: UIButton = {
        
        let button = UIButton(frame: CGRectMake(self.contentView.frame.size.width - 75, 5, 60, 30))
        button.setTitle(NSLocalizedString("***Done", comment:""), forState: UIControlState.Normal)
        button.setTitleColor(Utils.colorRed, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        button.setTitleColor(Utils.colorLightText, forState: UIControlState.Disabled)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: "clickBtnDone:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        }()
    
    internal lazy var btnCancel: UIButton = {
        
        let button = UIButton(frame: CGRectMake(15, 5, 60, 30))
        button.setTitle(NSLocalizedString("***Cancel", comment:""), forState: UIControlState.Normal)
        button.setTitleColor(Utils.colorRed, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: "clickBtnCancel:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
        }()
    
    // MARK:
    // MARK: init
    init(window: UIWindow) {
        self.windowObj = window
        super.init(frame: window.frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    // MARK: methods
    internal func setup() {
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.btnCancel)
        self.contentView.addSubview(self.btnDone)
        self.contentView.addSubview(self.separatorView)
        
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
    
    internal func resize() {
        
        self.contentView.frame = CGRectMake((self.frame.size.width - self.contentView.frame.size.width) / 2, (self.frame.size.height - self.contentView.frame.size.height) / 2,
            self.contentView.frame.size.width, self.contentView.frame.size.height)
        
        self.btnDone.frame = CGRectMake(self.contentView.frame.size.width - 75, 5, 65, 30)
        self.separatorView.frame = CGRectMake(0, self.btnDone.frame.origin.y + self.btnDone.frame.size.height + 3, self.contentView.frame.size.width, 1)
    }
    
    internal func cancelView(isDone: Bool) {
        
        self.transform = CGAffineTransformIdentity
        self.backgroundView.hidden = true
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }) { (finished) -> Void in
                self.removeFromSuperview()
                if isDone {
                    self.willAlertCancel()
                }
        }
    }
    
    internal func willAlertCancel() {
        
    }
    
    class func show() -> BaseContextView {
        let window: UIWindow = UIApplication.sharedApplication().windows[0] as UIWindow
        var contextView = BaseContextView(window: window)
        
        window.addSubview(contextView)
        
        return contextView
    }
    
    // MARK:
    // MARK: action
    func clickBtnDone(sender: UIButton) {
        
        self.cancelView(true)
    }
    
    func clickBtnCancel(sender: UIButton) {
        
        self.cancelView(false)
    }

}
