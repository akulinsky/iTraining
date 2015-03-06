//
//  Utils.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/5/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class Util {
    
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
    
    // MARK:
    // MARK: Date
    class func dateFromString(strDate: String) -> NSDate? {
        if strDate.isEmpty {
            return nil
        }
        
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "US")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        var date: NSDate? = df.dateFromString(strDate)
        if date == nil {
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = df.dateFromString(strDate)
        }
        
        return date
    }
    
    class func stringFromDate(date: NSDate?, format: String) -> String {
        if format.isEmpty || date == nil {
            print("Util stringFromDate error: format.isEmpty || date == nil")
            return ""
        }
        
        let df = NSDateFormatter()
        //df.locale = NSLocale(localeIdentifier: "US")
        df.dateFormat = format
        
        return df.stringFromDate(date!)
    }
    
    // MARK:
}

func UIColorMakeRGBAlpha(#red: Float, #green: Float, #blue: Float, #alpha: Float) -> UIColor {
    var tmp = CGFloat(blue/255.0)
    return UIColor(red: CGFloat(red / 255.0), green: CGFloat(green / 255.0), blue: CGFloat(blue / 255.0), alpha: CGFloat(alpha))
}

func UIColorMakeRGB(#red: Float, #green: Float, #blue: Float) -> UIColor {
    return UIColorMakeRGBAlpha(red: red, green: green, blue: blue, alpha: 1.0)
}

