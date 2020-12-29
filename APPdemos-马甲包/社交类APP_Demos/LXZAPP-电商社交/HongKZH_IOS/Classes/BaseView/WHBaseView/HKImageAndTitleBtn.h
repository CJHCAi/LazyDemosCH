//
//  HKImageAndTitleBtn.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKImageAndTitleBtn;
@protocol HKImageAndTitleBtnDelegate <NSObject>

@optional
-(void)btnClick:(HKImageAndTitleBtn*)sender;

@end

@interface HKImageAndTitleBtn : UIView
-(void)setBackColor:(UIColor*)color icon:(NSString*)imageName title:(NSString*)title;
-(void)setBackColorNoYJ:(UIColor*)color icon:(NSString*)imageName title:(NSString*)title;
@property (nonatomic,weak) id<HKImageAndTitleBtnDelegate> delegate;
@end
