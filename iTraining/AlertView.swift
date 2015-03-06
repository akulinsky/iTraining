//
//  AlertView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/5/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class AlertView: NSObject, UIAlertViewDelegate {
    
    var cancelFunc: ( () -> () )?
    var okFunc: ( () -> () )?
    var alertView: UIAlertView?
    
    // MARK:
    // MARK: sharedInstance
    class var sharedInstance: AlertView {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AlertView? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AlertView()
        }
        return Static.instance!
    }
    
    // MARK:
    override init() {
        super.init()
    }
    
    // MARK:
    // MARK: Methods
    class func showAlert(#message: String, cancelFunc: ( () -> () )) {
        
        let alertView = AlertView.sharedInstance
        alertView.alertView = UIAlertView(title: nil, message: message, delegate: alertView, cancelButtonTitle: NSLocalizedString("***Ok", comment:""))
        alertView.cancelFunc = cancelFunc
        alertView.alertView!.show()
    }
    
    class func showAlert(#title: String, message: String, cancelFunc: ( () -> () )) {
        
        let alertView = AlertView.sharedInstance
        alertView.alertView = UIAlertView(title: title, message: message, delegate: alertView, cancelButtonTitle: NSLocalizedString("***Ok", comment:""))
        alertView.cancelFunc = cancelFunc
        alertView.alertView!.show()
    }
    
    class func showAlert(#title: String, message: String, titleCancelButton: String, titleOkButton: String, cancelFunc: ( () -> () ), okFunc: ( () -> () )) {
        
        let alertView = AlertView.sharedInstance
        alertView.alertView = UIAlertView(title: title, message: message, delegate: alertView, cancelButtonTitle: titleCancelButton, otherButtonTitles:titleOkButton)
        alertView.cancelFunc = cancelFunc
        alertView.okFunc = okFunc
        alertView.alertView!.show()
        
//        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: titleCancelButton, style: UIAlertActionStyle.Default) { action in
//            cancelFunc()
//            })
//        alert.addAction(UIAlertAction(title: titleOkButton, style: UIAlertActionStyle.Default) { action in
//            okFunc()
//            })
//
//        UIApplication.sharedApplication().windows[0].rootViewController!!.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func hideAlertView() {
        
        let alertView = AlertView.sharedInstance
        if let alert = alertView.alertView {
            alert.dismissWithClickedButtonIndex(alertView.alertView!.cancelButtonIndex, animated: true)
            alertView.alertView = nil
        }
    }
    
    // MARK:
    // MARK: UIAlertView Delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.cancelButtonIndex == buttonIndex {
            if let fun = self.cancelFunc {
                fun()
            }
        }
        else {
            if let fun = self.okFunc {
                fun()
            }
        }
        self.alertView = nil
    }
}
