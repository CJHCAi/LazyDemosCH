//
//  HKCircleCategoryListModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKCircleCategoryListModel : NSObject
@property (nonatomic, copy)NSString * circleId;
@property (nonatomic, copy)NSString * circleName;
@property (nonatomic, copy)NSString *coverImgSrc;
@property (nonatomic, copy)NSString *circleCount;
@property (nonatomic,assign) int ucId;
@property (nonatomic, copy)NSString *userCount;
@end
