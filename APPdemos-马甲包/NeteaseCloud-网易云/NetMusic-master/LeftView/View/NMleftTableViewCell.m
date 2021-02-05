//
//  NMleftTableViewCell.m
//  XBNetMusic
//
//  Created by 小白 on 15/12/7.
//  Copyright (c) 2015年 小白. All rights reserved.
//

#import "NMleftTableViewCell.h"
#import "UIView+Extension.h"
@implementation NMleftTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"leftTableCell";
    NMleftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NMleftTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
      }
    
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置左标题
//        UISwitch *aSwitch = [[UISwitch alloc] init];
//        self.accessoryView = aSwitch;
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
       // self.detailTextLabel.textAlignment = NSTextAlignmentNatural;
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.detailTextLabel.x = self.detailTextLabel.x - ([UIScreen mainScreen].bounds.size.width - LeftViewWidth);
   // self.detailTextLabel.y = self.detailTextLabel.y + 3;
    
    
    
    self.accessoryView.x = self.accessoryView.x -([UIScreen mainScreen].bounds.size.width - LeftViewWidth);
    //self.detailTextLabel.te
    
}

@end
