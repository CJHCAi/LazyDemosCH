//
//  MineTableCell.m
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/10.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import "MineTableCell.h"

@implementation MineTableCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)configurePanDelete:(DRCellSlideActionBlock)drCellSlideActionBlock{
    DRCellSlideGestureRecognizer *slideGestureRecognizer = [DRCellSlideGestureRecognizer new];
    

    UIColor *redColor = [UIColor colorWithRed:222/255.0 green:61/255.0 blue:14/255.0 alpha:1];
  
    DRCellSlideAction *triangleAction = [DRCellSlideAction actionForFraction:-0.25];
    triangleAction.icon = [UIImage imageNamed:@"menu_delete"];
    triangleAction.activeBackgroundColor = redColor;

    triangleAction.behavior = DRCellSlideActionPushBehavior;
    triangleAction.didTriggerBlock  = drCellSlideActionBlock;
    
    [slideGestureRecognizer addActions:@[triangleAction]];
    
    [self addGestureRecognizer:slideGestureRecognizer];
}


@end
