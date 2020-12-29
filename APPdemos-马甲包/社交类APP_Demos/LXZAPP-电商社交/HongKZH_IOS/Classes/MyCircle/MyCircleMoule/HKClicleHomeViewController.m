//
//  HKClicleHomeViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKClicleHomeViewController.h"
#import "HKCircleCategoryListModel.h"
#import "HKCategoryClicleModel.h"
#import "HKCategoryTableViewCell.h"
#import "HKClicleHomeTableViewCell.h"
#import "HKMyCircleViewModel.h"
#import "HKCategoryClicleRespone.h"
#import "HKMyCircleViewController.h"
@interface HKClicleHomeViewController ()<UITableViewDelegate,UITableViewDataSource,HKClicleHomeTableViewCellDelegate>
@property (nonatomic, strong)UITableView *categoryTableView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *category;
@property (nonatomic,assign) int selectCategoryRow;
@end

@implementation HKClicleHomeViewController
#pragma mark Nav 设置


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadCategry];
}
-(void)loadCicleData{
   HKCategoryClicleModel*categorM =  self.category[self.selectCategoryRow];
    [HKMyCircleViewModel circleCategoryList:@{@"loginUid":HKUSERLOGINID,@"categoryId":categorM.categoryId} success:^(NSArray *array) {
        HKCategoryClicleModel*categorM =  self.category[self.selectCategoryRow];
        [categorM.questionArray addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(NSError * _Nullable error) {
        
    }];
}
-(void)loadCategry{
    [HKMyCircleViewModel circleCategory:@{} success:^(HKCategoryClicleRespone *responde) {
        if (responde.responeSuc) {
            [self.category addObjectsFromArray:responde.data];
            [self.categoryTableView reloadData];
            [self loadCicleData];
        }
    }];
}
-(void)setUI{
    self.title = @"圈子广场";
    [self.view addSubview:self.categoryTableView];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.categoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.mas_equalTo(85);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.view);
        make.left.equalTo(self.categoryTableView.mas_right).offset(1);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tag = 1;
        _tableView.showsVerticalScrollIndicator =NO;
    }
    return _tableView;
}
-(UITableView *)categoryTableView {
    if (!_categoryTableView) {
        _categoryTableView = [[UITableView alloc]init];
        _categoryTableView.delegate = self;
        _categoryTableView.dataSource = self;
        _categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _categoryTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _categoryTableView.tag = 0;
        _categoryTableView.showsVerticalScrollIndicator =NO;
    }
    return _categoryTableView;
}
#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
      return self.category.count;
    }
    
    if (self.category.count>0) {
        HKCategoryClicleModel*categorM = self.category[self.selectCategoryRow];
        return categorM.questionArray.count;
    }else{
        return 0;
    }

}
-(void)addGroupWithModel:(HKCircleCategoryListModel *)model{
    [HKMyCircleViewModel addGroup:@{@"loginUid":HKUSERLOGINID,@"circleId":model.circleId} success:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            [SVProgressHUD showSuccessWithStatus:@"申请成功，等待圈主审批"];
        }
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        HKCategoryTableViewCell*cell = [HKCategoryTableViewCell categoryTableViewCellWithTableView:tableView];
        cell.model = self.category[indexPath.row];
        if (self.selectCategoryRow == indexPath.row) {
            cell.selectRow = YES;
        }else{
             cell.selectRow = NO;
        }
        return cell;
    }else{
        HKClicleHomeTableViewCell*cell = [HKClicleHomeTableViewCell clicleHomeTableViewCellWithTableView:tableView];
        HKCategoryClicleModel*categorM = self.category[self.selectCategoryRow];
        cell.model = categorM.questionArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        self.selectCategoryRow = (int)indexPath.row;
    }else{
        HKMyCircleViewController*vc = [[HKMyCircleViewController alloc]init];
        HKCategoryClicleModel*categorM = self.category[self.selectCategoryRow];
        HKCircleCategoryListModel *listM = categorM.questionArray[indexPath.row];
        vc.circleId = listM.circleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        return 54;
    }
    return 78;
}
- (NSMutableArray *)category
{
    if(_category == nil)
    {
        _category = [ NSMutableArray array];
    }
    return _category;
}
-(void)setSelectCategoryRow:(int)selectCategoryRow{
    _selectCategoryRow = selectCategoryRow;
    [self.categoryTableView reloadData];
    if ([[self.category[selectCategoryRow] questionArray]count] == 0) {
        [self loadCicleData];
    }else{
        [self.tableView reloadData];
    }
}
@end
