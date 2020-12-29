//
//  HKHKEstablishClicleParameters.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKHKEstablishClicleParameters : NSObject
@property (nonatomic, copy)NSString *loginUid;
@property (nonatomic, copy)NSString *categoryId;
@property (nonatomic, copy)NSString *circleName;
@property(nonatomic, assign) NSInteger coverImgWidth;
@property(nonatomic, assign) NSInteger coverImgHeight;
@property (nonatomic, copy)NSString *introduction;
@property (nonatomic, assign)BOOL isValidate;
@property (nonatomic, copy)NSString *categoryName;
@property (nonatomic, copy)NSString *circleId;
@property (nonatomic, copy)NSString *upperLlimit;

@end
