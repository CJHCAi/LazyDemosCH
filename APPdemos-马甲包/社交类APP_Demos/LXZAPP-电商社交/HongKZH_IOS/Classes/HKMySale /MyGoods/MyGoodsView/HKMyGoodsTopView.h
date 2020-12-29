//
//  HKMyGoodsTopView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMyGoodsViewModel.h"
typedef enum{
    UpDownType_UP = 0,
    UpDownType_Down = 1
} UpDownType;
@protocol HKMyGoodsTopViewDelegate <NSObject>

@optional
-(void)switchUpDownWithType:(UpDownType)type;
-(void)selectOrderWithType:(MYUpperProductOrder)selectOrder;
@end
@interface HKMyGoodsTopView : UIView
@property(nonatomic, assign) MYUpperProductOrder selectOrder;
@property (nonatomic,weak) id<HKMyGoodsTopViewDelegate> delegate;
@end
