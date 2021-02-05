//
//  NMleftTableViewCell.h
//  XBNetMusic
//
//  Created by 小白 on 15/12/7.
//  Copyright (c) 2015年 小白. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    NMleftTableViewCellNone = 0,
    NMleftTableViewCellString,
    NMleftTableViewCellImage,
    NMleftTableViewCellSwitch
}NMleftTableViewCellType;


@interface NMleftTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
