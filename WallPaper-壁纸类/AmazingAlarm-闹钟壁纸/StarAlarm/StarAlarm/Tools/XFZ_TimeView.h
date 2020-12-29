//
//  XFZ_TimeView.h
//  StarAlarm
//
//  Created by 谢丰泽 on 16/3/31.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXWWeatherModel.h"
@interface XFZ_TimeView : UIView


@property (nonatomic, strong) YXWWeatherModel *weatherModel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *wenduLabel;


@end
