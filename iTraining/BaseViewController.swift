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
    // MARK: methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Util.colorGreen
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        
    }
    
    func resizeViews() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
