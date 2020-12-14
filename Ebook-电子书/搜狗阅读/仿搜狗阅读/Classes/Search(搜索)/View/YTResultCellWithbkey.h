//
//  YTResultCellWithbkey.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/4.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTsearchResultItem;

@interface YTResultCellWithbkey : UITableViewCell

@property (nonatomic,strong) YTsearchResultItem *searchResultItem;

- (void)setResultCellWithbkey:(YTsearchResultItem *)resultItem;

+ (instancetype)resultCellWithbkeyWithTableView:(UITableView *)tableView;

@end
