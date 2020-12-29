//
//  HKCityItemView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityMainRespone.h"
@protocol HKCityItemViewDelegate <NSObject>

@optional
-(void)clickItem:(NSInteger)index;
@end
@interface HKCityItemView : UIView
@property (nonatomic, strong)CityMainHostModel *model;
@property (nonatomic,weak) id<HKCityItemViewDelegate> delegate;
@end
