//
//  AKKeyboardNotification.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

public struct AKKeyboardNotification {
   
    let notification: Notification
    let userInfo: NSDictionary
    
    /// Initializer
    ///
    /// - parameter notification: Keyboard-related notification
    public init(_ notification: Notification) {
        self.notification = notification
        if let userInfo = notification.userInfo {
            self.userInfo = userInfo as NSDictionary
        }
        else {
            self.userInfo = NSDictionary()
        }
    }
    
    /// Start frame of the keyboard in screen coordinates
    public var screenFrameBegin: CGRect {
        if let value = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            return value.cgRectValue
        }
        else {
            return CGRect.zero
        }
    }
    
    /// End frame of the keyboard in screen coordinates
    public var screenFrameEnd: CGRect {
        if let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue
        }
        else {
            return CGRect.zero
        }
    }
    
    /// Keyboard animation duration
    public var animationDuration: Double {
        if let number = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            return number.doubleValue
        }
        else {
            return 0.25
        }
    }
    
    /// Keyboard animation curve
    ///
    /// Note that the value returned by this method may not correspond to a
    /// UIViewAnimationCurve enum value.  For example, in iOS 7 and iOS 8,
    /// this returns the value 7.
    public var animationCurve: Int {
        if let number = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            return number.intValue
        }
        return UIViewAnimationCurve.easeInOut.rawValue
    }
    
    /// Start frame of the keyboard in coordinates of specified view
    ///
    /// - parameter view: UIView to whose coordinate system the frame will be converted
    /// - returns: frame rectangle in view's coordinate system
    public func frameBeginForView(_ view: UIView) -> CGRect {
        return view.convert(screenFrameBegin, from: view.window)
    }
    
    /// Start frame of the keyboard in coordinates of specified view
    ///
    /// - parameter view: UIView to whose coordinate system the frame will be converted
    /// - returns: frame rectangle in view's coordinate system
    public func frameEndForView(_ view: UIView) -> CGRect {
        return view.convert(screenFrameEnd, from: view.window)
    }
}
