//
//  NavigationPanelController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/24/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class NavigationPanelController: BaseViewController {

    // MARK:
    // MARK: property
    
    
    
    // MARK:
    // MARK: methods
    
    
    
    // MARK: - Override Methods
    override func reloadData() {
        
    }
    
    override func resizeViews() {
        super.resizeViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "grayBackground") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
