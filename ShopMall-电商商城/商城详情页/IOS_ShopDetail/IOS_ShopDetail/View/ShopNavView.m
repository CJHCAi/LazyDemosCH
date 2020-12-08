//
//  ShopNavView.m
//  IOS_ShopDetail
//
//  Created by 苟应航 on 2018/8/21.
//  Copyright © 2018年 GH. All rights reserved.
//

#import "ShopNavView.h"

@implementation ShopNavView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, SafeAreaTopHeight==812.0?-22:0, SCREEN_WIDTH, SafeAreaTopHeight);
        
        UIImageView *shoppingbackicon=[UIImageView new];
        shoppingbackicon.userInteractionEnabled=YES;
        shoppingbackicon.image=GHImage(@"shopBlackBackicon");
        shoppingbackicon.tag=100;
        UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backviewcontroller:)];
        
        [shoppingbackicon addGestureRecognizer:taps];
        [self addSubview:shoppingbackicon];
        [shoppingbackicon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*SCALEWITH6);
            make.centerY.mas_equalTo(self.mas_centerY).mas_offset(SCREEN_HEIGHT==812?15:5);
            make.width.height.mas_equalTo(30);
        }];
        
        
        UILabel *leanlabe=[UILabel new];
        leanlabe.font=GHFont(17);
        leanlabe.textAlignment=NSTextAlignmentCenter;
        leanlabe.textColor=Kwhite;
        [self addSubview:leanlabe];
        _titilelabe=leanlabe;
        [leanlabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(140);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(shoppingbackicon.mas_centerY);
            
        }];
        
        
        
        
    }
    return self;
}
-(void)backviewcontroller:(UITapGestureRecognizer *)sender{
    
    [self.viewController.navigationController popViewControllerAnimated:YES];
    
    }

//获取view的controller
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
