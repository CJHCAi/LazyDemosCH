//
//  LMPictureFilterManager.m
//  BeautifyCamera
//
//  Created by sky on 2017/1/25.
//  Copyright © 2017年 guikz. All rights reserved.
//

#import "LMPictureFilterManager.h"
#import "LMCameraFilters.h"
#import "UBLookupEffectFilter.h"

@interface LMPictureFilterManager ()


@end


@implementation LMPictureFilterManager
+(instancetype) pictureManager {
    static LMPictureFilterManager * _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[LMPictureFilterManager alloc] init];
    });
    return _manager;
}

-(NSArray *) filters{
    static NSArray * _filters = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray * arr = [NSMutableArray new];
        LMFilterGroup *f1 = [LMCameraFilters normal];
        LMFilterGroup *f2 = [LMCameraFilters beautyGroup];
        [arr addObject:f1];
        [arr addObject:f2];
        
        NSArray * lookupArr = [UBLookupEffectFilter loadLookupFilter];
        
        [arr addObjectsFromArray:lookupArr];
        
        _filters = arr;
    });
    return _filters;
}

@end
