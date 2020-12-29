//
//  HKCitySelectViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCitySelectViewController.h"
#import "HKCategoryBarView.h"
#import "HKChinaModel.h"
#import "HKWHUrl.h"
#import "HKProvinceModel.h"
#import "HKCityModel.h"
#import "HKSelectRowTableViewCell.h"
#import "HKBaseViewModel.h"
#import "HKCountryModels.h"
#import "HKHKCitySelfMediaPageViewController.h"
@interface HKCitySelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)HKCategoryBarView *categoryView;
@property (nonatomic, strong)UITableView *leftTableView;
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *leftArray;
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic,assign) int type;
@property (nonatomic, strong)HKChinaModel *chinaM;
@property (nonatomic,assign) int row1;
@property (nonatomic,assign) int row2;
@property (nonatomic, strong)NSMutableArray *countyArray;
@end

@implementation HKCitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.type = 0;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)setType:(int)type{
    _type =type;
    if (type == 0) {
        NSMutableArray*array = [NSMutableArray array];
        for (HKProvinceModel*preM in self.chinaM.provinces) {
            [array addObject:preM.name];
           
        }
        self.leftArray = array;
        self.row2 = 0;
    }else{
        NSMutableArray*array = [NSKeyedUnarchiver unarchiveObjectWithFile:KCountryListData];
        if (array.count == 0) {
            [HKBaseViewModel initCountryDataSuccess:^(BOOL isSave, NSMutableArray *dataArray) {
                if (dataArray.count>0) {
                    self.countyArray = dataArray;
                    NSMutableArray* arrays = [NSMutableArray array];
                    for (HKCountryModels*model in array) {
                        [arrays addObject:model.name];
                        
                    }
                    self.row1 = 0;
                    self.leftArray = arrays;
                    self.row2 = 0;
                }else{
                    
                }
            }];
        }else{
            self.countyArray = array;
            NSMutableArray* arrays = [NSMutableArray array];
            for (HKCountryModels*model in array) {
                [arrays addObject:model.name];
            }
            self.row1 = 0;
            self.leftArray = arrays;
            self.row2 = 0;
        }
    }
}
-(void)loadData{
    HKCountryModels*model = self.countyArray[self.row1];
    NSMutableArray*arrays = [NSMutableArray array];
    if (model.dataArray.count >0) {
        for (HKCountryModels*models in model.dataArray) {
            [arrays addObject:models.name];
        }
        self.array = arrays;
        [self.leftTableView reloadData];
    }else{
        [HKBaseViewModel initCountryData:self.countyArray param:model success:^(BOOL isSave, NSMutableArray *dataArray) {
            if (dataArray.count) {
                for (HKCountryModels*models in model.dataArray) {
                    [arrays addObject:models.name];
                }
                self.array = arrays;
                [self.leftTableView reloadData];
            }
        }];
    }
}
-(void)setRow1:(int)row1{
    _row1 = row1;
    self.row2 = 0;
}
-(void)setRow2:(int)row2{
    _row2 = row2;
    if (self.type == 0) {
        HKProvinceModel*preM = self.chinaM.provinces[self.row1];
        NSMutableArray*array  = [NSMutableArray array];
        for (HKCityModel*model in preM.citys) {
            [array addObject:model.name];
        }
        self.array = array;
    }else{
        [self loadData];
    }
}
-(void)setUI{
    self.title = @"选择城市";
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.tableView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.mas_equalTo(150);
        make.top.equalTo(self.categoryView.mas_bottom);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.bottom.right.equalTo(self.view);
        make.top.equalTo(self.categoryView.mas_bottom);
    }];
}
-(UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]init];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _leftTableView.tag = 0;
    }
    return _leftTableView ;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tag = 1;
    }
    return _tableView ;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
      return   self.leftArray.count;
    }
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSelectRowTableViewCell*cell = [HKSelectRowTableViewCell baseCellWithTableView:tableView];
    cell.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    cell.titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (tableView.tag == 0) {
        if (self.row1 == indexPath.row) {
            cell.titleBtn.selected = YES;
        }else{
            cell.titleBtn.selected = NO;
        }
        [cell.titleBtn setTitle:self.leftArray[indexPath.row] forState:0];
        [cell.titleBtn setTitle:self.leftArray[indexPath.row] forState:UIControlStateSelected];
    }else{
        if (self.row2 == indexPath.row) {
            cell.titleBtn.selected = YES;
        }else{
            cell.titleBtn.selected = NO;
        }
        [cell.titleBtn setTitle:self.array[indexPath.row] forState:0];
        [cell.titleBtn setTitle:self.array[indexPath.row] forState:UIControlStateSelected];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        self.row1 = (int)indexPath.row;
    }else{
        if (self.type == 0) {
            _row2 = (int)indexPath.row;
            [tableView reloadData];
            HKHKCitySelfMediaPageViewController*vc = [[HKHKCitySelfMediaPageViewController alloc]init];
            HKProvinceModel*pro = self.chinaM.provinces[self.row1];
            
            
            vc.cityId = [pro.citys[self.row2]code];
            vc.title =[pro.citys[self.row2] name];
            [self.navigationController  pushViewController:vc animated:YES];
        }else{
            _row2 = (int)indexPath.row;
            [tableView reloadData];
            HKHKCitySelfMediaPageViewController*vc = [[HKHKCitySelfMediaPageViewController alloc]init];
            HKCountryModels*pro = self.countyArray[self.row1];
            HKCountryModels*countrCity = pro.dataArray[self.row2];
            vc.cityId = countrCity.code;
            vc.title =[pro.dataArray[self.row2] name];
            [self.navigationController  pushViewController:vc animated:YES];
        }
    }
    [self.tableView reloadData];
    [self.leftTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(HKCategoryBarView *)categoryView{
    if (!_categoryView) {
           @weakify(self)
        _categoryView = [HKCategoryBarView categoryBarViewWithCategoryArray:@[@"国内",@"国际"] selectCategory:^(int index) {
            @strongify(self)
            self.type = index;
        }];
    }
    return _categoryView;
}
-(void)setLeftArray:(NSMutableArray *)leftArray{
    _leftArray = leftArray;
    [self.leftTableView reloadData];
}
-(void)setArray:(NSMutableArray *)array{
    _array = array;
    [self.tableView reloadData];
}
-(HKChinaModel *)chinaM{
    if (!_chinaM) {
         _chinaM = [NSKeyedUnarchiver unarchiveObjectWithFile:KCityListData];
        

    }
    return _chinaM;
}
@end
