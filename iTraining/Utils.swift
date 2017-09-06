//
//  Utils.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/5/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

class Utils {
    
    // MARK: Style
    class var colorRed: UIColor {
        return UIColorMakeRGB(red: 255, green: 83, blue: 61)
    }
    
    class var colorGreen: UIColor {
        return UIColorMakeRGB(red: 158, green: 182, blue: 107)
    }
    
    class var colorLightGreen: UIColor {
        return UIColorMakeRGB(red: 193, green: 217, blue: 142)
    }
    
    class var colorBlue: UIColor {
        return UIColorMakeRGB(red: 85, green: 169, blue: 206)
    }
    
    class var colorYellow: UIColor {
        return UIColorMakeRGB(red: 255, green: 202, blue: 88)
    }
    
    class var colorDarkText: UIColor {
        return UIColorMakeRGB(red: 65, green: 65, blue: 65)
    }
    
    class var colorLightText: UIColor {
        return UIColorMakeRGB(red: 129, green: 129, blue: 129)
    }
    
    class var colorDarkBorder: UIColor {
        return UIColorMakeRGB(red: 159, green: 159, blue: 159)
    }
    
    class var colorLightBorder: UIColor {
        return UIColorMakeRGB(red: 239, green: 239, blue: 239)
    }
    
    class var colorNavigationBar: UIColor {
        return UIColorMakeRGB(red: 240, green: 240, blue: 240)
    }
    
    class var colorBackground: UIColor {
        return UIColorMakeRGB(red: 250, green: 250, blue: 250)
    }
    
    // MARK:
    // MARK: Date
    class func dateFromString(_ strDate: String) -> Date? {
        if strDate.isEmpty {
            return nil
        }
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "US")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        var date: Date? = df.date(from: strDate)
        if date == nil {
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = df.date(from: strDate)
        }
        
        return date
    }
    
    class func stringFromDate(_ date: Date?, format: String) -> String {
        if format.isEmpty || date == nil {
            print("Util stringFromDate error: format.isEmpty || date == nil", terminator: "")
            return ""
        }
        
        let df = DateFormatter()
        //df.locale = NSLocale(localeIdentifier: "US")
        df.dateFormat = format
        
        return df.string(from: date!)
    }
    
    class func stringFromClass(_ anyClass: AnyClass) -> String {
        let classString = NSStringFromClass(anyClass)
        let classArray:Array<String> = classString.components(separatedBy: ".")
        let className = classArray.last!
        return className
    }
    
    // MARK:
    
    class func interfaceOrientationIsPortrait() -> Bool {
        return UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
    }
}

func UIColorMakeRGBAlpha(red: Float, green: Float, blue: Float, alpha: Float) -> UIColor {
    return UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: CGFloat(alpha))
}

func UIColorMakeRGB(red: Float, green: Float, blue: Float) -> UIColor {
    return UIColorMakeRGBAlpha(red: red, green: green, blue: blue, alpha: 1.0)
}

