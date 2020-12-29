//
//  HK_userHobyModel.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HK_userHobyModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imgSrc;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, assign)NSInteger imkRank;
@property (nonatomic, assign)BOOL isSelect;

@end
