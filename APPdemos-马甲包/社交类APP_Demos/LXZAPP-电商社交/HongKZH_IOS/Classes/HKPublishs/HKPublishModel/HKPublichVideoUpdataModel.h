//
//  HKPublichVideoUpdataModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKPublichVideoUpdataModel : NSObject
@property (nonatomic, copy)NSString *categoryId;
@property (nonatomic, copy)NSString *loginUid;
@property (nonatomic, copy)NSString *imgSrc;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *coverImgSrc;
@property (nonatomic, copy)NSString *vedioLength;
@property (nonatomic, copy)NSString *coverImgWidth;
@property (nonatomic, copy)NSString *coverImgHeight;
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *longitude;
@property (nonatomic, copy)NSString *provinceId;
@property (nonatomic, copy)NSString *cityId;
@property (nonatomic, copy)NSString *remarks;
@property (nonatomic, copy)NSString *width;
@property (nonatomic, copy)NSString *high;
@property (nonatomic, copy)NSString *note;
@property (nonatomic, copy)NSString *isOpen;
//发布新增参数
@property (nonatomic, copy)NSString *money;
@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *type;

@property (nonatomic, assign)int isUpdate;
@end
