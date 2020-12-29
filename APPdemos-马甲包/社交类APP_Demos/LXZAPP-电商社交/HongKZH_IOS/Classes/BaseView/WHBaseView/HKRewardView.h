//
//  HKRewardView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKRewardViewDelegate <NSObject>

@optional
-(void)gotoShowedit;
-(void)confirmWithNum:(NSInteger)money;
-(void)hideView;
@end
@interface HKRewardView : UIView
@property (nonatomic,weak) id<HKRewardViewDelegate> delegate;
@end
