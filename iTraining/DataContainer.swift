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
    
    static let sharedInstance = DataContainer()
    
    // MARK:
    // MARK: init
    init() {
        self.configDataProvider = ConfigDataProvider()
        self.dataManager = DataManager()
        actionController = ActionController()
    }
    
    // MARK:
    // MARK: property
    var configDataProvider: ConfigDataProvider
    
    var dataManager: DataManager
    
    var actionController: ActionController
    
    // MARK:
    // MARK: methods
    
}
