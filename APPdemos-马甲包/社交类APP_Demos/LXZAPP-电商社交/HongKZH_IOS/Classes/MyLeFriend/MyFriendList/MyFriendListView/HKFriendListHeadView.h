//
//  HKFriendListHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKFriendListHeadViewDelegate <NSObject>

-(void)gotoSearch;
-(void)gotoRecommend;
@end
@interface HKFriendListHeadView : UIView
@property (nonatomic,weak) id<HKFriendListHeadViewDelegate> delegate;
@end
