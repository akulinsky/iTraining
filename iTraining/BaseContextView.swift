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
        view.backgroundColor = UIColor.black
        view.alpha = 0.3
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        view.isHidden = true
        
        return view
        }()
    
    internal lazy var contentView: UIView = {
        
        let width: CGFloat = 300
        let height: CGFloat = 200
        
        var view: UIView = UIView(frame: CGRect(x: (self.frame.size.width - width) / 2, y: (self.frame.size.height - height) / 2, width: width, height: height))
        view.backgroundColor = UIColorMakeRGB(red: 250, green: 250, blue: 250)
        view.layer.cornerRadius = 5.0
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        
        return view
        }()
    
    internal lazy var separatorView: UIView = {
        
        var view: UIView = UIView(frame: CGRect(x: 0, y: self.btnDone.frame.origin.y + self.btnDone.frame.size.height + 3, width: self.contentView.frame.size.width, height: 1))
        view.backgroundColor = UIColorMakeRGB(red: 220, green: 225, blue: 230)
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
        return view
        }()
    
    internal lazy var btnDone: UIButton = {
        
        let button = UIButton(frame: CGRect(x: self.contentView.frame.size.width - 75, y: 5, width: 60, height: 30))
        button.setTitle(NSLocalizedString("***Done", comment:""), for: UIControlState())
        button.setTitleColor(Utils.colorRed, for: UIControlState())
        button.setTitleColor(UIColor.darkGray, for: UIControlState.highlighted)
        button.setTitleColor(Utils.colorLightText, for: UIControlState.disabled)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(BaseContextView.clickBtnDone(_:)), for: UIControlEvents.touchUpInside)
        
        return button
        }()
    
    internal lazy var btnCancel: UIButton = {
        
        let button = UIButton(frame: CGRect(x: 15, y: 5, width: 60, height: 30))
        button.setTitle(NSLocalizedString("***Cancel", comment:""), for: UIControlState())
        button.setTitleColor(Utils.colorRed, for: UIControlState())
        button.setTitleColor(UIColor.darkGray, for: UIControlState.highlighted)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(BaseContextView.clickBtnCancel(_:)), for: UIControlEvents.touchUpInside)
        
        return button
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
    
    // MARK:
    // MARK: methods
    internal func setup() {
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.btnCancel)
        self.contentView.addSubview(self.btnDone)
        self.contentView.addSubview(self.separatorView)
        
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
    
    internal func resize() {
        
        self.contentView.frame = CGRect(x: (self.frame.size.width - self.contentView.frame.size.width) / 2, y: (self.frame.size.height - self.contentView.frame.size.height) / 2,
            width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        
        self.btnDone.frame = CGRect(x: self.contentView.frame.size.width - 75, y: 5, width: 65, height: 30)
        self.separatorView.frame = CGRect(x: 0, y: self.btnDone.frame.origin.y + self.btnDone.frame.size.height + 3, width: self.contentView.frame.size.width, height: 1)
    }
    
    internal func cancelView(_ isDone: Bool) {
        
        self.transform = CGAffineTransform.identity
        self.backgroundView.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
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
        let window: UIWindow = UIApplication.shared.windows[0] 
        let contextView = BaseContextView(window: window)
        
        window.addSubview(contextView)
        
        return contextView
    }
    
    // MARK:
    // MARK: action
    func clickBtnDone(_ sender: UIButton) {
        
        self.cancelView(true)
    }
    
    func clickBtnCancel(_ sender: UIButton) {
        
        self.cancelView(false)
    }

}
