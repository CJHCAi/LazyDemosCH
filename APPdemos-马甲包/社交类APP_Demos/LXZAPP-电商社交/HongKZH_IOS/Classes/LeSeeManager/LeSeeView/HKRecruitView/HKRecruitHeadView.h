//
//  HKRecruitHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKSowingRespone;
@protocol HKRecruitHeadViewDelegate <NSObject>

@optional
-(void)switchVc:(NSInteger)tag;
@end
@interface HKRecruitHeadView : UIView
@property (nonatomic, strong)HKSowingRespone *model;
@property (nonatomic,weak) id<HKRecruitHeadViewDelegate> delegate;
@end
