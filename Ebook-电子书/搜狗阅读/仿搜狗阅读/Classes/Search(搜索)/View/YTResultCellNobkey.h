//
//  YTResultCellWithbkey.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/4.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTsearchResultItem;

@interface YTResultCellNobkey : UITableViewCell

@property (nonatomic,strong) YTsearchResultItem *searchResultItem;

- (void)setResultCellNobkey:(YTsearchResultItem *)resultItem;

+ (instancetype)resultCellNobkeyWithTableView:(UITableView *)tableView;

@end
