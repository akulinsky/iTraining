//
//  ViewController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 2/26/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    // MARK:
    // MARK: property
    
    // MARK:
    // MARK: methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector:  Selector("someSelector"), userInfo: nil, repeats: false)
        
    }
    
    func someSelector() {
        AlertView.showAlert(message: "Hi Alert View") { () -> () in
            print("cancel Alert View", terminator: "")
        }
//        AlertView.showAlert(title: "", message: "dfgdfhdfh", titleCancelButton: "Cancel", titleOkButton: "Send", cancelFunc: { () -> () in
//            print("cancel")
//        }) { () -> () in
//            print("send")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

