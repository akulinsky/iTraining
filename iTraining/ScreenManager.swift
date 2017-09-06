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
    
    fileprivate lazy var mainScreen: MainViewController = {
        
        var object: MainViewController = MainViewController()
        object.shouldDelegateAutorotateToVisiblePanel = false
        object.leftFixedWidth = 130
        
        object.leftPanel = self.navigationPanel
        object.centerPanel = self.navigationControllerForViewController(self.trainingListController)
        
        return object
        }()
    
    fileprivate lazy var trainingListController: TrainingListController = {
        
        var object = TrainingListController()
        return object
        }()
    
    fileprivate lazy var navigationPanel: NavigationPanelController = {
        
        var object = NavigationPanelController()
        return object
        }()
    
    var timer: Timer?
    
    // MARK:
    init? (window: UIWindow?)
    {
        super.init()
        if window == nil {
            print("ScreenManager: Error UIWindow == nil")
            return nil
        }
        self.window = window
        self.navigationController = self.window?.rootViewController as? NavigationController;
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.isNavigationBarHidden = true
        
        UIApplication.shared.statusBarStyle = .lightContent
        subscribeToEvents()
        showMainScreenAnimation(false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:
    // MARK: methods
    fileprivate func subscribeToEvents() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ScreenManager.showMainScreenNotification(_:)), name: NSNotification.Name(rawValue: NotificationCenterEvents.ShowMainScreenEvent), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScreenManager.showSettingScreenNotification(_:)), name: NSNotification.Name(rawValue: NotificationCenterEvents.ShowSettingsEvent), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)), name: NSNotification.Name(rawValue: NotificationCenterEvents.AppDidEnterBackgroundEvent), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScreenManager.applicationDidEnterForeground(_:)), name: NSNotification.Name(rawValue: NotificationCenterEvents.AppDidEnterForegroundEvent), object: nil)
    }
    
    fileprivate func showMainScreenAnimation(_ animation: Bool) {
        
        let topViewController = self.navigationController!.topViewController
        let visibleViewController = self.navigationController!.visibleViewController
        
        if topViewController != visibleViewController {
            topViewController!.dismiss(animated: true, completion: nil)
        }
        
        if topViewController != self.mainScreen {
            
            let controllers = self.navigationController!.viewControllers
            var thereMainScreen: Bool = false
            for item in controllers {
                
                let controller: UIViewController? = item
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
    
    fileprivate func showTrainingListScreen(_ animation: Bool) {
        
        self.mainScreen.centerPanel = self.navigationControllerForViewController(self.trainingListController)
    }
    
    fileprivate func navigationControllerForViewController(_ viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigation.navigationBar.shadowImage = UIImage()
        navigation.navigationBar.isTranslucent = true
        
        return navigation
    }
    
    // MARK:
    // MARK: notifications
    func showMainScreenNotification(_ notification: Notification) {
        showMainScreenAnimation(true)
    }
    
    func showSettingScreenNotification(_ notification: Notification) {
        print("showSettingScreenNotification")
    }
    
    func applicationDidEnterBackground(_ notification: Notification) {
        print("applicationDidEnterBackground")
    }
    
    func applicationDidEnterForeground(_ notification: Notification) {
        print("applicationDidEnterForeground")
    }
}












