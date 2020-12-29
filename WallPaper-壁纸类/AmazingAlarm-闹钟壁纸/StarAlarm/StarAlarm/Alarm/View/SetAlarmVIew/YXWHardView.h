//
//  YXWHardView.h
//  StarAlarm
//
//  Created by dllo on 16/4/1.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Hard) {
    ONESTAR = 1,
    TWOSTAR,
    THREESTAR,
    FOURSTAR,
    FIVESTAR,
};
@interface YXWHardView : UIView

@property (nonatomic, assign) Hard hard;

@end
