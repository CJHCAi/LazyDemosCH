//
//  HKClicleInfoViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKClicleInfoViewController.h"
#import "HKMyCircleViewModel.h"
#import "HKMyCircleRespone.h"
#import "HKMyCircleData.h"
#import "HKGroupInfoIntroductionTableViewCell.h"
#import "HKCircleSettingViewController.h"
#import "HKCicleMemberVc.h"
#import "HKProductsModel.h"
@interface HKClicleInfoViewController ()<UITableViewDelegate,UITableViewDataSource,HKGroupInfoIntroductionTableViewCellDelagate>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation HKClicleInfoViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    self.title =@"圈子资料";
//    [self loadData];
    
}
-(void)setDataModel:(HKMyCircleData *)dataModel{
    _dataModel = dataModel;
    [self.tableView reloadData];
    
}
-(void)rightBarButtonItemClick{
//    HK_GladlyCircleSetView *chat = [[HK_GladlyCircleSetView alloc] init];
//    [chat addReRequest:self.circleId];
    HKCircleSettingViewController*chat = [[HKCircleSettingViewController alloc]init];
    chat.circleId = self.circleId;
    chat.dataModel = self.dataModel;
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma maerk 进入圈子成员列表页面
-(void)checkCicleMember:(HKMyCircleData *)model {
    HKCicleMemberVc *memVc =[[HKCicleMemberVc alloc] init];
    memVc.model = model;
    [self.navigationController pushViewController:memVc animated:YES];
}
-(void)addGroup:(int)state{
#pragma mark 加入或退出圈子
    if (state==1) {
        [HKMyCircleViewModel addGroup:@{@"loginUid":HKUSERLOGINID,@"circleId":self.circleId} success:^(HKBaseResponeModel *responde) {
            if (responde.responeSuc) {
                [SVProgressHUD  setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:(NSString *)responde.data];
                if (self.block) {
                    self.block(2);
                }
                [self loadData];
            }
        }];
    }else {

        UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"您确定要退出圈子?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleA =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [cancleA setValue:RGB(153,153,153) forKey:@"titleTextColor"];
        [alertController addAction:cancleA];
        UIAlertAction *define =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [HKMyCircleViewModel quitCicle:@{kloginUid:HKUSERLOGINID,@"circleId":self.circleId} success:^(HKBaseResponeModel *responde) {
                if (responde.responeSuc) {
                    [SVProgressHUD  setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"退出圈子成功"];
                    [self loadData];
                    if (self.block) {
                        self.block(1);
                    }
                    [self performSelector:@selector(pop) withObject:nil afterDelay:1];
                }
            }];
        }];
        [define setValue:keyColor forKey:@"titleTextColor"];
        [alertController addAction:define];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData{
    [HKMyCircleViewModel myCircle:@{} success:^(HKMyCircleRespone *responde) {
        if (responde.responeSuc) {
            
             self.dataModel = responde.data;
            [self.tableView reloadData];
        }
    }];
}
-(void)setUI{
    [self setrightBarButtonItemWithTitle:@"设置"];
    if (self.dataModel.isMain == 1) {
        self.rightBtn.hidden = NO;
    }else{
        self.rightBtn.hidden = YES;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.estimatedRowHeight = 245;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKGroupInfoIntroductionTableViewCell*cell = [HKGroupInfoIntroductionTableViewCell groupInfoIntroductionTableViewCellWithTableView:tableView];
    cell.model = self.dataModel;
    cell.delegate = self;
    if (self.dataModel.remind==1) {
        cell.sw.on =YES;
    }else {
        cell.sw.on = NO;
    }
    [cell.sw addTarget:self action:@selector(remindChange:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}
#pragma mark 设置提醒与否
-(void)remindChange:(UISwitch *)sw {
    [HKMyCircleViewModel chanageReMindWith:sw.on cicleId:self.circleId success:^{
        if (sw.on) {
            self.dataModel.remind = 1;
             [EasyShowTextView showText:@"打开提醒!"];
        }else {
            self.dataModel.remind = 0;
              [EasyShowTextView showText:@"关闭提醒!"];
        }
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}

#pragma mark 进入商品详情页
-(void)pushShopDetail:(NSInteger)sender {
    HKProductsModel * model =self.dataModel.products[sender];
    [AppUtils pushGoodsInfoDetailWithProductId:model.productId andCurrentController:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
