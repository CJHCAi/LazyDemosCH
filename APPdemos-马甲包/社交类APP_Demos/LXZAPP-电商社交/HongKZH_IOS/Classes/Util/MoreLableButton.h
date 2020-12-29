//
//  MoreLableButton.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/2.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreLableButton : UIButton
@property(nonatomic,strong)UILabel *timeL;
@property(nonatomic,strong)UILabel *bottomL;
-(void)addButtonTitle:(NSString*)title onterTitle:(NSString *)onTitle;
-(void)addButtonTitleColor:(UIColor*)titleColor onterTitleColor:(UIColor *)onTitleColor;
@end
