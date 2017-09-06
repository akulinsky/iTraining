//
//  MainViewController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/5/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class MainViewController: JASidePanelController {

    // MARK:
    // MARK: property
    
    // MARK:
    // MARK: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func stylePanel(_ panel: UIView!) {
        panel.clipsToBounds = true
    }
    
    override func leftButtonForCenterPanel() -> UIBarButtonItem! {
        let button = super.leftButtonForCenterPanel()
        button?.tintColor = Utils.colorRed
        return button
    }
    
    // MARK:
    // MARK: actions
    
//    func clickBtnSend(button: UIButton) {
//        println("=====");
//        //NSNotificationCenter.defaultCenter().postNotificationName(NotificationCenterEvents.ShowMainScreenEvent, object: nil)
//        
////        let button = UIButton(frame: CGRectMake(0, 0, 100, 60))
////        button.setTitle("Back", forState: UIControlState.Normal)
////        button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
////        button.backgroundColor = UIColor.grayColor()
////        button.addTarget(self, action: "test:", forControlEvents: UIControlEvents.TouchUpInside)
////        
////        let controller = UIViewController()
////        controller.view.backgroundColor = Util.colorRed
////        controller.view.addSubview(button)
////        button.center = controller.view.center
////        self.navigationController?.pushViewController(controller, animated: true)
//    }
//    
//    func test(button: UIButton) {
//        NSNotificationCenter.defaultCenter().postNotificationName(NotificationCenterEvents.ShowMainScreenEvent, object: nil)
//    }

}
