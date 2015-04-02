//
//  BaseViewController.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/6/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK:
    // MARK: property
    
    var heightHeader: CGFloat {
        get {
            var height: CGFloat = CGFloat(0.0)
            
            if self.navigationController == nil {
                height = 0.0
            }
            else if self.navigationController!.navigationBarHidden {
                height = heightStatusBar
            }
            else {
                height = self.navigationController!.navigationBar.frame.origin.y + self.navigationController!.navigationBar.frame.size.height
            }
            
            return height
        }
    }
    
    var heightStatusBar: CGFloat {
        get {
            return (self.interfaceOrientation.isPortrait) ? UIApplication.sharedApplication().statusBarFrame.size.height : UIApplication.sharedApplication().statusBarFrame.size.width
        }
    }
    
    private lazy var statusBarView: UIView = {
        
        var view: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.heightStatusBar))
        view.backgroundColor = Utils.colorRed
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        return view
    }()
    
    private lazy var navigationBarView: UIView = {
        
        var frame = CGRectZero
        if self.navigationController != nil {
            frame = self.navigationController!.navigationBar.frame
        }
        var view: UIView = UIView(frame: frame)
        view.backgroundColor = Utils.colorNavigationBar
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        if self.navigationController != nil {
            
            var bottomLine: UIView = UIView(frame: CGRectMake(0, self.navigationController!.navigationBar.frame.size.height - 1, self.navigationController!.navigationBar.frame.size.width, 1))
            bottomLine.backgroundColor = UIColorMakeRGB(red: 229, green: 229, blue: 229)
            bottomLine.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
            view.addSubview(bottomLine)
        }
        
        return view
        }()
    
    // MARK:
    // MARK: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Utils.colorBackground
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Utils.colorRed]
        
        self.title = Utils.stringFromClass(self.classForCoder)
        self.view.addSubview(self.statusBarView)
        self.view.addSubview(self.navigationBarView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        
    }
    
    func resizeViews() {
        self.statusBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.heightStatusBar)
        self.navigationBarView.frame = self.navigationController!.navigationBar.frame;
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.resizeViews()
    }

}
