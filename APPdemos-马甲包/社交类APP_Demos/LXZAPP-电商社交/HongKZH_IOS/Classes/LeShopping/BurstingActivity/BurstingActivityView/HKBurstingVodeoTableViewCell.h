//
//  HKBurstingVodeoTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@protocol HKBurstingVodeoTableViewCellDelegate <NSObject>

@optional
-(void)aliyunVodPlayerEventFinish:(NSString*)videoId;
@end
@interface HKBurstingVodeoTableViewCell : BaseTableViewCell
@property (nonatomic, strong)NSArray *vodeoArray;

-(void)pausePlay;
-(void)releasePlayer;
@property (nonatomic,weak) id<HKBurstingVodeoTableViewCellDelegate> delegate;
@end
