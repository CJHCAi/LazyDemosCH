//
//  HKCityHomeHeadView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityMainRespone.h"
@protocol HKCityHomeHeadViewDelegate <NSObject>

@optional
-(void)toVcCity;
-(void)gotoVcLocaWithIsLoc:(int)index;
-(void)gotoSwitchType:(NSInteger)tag;
-(void)gotoPubLish:(NSString *)cityId;
@end
@interface HKCityHomeHeadView : UIView
@property (nonatomic, strong)CityMainRespone *respone;
@property (nonatomic,weak) id<HKCityHomeHeadViewDelegate> delegate;
@end
