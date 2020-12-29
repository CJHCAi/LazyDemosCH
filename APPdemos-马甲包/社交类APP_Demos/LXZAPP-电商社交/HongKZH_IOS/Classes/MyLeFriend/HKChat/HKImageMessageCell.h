//
//  HKImageMessageCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/2.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@protocol HKImageMessageCellDelegate <NSObject,RCMessageCellDelegate>

@optional
- (void)didTapCellPortrait:(NSString *)userId messageCell:(RCImageMessageCell*)cell;

@end
@interface HKImageMessageCell : RCImageMessageCell
@property (nonatomic,weak) id<HKImageMessageCellDelegate> delegate;
@end
