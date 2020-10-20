//
//  YSStaticTableViewController.h
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/18.
//  Copyright © 2018年 YangShen. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "YSStaticSectionModel.h"
#import "YSStaticCellModel.h"
#import "YSStaticTableViewCell.h"

@interface YSStaticTableViewController : UIViewController

@property (nonatomic, readwrite, strong) NSArray     *sectionModelArray;
@property (nonatomic, readonly , strong) UITableView *tableView;

#pragma mark - public method
- (YSStaticSectionModel *)sectionModelInSection:(NSInteger )section;
- (__kindof YSStaticCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath;

@end
