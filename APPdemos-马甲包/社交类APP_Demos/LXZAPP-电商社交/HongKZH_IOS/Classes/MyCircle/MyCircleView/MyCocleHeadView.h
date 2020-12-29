//
//  MyCocleHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKMyCircleData;
@protocol MyCocleHeadViewDelegate <NSObject>

@optional
-(void)toVcheadBtnClick;
-(void)toAddGroup;
-(void)gotoShoppingVc:(NSInteger)tag;
-(void)swichSenderTag:(NSInteger)index;
-(void)pushTopPostWithPostId:(NSString *)postId;
-(void)pushNoticeWithPostId:(NSString *)postId;

@end
@interface MyCocleHeadView : UIView
@property (nonatomic, strong)HKMyCircleData *model;
@property (nonatomic,weak) id<MyCocleHeadViewDelegate> delegate;
@end
