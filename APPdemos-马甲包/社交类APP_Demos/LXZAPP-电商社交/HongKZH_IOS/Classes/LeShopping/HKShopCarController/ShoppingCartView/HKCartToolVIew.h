//
//  HKCartToolVIew.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKCartToolVIewDelegate <NSObject>

@optional
-(void)selectAllWithIsSelect:(BOOL)isSelect;
-(void)gotoPay;
-(void)deleteVc;
@end
@interface HKCartToolVIew : UIView
@property (nonatomic,weak) id<HKCartToolVIewDelegate> delegate;
@property(nonatomic, assign) BOOL isEdit;
@property(nonatomic, assign) NSInteger price;
@end
