//
//  LEFriendDbManage.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "ZSDBManageBaseModel.h"
#import "HKFriendRespond.h"
@interface LEFriendDbManage : ZSDBManageBaseModel
-(void)insertWithFriendArray:(NSArray<HKFriendModel*>*)dataArray andSuc:(void(^)(BOOL isSuc))sucBlock;
@end
