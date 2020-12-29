//
//  HKTitleAndImageBtn.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKTitleAndImageBtn;
@protocol HKTitleAndImageBtnDelegate <NSObject>

@optional
-(void)btnClick:(HKTitleAndImageBtn*)sender;
@end

@interface HKTitleAndImageBtn : UIView
-(void)setBackgroundColor:(UIColor *)backgroundColor title:(NSString*)title imageName:(NSString*)imageName;
-(void)setBackgroundColor:(UIColor *)backgroundColor title:(NSString*)title imageName:(NSString*)imageName cornerRadius:(CGFloat)cornerRadius;
@property (nonatomic,weak) id<HKTitleAndImageBtnDelegate> delegate;
@end
