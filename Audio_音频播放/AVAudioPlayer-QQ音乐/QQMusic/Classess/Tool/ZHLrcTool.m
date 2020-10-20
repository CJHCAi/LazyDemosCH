//
//  ZHLrcTool.m
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import "ZHLrcTool.h"
#import "ZHLrcline.h"

@implementation ZHLrcTool
+ (NSArray *)lrcToolWithLrcname:(NSString *)lrcname
{
    // 1.获取歌词的路径
    NSString *lrcFilePath = [[NSBundle mainBundle] pathForResource:lrcname ofType:nil];
    
    // 2.加载对应的歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:lrcFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    
    // 3.遍历每一句歌词
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *lrclineString in lrcArray) {
        // 3.1.过滤掉一些不需要的行号
        if ([lrclineString hasPrefix:@"[ti:"] || [lrclineString hasPrefix:@"[ar:"] || [lrclineString hasPrefix:@"[al:"] || ![lrclineString hasPrefix:@"["]) {
            continue;
        }
        
        // 3.2.将每一句歌词转成模型对象
        ZHLrcline *lrcline = [ZHLrcline lrclineWithLrcString:lrclineString];
        
        [tempArray addObject:lrcline];
    }
    
    return tempArray;
}
@end
