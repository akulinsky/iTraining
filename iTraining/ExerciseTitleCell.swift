//
//  TitleViewCell.swift
//  iTraining
//
//  Created by Andrey Kulinskiy on 3/30/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

import UIKit

class ExerciseTitleCell: BaseCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = Utils.colorLightBorder
        self.textLabel!.font = UIFont.boldSystemFontOfSize(16)
        self.textLabel!.textColor = Utils.colorRed
        self.textLabel!.shadowOffset = CGSizeMake(1.0, 1.0)
        self.textLabel!.shadowColor = Utils.colorLightText
        //self.textLabel!.textColor = UIColorMakeRGB(red: 205, green: 92, blue: 92)
        self.accessoryType = UITableViewCellAccessoryType.None
        self.selectionStyle = UITableViewCellSelectionStyle.None
        //self.bottomLine.removeFromSuperview()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func setData(data: AnyObject) {
        
        if let titleItem = data as? ExerciseTitle {
            self.textLabel!.text = titleItem.title
        }
    }
}
