//
//  HKCircleLishTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKCliceListRespondeModel.h"

typedef void(^RowBtnClick)(HKClicleListModel *model);

@interface HKCircleLishTableViewCell : UITableViewCell
//-(void)setModelWithHK_CludlyGoodFrendModel:(HK_CludlyGoodCircleModel*)model andHK_CludlyGoodFrendData:(HK_CludlyGoodCircleData*)item andshopsNew:(NSMutableArray*)shopsNew andIndexPath:(NSIndexPath*)indexPath;
@property (nonatomic, strong)HKClicleListModel *model;
@property (nonatomic, copy) RowBtnClick block;
+(instancetype)circleLishTableViewCellWithTableView:(UITableView*)tableView;
@end
