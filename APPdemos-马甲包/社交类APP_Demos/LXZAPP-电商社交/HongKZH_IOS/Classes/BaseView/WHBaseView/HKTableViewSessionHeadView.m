//
//  HKTableViewSessionHeadView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTableViewSessionHeadView.h"
@interface HKTableViewSessionHeadView()
@property (nonatomic, strong)UILabel *titleL;
@end

@implementation HKTableViewSessionHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [self addSubview:label];
        UIView*lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        [self addSubview:lineView];
        self.backgroundColor = [UIColor whiteColor];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        self.titleL = label;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.bottom.equalTo(self);
            make.height.mas_equalTo(1);
        }];
      
    }
    return self;
}
-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    self.titleL.text = titleText;
}
@end
