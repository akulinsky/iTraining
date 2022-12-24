//
//  BaseCell.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/27/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

    // MARK:
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        self.textLabel!.textColor = Utils.colorDarkText
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        self.addSubview(self.bottomLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    // MARK: property
    lazy var bottomLine: UIView = {
        var line = UIView(frame: CGRect.zero)
        line.backgroundColor = Utils.colorLightBorder
        return line
    }()
    
    // MARK:
    // MARK: methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bottomLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
    }
    
    func setData(_ data: AnyObject) {
        
    }

}
