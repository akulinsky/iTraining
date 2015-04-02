//
//  DataContainer.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class DataContainer {
    
    // MARK:
    // MARK: sharedInstance
    class var sharedInstance: DataContainer {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataContainer? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DataContainer()
        }
        return Static.instance!
    }
    
    // MARK:
    // MARK: init
    init() {
        self.configDataProvider = ConfigDataProvider()
        self.dataManager = DataManager()
    }
    
    // MARK:
    // MARK: property
    var configDataProvider: ConfigDataProvider
    var dataManager: DataManager
    
    // MARK:
    // MARK: methods
    
}
