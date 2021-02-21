//
//  YCEditCollectionController.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCBaseCollectionController.h"

@interface YCEditCollectionController : YCBaseCollectionController

@property (nonatomic, strong) YCBaseCollectionController *presentVC;
@property (nonatomic, strong) NSString    *order;
@property (nonatomic, assign) BOOL        category;
@property (nonatomic, assign) BOOL        bSearch;
@end
