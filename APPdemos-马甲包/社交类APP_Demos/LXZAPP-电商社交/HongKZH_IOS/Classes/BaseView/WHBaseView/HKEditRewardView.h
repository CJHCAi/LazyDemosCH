//
//  HKEditRewardView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKEditRewardViewDelegate <NSObject>

@optional
-(void)gotoLeft;
-(void)confirmWithNum:(NSInteger)money;
-(void)hideView;
@end
@interface HKEditRewardView : UIView
-(void)startEdit;
@property (nonatomic,weak) id<HKEditRewardViewDelegate> delegate;
@end
