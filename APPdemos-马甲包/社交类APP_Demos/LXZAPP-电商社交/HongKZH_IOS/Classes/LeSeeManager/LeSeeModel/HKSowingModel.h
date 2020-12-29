//
//  HKSowingModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKSowingModel : NSObject
@property (nonatomic, copy)NSString *imgSrc;
@property (nonatomic, copy)NSString *imgLinks;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *imgRank;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *vedioLength;
@property (nonatomic,assign)HKSowingModelType type;

@property (nonatomic, copy)NSString *carouselId;
@end
