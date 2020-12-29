//
//  HKRecommendsCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "EnterpriseAdvRespone.h"
#import "HKCompanyPublishResponse.h"
@interface HKRecommendsCell : BaseTableViewCell
@property (nonatomic, strong)RecommendModle *model;
@property (nonatomic, assign)BOOL isPublish;
@property (nonatomic, strong)HKCompanyPublishList * list;
@end
