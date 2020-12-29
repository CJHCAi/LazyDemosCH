//
//  GroupCell.swift
//  StepUp
//
//  Created by syfll on 15/4/23.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var GroupName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    class func createGroupCell() -> GroupCell{
        let cell = (NSBundle.mainBundle().loadNibNamed("GroupCell", owner: self, options: nil) as NSArray).objectAtIndex(0) as! GroupCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
