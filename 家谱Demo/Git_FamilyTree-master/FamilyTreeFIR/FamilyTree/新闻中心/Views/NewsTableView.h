//
//  NewsTableView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/7.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyDTModel.h"

@interface NewsTableView : UIView
/** 表*/
@property (nonatomic,strong) UITableView *tableView;
/** 数据数组*/
@property (nonatomic, strong) NSMutableArray<FamilyDTModel *> *dataSource;
@end
