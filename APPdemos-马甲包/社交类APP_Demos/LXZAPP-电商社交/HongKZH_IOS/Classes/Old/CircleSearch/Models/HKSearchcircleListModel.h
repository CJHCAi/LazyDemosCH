//
//  HKSearchcircleListModel.h
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

@class HKSearchcircleListModelData;
@interface HKSearchcircleListModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<HKSearchcircleListModelData *> *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKSearchcircleListModelData : NSObject

@property (nonatomic, assign) NSInteger userCount;

@property (nonatomic, copy) NSString *circleName;

@property (nonatomic, copy) NSString *coverImgSrc;

@property (nonatomic, copy) NSString *circleId;

@property (nonatomic, copy) NSString *categoryName;

@end


