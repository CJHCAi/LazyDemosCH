//
//  HKMyDyamicModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HKMydyamicDataModel;
@interface HKMyDyamicModel : NSObject
@property (nonatomic,assign) int totalRow;
@property (nonatomic,assign) int pageNumber;
@property (nonatomic,assign) BOOL lastPage;
@property (nonatomic,assign) BOOL firstPage;
@property (nonatomic,assign) int totalPage;
@property (nonatomic,assign) int pageSize;
@property (nonatomic, strong)NSArray<HKMydyamicDataModel*> *list;
@end
