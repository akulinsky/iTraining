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
            else if self.navigationController!.isNavigationBarHidden {
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
            
            guard let scene = UIApplication.shared.windowScene else {
                fatalError("windowScene == nil")
            }
            
            return (scene.interfaceOrientation == UIInterfaceOrientation.portrait ||
                    scene.interfaceOrientation == UIInterfaceOrientation.portraitUpsideDown)
            ? scene.statusBarManager!.statusBarFrame.size.height : scene.statusBarManager!.statusBarFrame.size.width
        }
    }
    
    fileprivate lazy var statusBarView: UIView = {
        
        var view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.heightStatusBar))
        view.backgroundColor = Utils.colorRed
        view.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        return view
    }()
    
    fileprivate lazy var navigationBarView: UIView = {
        
        var frame = CGRect.zero
        if self.navigationController != nil {
            frame = self.navigationController!.navigationBar.frame
        }
        var view: UIView = UIView(frame: frame)
        view.backgroundColor = Utils.colorNavigationBar
        view.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        
        if self.navigationController != nil {
            
            var bottomLine: UIView = UIView(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.size.height - 1, width: self.navigationController!.navigationBar.frame.size.width, height: 1))
            bottomLine.backgroundColor = UIColorMakeRGB(red: 229, green: 229, blue: 229)
            bottomLine.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleTopMargin]
            view.addSubview(bottomLine)
        }
        
        return view
        }()
    
    // MARK:
    // MARK: methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Utils.colorBackground
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:Utils.colorRed]
        
        self.title = Utils.stringFromClass(self.classForCoder)
        self.view.addSubview(self.statusBarView)
        self.view.addSubview(self.navigationBarView)
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(100)) {
//            self.view.addSubview(self.statusBarView)
//            self.view.addSubview(self.navigationBarView)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        
    }
    
    func resizeViews() {
        self.statusBarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.heightStatusBar)
        self.navigationBarView.frame = self.navigationController!.navigationBar.frame;
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.resizeViews()
    }

}
