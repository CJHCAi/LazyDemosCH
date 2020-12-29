//
//  HKEditFrightAddCityFootView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKEditFrightAddCityFootViewDelegate <NSObject>

@optional
-(void)addClick;
@end
@interface HKEditFrightAddCityFootView : UIView
@property (nonatomic,weak) id<HKEditFrightAddCityFootViewDelegate> delegate;
@end
