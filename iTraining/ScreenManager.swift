//
//  ScreenManager.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 2/27/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

// MARK:

class ScreenManager:NSObject {
    
    // MARK:
    // MARK: property
    let mainScreen = MainViewController ()
    let window: UIWindow?
    let navigationController: NavigationController?
    
    // MARK:
    init? (window: UIWindow?)
    {
        super.init()
        if window == nil {
            println("ScreenManager: Error UIWindow == nil")
            return nil
        }
        self.window = window
        self.navigationController = self.window?.rootViewController as? NavigationController;
        
        subscribeToEvents()
        showMainScreenAnimation(false)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK:
    // MARK: methods
    private func subscribeToEvents() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMainScreenNotification:", name: NotificationCenterEvents.ShowMainScreenEvent, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showSettingScreenNotification:", name: NotificationCenterEvents.ShowSettingsEvent, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterBackground:", name: NotificationCenterEvents.AppDidEnterBackgroundEvent, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidEnterForeground:", name: NotificationCenterEvents.AppDidEnterForegroundEvent, object: nil)
    }
    
    private func showMainScreenAnimation(animation: Bool) {
        
        let topViewController = self.navigationController!.topViewController
        let visibleViewController = self.navigationController!.visibleViewController
        
        if topViewController != visibleViewController {
            topViewController .dismissViewControllerAnimated(true, completion: nil)
        }
        
        if topViewController != self.mainScreen {
            
            let controllers = self.navigationController!.viewControllers
            var thereMainScreen: Bool = false
            for item in controllers {
                
                let controller: UIViewController? = item as? UIViewController
                if controller != nil && controller == self.mainScreen {
                    thereMainScreen = true
                    break
                }
            }
            
            if thereMainScreen {
                self.navigationController!.popToViewController(self.mainScreen, animated: animation)
            }
            else {
                self.navigationController!.pushViewController(self.mainScreen, animated: animation)
            }
        }
    }
    
    // MARK:
    // MARK: notifications
    func showMainScreenNotification(notification: NSNotification) {
        showMainScreenAnimation(true)
    }
    
    func showSettingScreenNotification(notification: NSNotification) {
        println("showSettingScreenNotification")
    }
    
    func applicationDidEnterBackground(notification: NSNotification) {
        println("applicationDidEnterBackground")
    }
    
    func applicationDidEnterForeground(notification: NSNotification) {
        println("applicationDidEnterForeground")
    }
}












