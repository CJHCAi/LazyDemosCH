//
//  HKEditFreightViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditFreightViewController.h"
#import "HKBasicsFreightTableViewCell.h"
#import "HKEditProvinceFreightTableViewCell.h"
#import "HKEditGoodsViewModel.h"
#import "HKEditFrightAddCityFootView.h"
#import "HKSelectAreaViewController.h"
#import "HKShopDataInitRespone.h"

@interface HKEditFreightViewController ()<UITableViewDelegate,UITableViewDataSource,HKEditProvinceFreightTableViewCellDelegate,HKEditFrightAddCityFootViewDelegate,HKBasicsFreightTableViewCellDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKEditFrightAddCityFootView *footerView;
@end

@implementation HKEditFreightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)rightBarButtonItemClick{
    if (self.model.name.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入运费模板名称"];
        return;
    }
    self.model.isHasNotInput = self.model.isHasNotInput;
    if (self.model.isHasNotInput) {
        [SVProgressHUD showErrorWithStatus:@"存在未输入的规格"];
        return;
    }
    [HKEditGoodsViewModel savefreight:self.model success:^(BOOL isSuc) {
        if (isSuc) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
    }];
}
-(void)setUI{
    self.title = self.model.name;
    [self setrightBarButtonItemWithTitle:@"保存"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)selectProWithModelListData:(HKFreightListData *)model{
    NSArray*selectA = [self.model allSelectPeovince:model.provinceId];
    @weakify(self)
    [HKSelectAreaViewController showSelectVc:self freightListSublist:model selectArray:selectA selectNewArray:model.provinceId success:^(NSArray *areaArray, NSObject *model) {
       @strongify(self)
        HKFreightListData* listModel = (HKFreightListData*)model;
        if (areaArray.count == 0) {
            return ;
        }
        NSMutableString*stringID = [NSMutableString string];
        NSMutableString*stringName = [NSMutableString string];
        for (MediaareasInits*model in areaArray) {
            [stringID appendString:model.ID];
            [stringID appendString:@","];
            [stringName appendString:model.name];
            [stringName appendString:@","];
        }
        if (stringID.length>0) {
            [stringID deleteCharactersInRange:NSMakeRange(stringID.length-1, 1)];
        }
        if (stringName.length>0) {
            [stringName deleteCharactersInRange:NSMakeRange(stringName.length-1, 1)];
        }
        listModel.provinceName = stringName;
        listModel.provinceId = stringID;
        [self.tableView reloadData];
    }];
}
-(void)selectProWithModel:(HKFreightListSublist *)model{
    NSArray*selectA = [self.model allSelectPeovince:model.provinceId];
    DLog(@"");
    @weakify(self)
    [HKSelectAreaViewController showSelectVc:self freightListSublist:model selectArray:selectA selectNewArray:model.provinceId success:^(NSArray *areaArray, NSObject *model) {
       @strongify(self)
        HKFreightListSublist* subModel = (HKFreightListSublist*)model;
        if (areaArray.count == 0) {
            return ;
        }
        NSMutableString*stringID = [NSMutableString string];
        NSMutableString*stringName = [NSMutableString string];
        for (MediaareasInits*model in areaArray) {
            [stringID appendString:model.ID];
            [stringID appendString:@","];
            [stringName appendString:model.name];
            [stringName appendString:@","];
        }
        if (stringID.length>0) {
            [stringID deleteCharactersInRange:NSMakeRange(stringID.length-1, 1)];
        }
        if (stringName.length>0) {
            [stringName deleteCharactersInRange:NSMakeRange(stringName.length-1, 1)];
        }
        subModel.provinceName = stringName;
        subModel.provinceId = stringID;
        [self.tableView reloadData];
        DLog(@"");
    }];
}
-(void)addClick{
    BOOL isAdd = YES;
    for (HKFreightListSublist*subListM in self.model.sublist) {
        if (subListM.isHasNotInput) {
            isAdd = NO;
            break;
        }
    }
    if (isAdd) {
        HKFreightListSublist*subListM= [[HKFreightListSublist alloc]init];
        subListM.isHasNotInput = YES;
        [self.model.sublist addObject:subListM];
        [self.tableView reloadData];
    }else{
        [SVProgressHUD showErrorWithStatus:@""];
    }
}
-(void)delegateSublist:(HKFreightListSublist *)model{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"确认删除此地区运费" cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:^{}] otherButtonItems:[RIButtonItem itemWithLabel:@"确定" action:^{
        if (model.freightId.length == 0) {
            [self.model.sublist removeObject:model];
            [self.tableView reloadData];
            return ;
        }
        [HKEditGoodsViewModel deleteareafreighte:@{kloginUid:HKUSERLOGINID,@"areafreightId":model.areafreightId} success:^(HKBaseResponeModel *respone) {
            if (respone.responeSuc) {
                [self.model.sublist removeObject:model];
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:@"删除失败"];
            }
        }];
    }], nil];
    [alert show];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableFooterView = self.footerView;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.model.sublist.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        HKEditProvinceFreightTableViewCell*cell = [HKEditProvinceFreightTableViewCell baseCellWithTableView:tableView];
        cell.model = self.model.sublist[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    HKBasicsFreightTableViewCell*cell = [HKBasicsFreightTableViewCell baseCellWithTableView:tableView];
    cell.model = self.model;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(HKEditFrightAddCityFootView *)footerView{
    if (!_footerView) {
        _footerView = [[HKEditFrightAddCityFootView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 228)];
        _footerView.delegate = self;
    }
    return _footerView;
}
@end
