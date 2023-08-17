//
//  NotifyView.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 15.08.2023.
//  Copyright © 2023 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class NotifyView: UIView {

    
    fileprivate lazy var lblText: UILabel = {
        
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = NSTextAlignment.center
        label.text = ""
        label.sizeToFit()
        
        return label
    }()
    
    let text: String
    
    let content: UIView
    
    init(text: String, onView: UIView, topOffset: CGFloat) {
        self.text = text
        self.content = onView
        
        super.init(frame: CGRect(x: 0, y: topOffset, width: onView.frame.width, height: 45))
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.backgroundColor = Utils.colorRed
        
        self.addSubview(lblText)
        lblText.translatesAutoresizingMaskIntoConstraints = false
        lblText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lblText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        lblText.text = text
    }
    
    class func show(text: String, onView: UIView, topOffset: CGFloat = 0) {
        let notifyView = NotifyView(text: text, onView: onView, topOffset: topOffset)
        notifyView.alpha = 0.0
        onView.addSubview(notifyView)
        
        // Show
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            notifyView.alpha = 1.0
            }) { (finished) -> Void in

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
                    // Hide
                    UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
                        notifyView.alpha = 0.0
                        }) { (finished) -> Void in
                            notifyView.removeFromSuperview()
                    }
                }
        }
    }
}
