//
//  ZHLrcline.h
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHLrcline : NSObject
/** 时间 */
@property (nonatomic, assign) NSTimeInterval time;
/** 歌词 */
@property (nonatomic, copy) NSString *text;

- (instancetype)initWithLrcString:(NSString *)lrcString;
+ (instancetype)lrclineWithLrcString:(NSString *)lrcString;

@end
