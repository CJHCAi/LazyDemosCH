//
//  PixabayService.m
//  WallPaper
//
//  Created by Never on 2019/7/18.
//  Copyright © 2019 Never. All rights reserved.
//

#import "PixabayService.h"
#import "MHNetwork.h"
#import <MJExtension.h>
#import "PixabayModel.h"

@implementation PixabayService

+(void)requestWallpapersParams:(NSMutableDictionary *)params completion:(PixabayCompletion)completion{
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    [params setObject:API_Key forKey:@"key"];
    [params setObject:@"zh" forKey:@"lang"];
    [params setObject:@"photo" forKey:@"image_type"];
    [MHNetworkManager getRequstWithURL:API_HOST params:params successBlock:^(id returnData, int code, NSString *msg) {
//        NSLog(@"returnData:%@",returnData);
        NSMutableArray *ModelArr = [PixabayModel mj_objectArrayWithKeyValuesArray:returnData[@"hits"]];
        completion(ModelArr,YES);
    } failureBlock:^(NSError *error) {
//        NSLog(@"%@",error);
    } showHUD:NO];
    
}

@end
