
//
//  WMZDialog+Select.m
//  WMZDialog
//
//  Created by wmz on 2019/6/20.
//  Copyright © 2019年 wmz. All rights reserved.
//

#import "WMZDialog+Select.h"
@implementation WMZDialog (Select)
- (UIView*)selectAction{

    [self.mainView addSubview:self.titleLabel];
    self.titleLabel.frame = CGRectMake(self.wMainOffsetX, self.wTitle.length?self.wMainOffsetY:0, self.wWidth-self.wMainOffsetX*2, [WMZDialogTool heightForTextView:CGSizeMake(self.wWidth-self.wMainOffsetX*2, CGFLOAT_MAX) WithText:self.titleLabel.text WithFont:self.titleLabel.font.pointSize]);
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY( self.titleLabel.frame)+self.wMainOffsetY, self.wWidth, self.wMainBtnHeight*([self.wData count]>10?10:[self.wData count]));
    [self.mainView addSubview:self.tableView];
    
    [self reSetMainViewFrame:CGRectMake(0, 0, self.wWidth,CGRectGetMaxY(self.tableView.frame))];
    
    return self.mainView;
}

@end
