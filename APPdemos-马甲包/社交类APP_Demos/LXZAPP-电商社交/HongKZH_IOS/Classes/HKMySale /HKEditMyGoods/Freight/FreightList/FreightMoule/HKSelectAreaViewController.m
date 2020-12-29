//
//  HKSelectAreaViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelectAreaViewController.h"
#import "HKBaseViewModel.h"
#import "HKShopDataInitRespone.h"
#import "HKSelectFreightProCell.h"
@interface HKSelectAreaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong)HKShopDataInitRespone *respone;
@property (nonatomic, strong)NSMutableArray *selectNewArray;
@end

@implementation HKSelectAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
   
}
-(void)setUI{
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(55);
        make.top.equalTo(self.view).offset(195);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
+(void)showSelectVc:(HKBaseViewController*)subVc freightListSublist:(NSObject*)model selectArray:(NSArray*)selectArray selectNewArray:(NSString*)selectNewString success:(SelectSuccess)success{
    HKSelectAreaViewController*vc = [[HKSelectAreaViewController alloc]init];
    vc.sucess = success;
    vc.model = model;
    [vc initNewSelectData:selectNewString];
    vc.areaArray = selectArray;
    [HKBaseViewController showPreWithsuperVc:subVc subVc:vc];
}
- (void)initNewSelectData:(NSString *)idString{
    [HKBaseViewModel getShopDataSuccess:^(BOOL isSave, HKShopDataInitRespone *respone) {
        self.respone = respone;
        NSArray*selectArray = [idString componentsSeparatedByString:@","];
        if (selectArray.count>0) {
            for (MediaareasInits*model in respone.data.mediaAreas) {
                for (NSString*ids in selectArray) {
                    if ([ids isEqualToString:model.ID]) {
                        model.isNewSelect = YES;
                        [self.selectNewArray addObject: model];
                        break;
                    }
                }
            }
        }
    }];
}
#pragma tableView--delegate
#pragma tableView
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HKSelectFreightProCell*cell = [HKSelectFreightProCell baseCellWithTableView:self.tableView];
    MediaareasInits*mediaM  = self.respone.data.areasArray[section];
    cell.model = mediaM;
    cell.selectType = mediaM.isSelect;
    cell.isSelcted = [self isAllSelectWithModel:mediaM];
    BOOL isAllSelect = YES;
    for (MediaareasInits*subM in mediaM.provinceArray) {
        BOOL isHas = NO;
        for (NSString*code in self.areaArray) {
            if ([code isEqualToString:subM.ID]) {
                isHas = YES;
                break;
            }
        }
        if ((!isHas)&&(!subM.isNewSelect)) {
            isAllSelect = NO;
        }
    }
    cell.isNewSelect = isAllSelect;
    @weakify(self)
    cell.block = ^{
        @strongify(self)
        [self.tableView reloadData];
    };
    cell.selectBlcok = ^(MediaareasInits *model, BOOL isSelect) {
        @strongify(self)
        if (isSelect) {
            for (MediaareasInits*subModel in model.provinceArray) {
                BOOL isHas = NO;
                for (NSString*code in self.areaArray) {
                    if ([code isEqualToString:subModel.ID]) {
                        isHas = YES;
                        break;
                    }
                }
                if (isHas) {
                    continue;
                }else{
                    if (!subModel.isNewSelect) {
                        subModel.isNewSelect = YES;
                        [self.selectNewArray addObject:subModel];
                    }
                   
                }
            }
        }else{
            for (MediaareasInits*subModel in model.provinceArray) {
                if (subModel.isNewSelect) {
                    subModel.isNewSelect = NO;
                        [self.selectNewArray removeObject:subModel];
                }
            }
        }
        [self.tableView reloadData];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.respone.data.areasArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MediaareasInits*mediaM  = self.respone.data.areasArray[section];
    if (mediaM.isSelect) {
        return  mediaM.provinceArray.count;
    }else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSelectFreightProCell*cell = [HKSelectFreightProCell baseCellWithTableView:tableView];
    MediaareasInits*mediaM  = self.respone.data.areasArray[indexPath.section];
    cell.model = mediaM.provinceArray[indexPath.row];
    cell.selectType = -1;
    cell.isSelcted = [self isSelectWithModel:cell.model];
    @weakify(self)
    cell.selectBlcok = ^(MediaareasInits *model, BOOL isSelect) {
        @strongify(self)
        if (isSelect) {
            if (!model.isNewSelect) {
                model.isNewSelect = isSelect;
                [self.selectNewArray addObject:model];
            }
           
        }else{
            if (model.isNewSelect) {
                model.isNewSelect = NO;
                [self.selectNewArray removeObject:model];
            }
            
        }
        [self.tableView reloadData];
    };
    cell.isNewSelect = cell.model.isNewSelect;
    return cell;
}

-(BOOL)isAllSelectWithModel:(MediaareasInits*)model{
    BOOL isSelect = YES;
    for (MediaareasInits*subM in model.provinceArray) {
        BOOL isHas = NO;
        for (NSString*code in self.areaArray) {
            if ([code isEqualToString:subM.ID]) {
                isHas = YES;
                break;
            }
            
        }
        if (!isHas) {
            isSelect = NO;
            break;
        }
    }
    return isSelect;
}
-(BOOL)isSelectWithModel:(MediaareasInits*)model{
    BOOL isSelect = NO;
    for (NSString*code in self.areaArray) {
        if ([code isEqualToString:model.ID]) {
            isSelect = YES;
            break;
        }
    }
    return isSelect;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}
-(void)setRespone:(HKShopDataInitRespone *)respone{
    _respone = respone;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
- (void)btnClick:(id)sender {
    if (self.sucess) {
        self.sucess(self.selectNewArray,self.model);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"选择地区";
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        label.font = PingFangSCMedium15;
        [_topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self->_topView);
        }];
        UIButton*btn = [[UIButton alloc]init];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"确定" forState:0];
        btn.titleLabel.font = PingFangSCMedium15;
        [btn setTitleColor:[UIColor colorWithRed:64.0/255.0 green:144.0/255.0 blue:247.0/255.0 alpha:1] forState:0];
        [_topView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_topView);
            make.right.equalTo(self->_topView).offset(-15);
        }];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
-(NSMutableArray *)selectNewArray{
    if (!_selectNewArray) {
        _selectNewArray = [NSMutableArray array];
    }
    return _selectNewArray;
}
@end
