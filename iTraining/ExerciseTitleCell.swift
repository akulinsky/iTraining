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
        self.textLabel!.font = UIFont.boldSystemFont(ofSize: 16)
        self.textLabel!.textColor = Utils.colorRed
        self.textLabel!.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.textLabel!.shadowColor = Utils.colorLightText
        //self.textLabel!.textColor = UIColorMakeRGB(red: 205, green: 92, blue: 92)
        self.accessoryType = UITableViewCellAccessoryType.none
        self.selectionStyle = UITableViewCellSelectionStyle.none
        //self.bottomLine.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func setData(_ data: AnyObject) {
        
        if let titleItem = data as? ExerciseTitle {
            self.textLabel!.text = titleItem.title
        }
    }
}
