//
//  HKLevelView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLevelView.h"
#import "UIView+Xib.h"
@interface HKLevelView()
@property (weak, nonatomic) IBOutlet UIImageView *sexImae;
@property (weak, nonatomic) IBOutlet UILabel *levelL;

@end

@implementation HKLevelView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    self.layer.repeatCount = 6;
    self.layer.masksToBounds = YES;
}
-(void)setSex:(int)sex{
    _sex = sex;
    if (sex == 0) {
        self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:131.0/255.0 blue:151.0/255.0 alpha:1];
        self.sexImae.image = [UIImage imageNamed:@"friend_girl"];
    }else{
        self.backgroundColor = [UIColor colorWithRed:131.0/255.0 green:198.0/255.0 blue:255.0/255.0 alpha:1];
        self.sexImae.image = [UIImage imageNamed:@"friend_boy"];
    }
    
}
-(void)setLevel:(int)level{
    _level = level;
    self.levelL.text = [NSString stringWithFormat:@"LV.%d",level];
}
-(void)setSet:(int)sex level:(int)level{
    self.sex = sex;
    self.level = level;
}
@end
