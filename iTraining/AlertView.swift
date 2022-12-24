//
//  AlertView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/5/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class AlertView: NSObject, UIAlertViewDelegate {
    
    var alertView: UIAlertController?
    
    static let sharedInstance = AlertView()
    
    // MARK:
    override init() {
        super.init()
    }
    
    // MARK:
    // MARK: Methods
    class func showAlert(message: String, cancelFunc: @escaping ( () -> () )) {
        
        let alertView = AlertView.sharedInstance
        alertView.alertView = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alertView.alertView!.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in cancelFunc() }))
        if let controller = AlertView.topViewController() {
            controller.navigationController!.present(alertView.alertView!, animated: true, completion: nil)
        }
        else {
            print("AlertView ERROR: topViewController == nil")
        }
    }
    
    class func showAlert(message: String, titleCancelButton: String, cancelFunc: @escaping ( () -> () )) {
        
        let alertView = AlertView.sharedInstance
        alertView.alertView = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alertView.alertView!.addAction(UIAlertAction(title: titleCancelButton, style: UIAlertAction.Style.cancel, handler: { action in cancelFunc() }))
        if let controller = AlertView.topViewController() {
            controller.navigationController!.present(alertView.alertView!, animated: true, completion: nil)
        }
        else {
            print("AlertView ERROR: topViewController == nil")
        }
    }
    
    class func showAlert(title: String, message: String, cancelFunc: @escaping ( () -> () )) {
        
        let alertView = AlertView.sharedInstance
        alertView.alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertView.alertView!.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in cancelFunc() }))
        if let controller = AlertView.topViewController() {
            controller.navigationController!.present(alertView.alertView!, animated: true, completion: nil)
        }
        else {
            print("AlertView ERROR: topViewController == nil")
        }
    }
    
    class func showAlert(title: String?, message: String, titleCancelButton: String, titleOkButton: String, cancelFunc: @escaping ( () -> () ), okFunc: @escaping ( () -> () )) {
        
        let alertView = AlertView.sharedInstance
        alertView.alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertView.alertView!.addAction(UIAlertAction(title: titleCancelButton, style: UIAlertAction.Style.cancel, handler: { action in cancelFunc() }))
        alertView.alertView!.addAction(UIAlertAction(title: titleOkButton, style: UIAlertAction.Style.default, handler: { acrion in okFunc() }))
        if let controller = AlertView.topViewController() {
            controller.navigationController!.present(alertView.alertView!, animated: true, completion: nil)
        }
        else {
            print("AlertView ERROR: topViewController == nil")
        }
    }
    
    class func showAlert(title: String?, message: String, titleCancelButton: String, titleButton1: String, titleButton2: String,
                         cancelFunc: @escaping ( () -> () ), button1Func: @escaping ( () -> () ), button2Func: @escaping ( () -> () )) {
        
        let alertView = AlertView.sharedInstance
        alertView.alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertView.alertView!.addAction(UIAlertAction(title: titleCancelButton, style: UIAlertAction.Style.cancel, handler: { action in cancelFunc() }))
        alertView.alertView!.addAction(UIAlertAction(title: titleButton1, style: UIAlertAction.Style.default, handler: { acrion in button1Func() }))
        alertView.alertView!.addAction(UIAlertAction(title: titleButton2, style: UIAlertAction.Style.default, handler: { acrion in button2Func() }))
        if let controller = AlertView.topViewController() {
            controller.navigationController!.present(alertView.alertView!, animated: true, completion: nil)
        }
        else {
            print("AlertView ERROR: topViewController == nil")
        }
    }
    
    class func showAlertPincode(message: String, titleCancelButton: String, titleOkButton: String, cancelFunc: @escaping () -> (), okFunc: @escaping (_ pincode: String?) -> () ) {
        /*
         let alertView = AlertView.sharedInstance
         alertView.alertView = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
         alertView.alertView!.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in cancelFunc() }))
         */
        let alertView = AlertView.sharedInstance
        
        var inputTextField: UITextField?
        alertView.alertView = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alertView.alertView!.addAction(UIAlertAction(title: titleCancelButton, style: UIAlertAction.Style.default, handler: { action in cancelFunc() }))
        alertView.alertView!.addAction(UIAlertAction(title: titleOkButton, style: UIAlertAction.Style.default, handler: { (action) -> Void in
            okFunc(inputTextField?.text)
        }))
        alertView.alertView!.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Pincode"
            textField.isSecureTextEntry = true
            inputTextField = textField
        })
        
        if let controller = AlertView.topViewController() {
            controller.navigationController!.present(alertView.alertView!, animated: true, completion: nil)
        }
        else {
            print("AlertView ERROR: topViewController == nil")
        }
    }
    
    class func hideAlertView() {
        
        let alertView = AlertView.sharedInstance
        if let alert = alertView.alertView {
            alert.dismiss(animated: true, completion: nil)
            alertView.alertView = nil
        }
    }
    
    fileprivate class func topViewController() -> UIViewController! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let topViewController = appDelegate.screenManager?.navigationController?.topViewController
        return topViewController
    }
}
