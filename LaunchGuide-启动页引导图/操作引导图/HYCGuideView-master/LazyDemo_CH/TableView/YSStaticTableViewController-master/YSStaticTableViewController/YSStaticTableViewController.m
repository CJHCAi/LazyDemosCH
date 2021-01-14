//
//  YSStaticTableViewController.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/18.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "YSStaticTableViewController.h"


@interface YSStaticTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, readwrite, strong) UITableView *tableView;
@end

@implementation YSStaticTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self configureNav];
    [self configureTableView];
}

#pragma mark- configure subviews
//- (void)configureNav {
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    //修改导航条背景色
//    self.navigationController.navigationBar.barTintColor = SJColorWithRGB(18, 18, 18, 1.0);
//
//    //修改导航条标题颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
//
//    //修改导航条添加的按钮
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//}

- (void)configureTableView {
    [self.view addSubview:self.tableView];
}

#pragma mark - Public Method
- (__kindof YSStaticCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sectionModelArray.count > indexPath.section) {
        YSStaticSectionModel *sectionModel = [self sectionModelInSection:indexPath.section];
        if (sectionModel.cellModelArray.count > indexPath.row) {
            return [sectionModel.cellModelArray objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

- (YSStaticSectionModel *)sectionModelInSection:(NSInteger )section {
    if (self.sectionModelArray.count > section) {
        return [self.sectionModelArray objectAtIndex:section];
    }
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YSStaticSectionModel *sectionModel = [self sectionModelInSection:section];
    return sectionModel.cellModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSStaticCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    
    YSStaticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellIdentifier];
    if (!cell) {
        Class clazz = NSClassFromString(cellModel.cellClassName);
        NSAssert(clazz, @"自定义时，请使用这种方法设置cellClassName:NSStringFromClass([xxx class])");
        cell = [[clazz alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellModel.cellIdentifier];
    }
    
    cell.selectionStyle = cellModel.didSelectCellBlock ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    
    [cell configureTableViewCellWithModel:cellModel];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YSStaticSectionModel *sectionModel = [self sectionModelInSection:section];
    return sectionModel.sectionHeaderTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    YSStaticSectionModel *sectionModel = [self sectionModelInSection:section];
    return sectionModel.sectionFooterTitle;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSStaticCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    return cellModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    YSStaticSectionModel *sectionModel = [self sectionModelInSection:section];
    return sectionModel.sectionHeaderHeight < 0.01 ? 0.01 : sectionModel.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    YSStaticSectionModel *sectionModel = [self sectionModelInSection:section];
    return sectionModel.sectionFooterHeight < 0.01 ? 0.01 : sectionModel.sectionFooterHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSStaticCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    !cellModel.didSelectCellBlock ?: cellModel.didSelectCellBlock(cellModel, indexPath);
}

#pragma mark - Setter && Getter
- (void)setSectionModelArray:(NSArray *)sectionModelArray {
    _sectionModelArray = sectionModelArray;
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
