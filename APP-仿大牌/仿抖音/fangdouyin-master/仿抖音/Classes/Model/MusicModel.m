//
//  MusicModel.m
//  仿抖音
//
//  Created by ireliad on 2018/3/15.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "MusicModel.h"
#import <MJExtension/MJExtension.h>

@implementation MusicModel
+(NSArray<MusicModel *>*)models
{
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"data.json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray<MusicModel*> *array = [MusicModel mj_objectArrayWithKeyValuesArray:dict[@"aweme_list"]];
    return [array copy];
}
@end
