//
//  HJMaskView.m
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/24.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import "HJMaskView.h"

@implementation HJMaskView

+ (NSString *)convertVideoDuration:(Float64)duration {
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:duration];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (duration/3600 >= 1) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    NSString *time = [dateFormatter stringFromDate:d];
    return time;
}

@end
