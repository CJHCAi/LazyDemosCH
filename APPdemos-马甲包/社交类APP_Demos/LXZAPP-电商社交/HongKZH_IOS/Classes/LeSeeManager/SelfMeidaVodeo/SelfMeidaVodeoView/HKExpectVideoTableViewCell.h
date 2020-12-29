//
//  HKExpectVideoTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/4.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
@protocol HKExpectVideoTableViewCellDelegate <NSObject>

@optional
-(void)updatePlay:(HKPalyStaue)playType;


@end
@interface HKExpectVideoTableViewCell : BaseTableViewCell
@property (nonatomic, copy)NSString *imageStr;
@property (nonatomic, copy)NSString *videoId;
@property (nonatomic,assign) HKPalyStaue playType;
@property (nonatomic,weak) id<HKExpectVideoTableViewCellDelegate> delegate;
@end
