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
    var window: UIWindow? = nil
    var navigationController: NavigationController? = nil
    
    private lazy var mainScreen: MainViewController = {
        
        var object: MainViewController = MainViewController()
        object.shouldDelegateAutorotateToVisiblePanel = false
        object.leftFixedWidth = 130
        
        object.leftPanel = self.navigationPanel
        object.centerPanel = self.navigationControllerForViewController(self.trainingListController)
        
        return object
        }()
    
    private lazy var trainingListController: TrainingListController = {
        
        var object = TrainingListController()
        return object
        }()
    
    private lazy var navigationPanel: NavigationPanelController = {
        
        var object = NavigationPanelController()
        return object
        }()
    
    var timer: NSTimer?
    
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
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = false
        self.navigationController!.navigationBarHidden = true
        
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        subscribeToEvents()
        showMainScreenAnimation(false)
        println("testff")
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
    
    private func showTrainingListScreen(animation: Bool) {
        
        self.mainScreen.centerPanel = self.navigationControllerForViewController(self.trainingListController)
    }
    
    private func navigationControllerForViewController(viewController: UIViewController) -> UINavigationController {
        var navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigation.navigationBar.shadowImage = UIImage()
        navigation.navigationBar.translucent = true
        
        return navigation
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












