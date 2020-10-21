
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

     [self.mainView addSubview:self.textLabel];
     self.textLabel.frame =  CGRectMake(self.wMainOffsetX,CGRectGetMaxY(self.titleLabel.frame)+ (self.wMessage.length?self.wMainOffsetY:0), self.wWidth-self.wMainOffsetX*2, [WMZDialogTool heightForTextView:CGSizeMake(self.wWidth-self.wMainOffsetX*2, CGFLOAT_MAX) WithText:self.textLabel.text WithFont:self.textLabel.font.pointSize]);

    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.textLabel.frame)+ (self.wMessage.length||self.wTitle.length?self.wMainOffsetY:0), self.wWidth, self.wCellHeight*([self.wData count]>8?8:[self.wData count]));
    [self.mainView addSubview:self.tableView];
    
    if (self.wMultipleSelection) {
        UIView *view =  [self addBottomView:CGRectGetMaxY(self.tableView.frame)];
        [self reSetMainViewFrame:CGRectMake(0, 0, self.wWidth,CGRectGetMaxY(view.frame))];
        [self.OKBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.OKBtn addTarget:self action:@selector(mySelectAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self reSetMainViewFrame:CGRectMake(0, 0, self.wWidth,CGRectGetMaxY(self.tableView.frame))];
    }

    
    return self.mainView;
}

- (void)mySelectAction:(UIButton*)btn{
    DialogWeakSelf(self)
    [self closeView:^{
        if (weakObject.wEventOKFinish) {
            weakObject.wEventOKFinish(weakObject.selectArr, weakObject.pathArr);
        }
    }];
}

@end
