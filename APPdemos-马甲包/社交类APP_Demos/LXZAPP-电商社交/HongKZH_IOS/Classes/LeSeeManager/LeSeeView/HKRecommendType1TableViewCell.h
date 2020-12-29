//
//  HKRecommendType1TableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HKRecommendRespone.h"
#import "HKPriseHotAdvListRespone.h"
@interface HKRecommendType1TableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *backVIews;
@property (nonatomic, strong)RecommendModel *model;
@property (nonatomic, strong)PriseHotAdvListModel *hotModel;
@end
