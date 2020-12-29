//
//  HKLeCircleDbManage.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "ZSDBManageBaseModel.h"
#import "HKCliceListRespondeModel.h"
@interface HKLeCircleDbManage : ZSDBManageBaseModel
-(void)insertWithFriendArray:(NSArray<HKClicleListModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock;
@end
