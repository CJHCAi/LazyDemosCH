//
//  HKDeliverGoodsViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDeliverGoodsViewController.h"
#import "HKEditExpressTableViewCell.h"
#import "UIImage+YY.h"
#import "HKOrderAddressTableViewCell.h"
#import "HKOrderFormViewModel.h"
#import "HKExpresListRespone.h"
#import "HKExpressViewController.h"
#import "HKExpresListRespone.h"
@interface HKDeliverGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,HKEditExpressTableViewCellDelegate,HKExpressViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIButton *sendbtn;
@property (nonatomic, strong)HKExpresModel *expreM;
@end

@implementation HKDeliverGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    self.title = @"发货";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sendbtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.sendbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
    }];
}
-(void)selectExpresModel:(HKExpresModel *)model{
    self.expreM.name = model.name;
    [self.tableView reloadData];
}
-(void)toVcselectExpress{
    [HKOrderFormViewModel expresListWithsuccess:^(HKExpresListRespone *responde) {
        if (responde.responeSuc) {
            HKExpressViewController*vc = [[HKExpressViewController alloc]init];
            vc.delegate = self;
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
//             self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            vc.questionArray = [NSMutableArray arrayWithArray:responde.data] ;
            self.navigationController.definesPresentationContext = YES;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
    }];
}
-(void)sellerOrderDeliver{
 if(self.expreM.name.length>0&&self.expreM.expresNum.length>0) {
        NSDictionary*dict = @{@"loginUid":HKUSERLOGINID,@"orderNumber":self.model.orderNumber,@"courier":self.expreM.name,@"courierNumber":self.expreM.expresNum};
         [HKOrderFormViewModel sellerOrderDeliver:dict success:^(HKBaseResponeModel *responde) {
           if (responde.responeSuc) {
               if ([self.delegate respondsToSelector:@selector(noticeVcRefreshWithType:model:)]) {
                   [self.delegate noticeVcRefreshWithType:OrderFormStatue_cnsignment model:self.expreM];
               }
               [self.navigationController popViewControllerAnimated:YES];
              }
          }];
        
    }
}
-(UITableView *)tableView  {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        HKEditExpressTableViewCell *cell = [HKEditExpressTableViewCell editExpressTableViewCellWithTableView:tableView];
        cell.model = self.expreM;
        cell.delegate = self;
        return cell;
    }else{
        HKOrderAddressTableViewCell*cell = [HKOrderAddressTableViewCell orderAddressTableViewCellWithTableView:tableView];
        cell.model = self.model;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 100;
    }
}
-(UIButton *)sendbtn{
    if (!_sendbtn) {
        _sendbtn = [[UIButton alloc]init];
        [_sendbtn setTitle:@"发货" forState:0];
        UIImage *image = [UIImage zsyy_imageByResizeToSize:CGSizeMake(kScreenWidth-30, 50) roundCornerRadius:5 color:[UIColor colorWithRed:197.0/255.0 green:89.0/255.0 blue:78.0/255.0 alpha:1]];
        [_sendbtn setBackgroundImage:image forState:0];
        [_sendbtn addTarget:self action:@selector(sellerOrderDeliver) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendbtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setModel:(HKOrderInfoData *)model{
    _model = model;
    [self.tableView reloadData];
}
-(HKExpresModel *)expreM{
    if (!_expreM) {
        _expreM = [[HKExpresModel alloc]init];
    }
    return _expreM;
}
@end
