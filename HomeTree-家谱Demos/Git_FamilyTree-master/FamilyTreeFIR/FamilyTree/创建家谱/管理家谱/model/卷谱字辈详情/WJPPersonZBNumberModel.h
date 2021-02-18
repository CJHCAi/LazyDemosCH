//
//  WJPPersonZBNumberModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WJPZBDatalist;
@interface WJPPersonZBNumberModel : NSObject

@property (nonatomic, strong) NSArray<WJPZBDatalist *> *datalist;

@property (nonatomic, assign) NSInteger allcnt;


+(instancetype)sharedWJPPersonZBNumberModel;


@end
@interface WJPZBDatalist : NSObject

@property (nonatomic, assign) NSInteger cnt;

@property (nonatomic, copy) NSString *zb;

@end

