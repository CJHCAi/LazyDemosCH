//
//  HKMyPostToolVIew.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyPostsRespone.h"
@protocol HKMyPostToolVIewDelegate <NSObject>

@optional
-(void)viewShare;
-(void)viewcommit;
-(void)viewPraise;
@end
@interface HKMyPostToolVIew : UIView
@property (nonatomic, strong)HKMyPostModel *model;
@property (nonatomic,weak) id<HKMyPostToolVIewDelegate> delegate;
@end
