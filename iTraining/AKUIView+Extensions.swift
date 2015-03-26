//
//  AKUIView+Extensions.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/25/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

extension UIView {
    
    var edgeX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    var edgeY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
}
