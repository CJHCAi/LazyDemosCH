//
//  HKMyCircleData.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKMyPostsRespone.h"
@class HKProductsModel,HKMyCircleMemberModel;
@interface HKMyCircleData : NSObject
@property (nonatomic,assign) int boothMoney;
@property (nonatomic, copy)NSString *categoryId;
@property (nonatomic, copy)NSString *categoryName;
@property (nonatomic, copy)NSString *coverImgSrc;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *introduction;
@property(nonatomic, assign) int isMain;
@property(nonatomic, assign) int isValidate;
@property (nonatomic, copy)NSString *name;
@property(nonatomic, assign) int num;
@property (nonatomic,assign) int ucId;
@property (nonatomic, strong)NSArray<HKMyPostModel*> *posts;
@property (nonatomic, strong)NSMutableArray<HKProductsModel*> *products;
@property (nonatomic, strong)NSMutableArray<HKMyCircleMemberModel*> *members;
@property(nonatomic, assign) int remind;
@property(nonatomic, assign) int state;
@property (nonatomic, copy)NSString *uid;
@property(nonatomic, assign) int upperLlimit;
@property(nonatomic, assign) int userCount;
@property (nonatomic, strong)UIImage * coverImg;

@end
