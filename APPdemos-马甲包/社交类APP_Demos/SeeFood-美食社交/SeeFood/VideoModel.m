//
//  VideoModel.m
//  SeeFood
//
//  Created by 纪洪波 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

+ (NSMutableArray *)jsonToModel:(NSDictionary *)dic {
    NSMutableArray *modelArray = [NSMutableArray array];
        NSArray *videoList = [dic valueForKey:@"videoList"];
        for (NSDictionary *video in videoList) {
            VideoModel *model = [[VideoModel alloc]init];
            [model setValuesForKeysWithDictionary:video];
            NSDictionary *consumption = [video valueForKey:@"consumption"];
            [model setValuesForKeysWithDictionary:consumption];
        [modelArray addObject:model];
    }
    return modelArray;
}
@end
