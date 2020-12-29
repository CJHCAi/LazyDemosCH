//
//  HKLuckyBurstFriendsData.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LuckyBurstFriendsModel;
@interface HKLuckyBurstFriendsData : NSObject
@property (nonatomic, strong)NSMutableArray<LuckyBurstFriendsModel*> *list;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;
@property (nonatomic, assign) NSInteger totalPage;
@end
