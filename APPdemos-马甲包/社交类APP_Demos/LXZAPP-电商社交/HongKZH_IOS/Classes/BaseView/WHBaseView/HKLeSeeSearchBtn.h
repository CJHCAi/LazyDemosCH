//
//  HKLeSeeSearchBtn.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKLeSeeSearchBtnDelegate <NSObject>

@optional
-(void)gotoSearch;

@end
@interface HKLeSeeSearchBtn : UIView
-(void)setTitle:(NSString*)title isCenter:(BOOL)isCenter backColor:(UIColor*)color cornerRadius:(CGFloat)radius width:(CGFloat)width;
@property (nonatomic,weak) id<HKLeSeeSearchBtnDelegate> delegate;
@property(nonatomic, assign) BOOL isSelect;
@end
