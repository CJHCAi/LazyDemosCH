//
//  HKSetingVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSetingVc.h"
#import "HKAccountVc.h"
#import "HKBlacklistVc.h"
#import "HKAboutUsVc.h"
#import "HKAdviceVc.h"
#import "HKApplymerchantVc.h"
#import "HK_AddressInfoView.h"
#import "HKRealNameAuthViewController.h"
#import "HKSetTool.h"
#import "HKPersonAuthVc.h"
@interface HKSetingVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIView *footView;
@property (nonatomic, copy)NSString *shopId;
@property (nonatomic, copy)NSString *realNameState;
@end

@implementation HKSetingVc

-(UIView *)footView {
    if (!_footView) {
        _footView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
        _footView.backgroundColor =[UIColor whiteColor];
        UILabel * titles =[[UILabel alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,50)];
        [_footView addSubview:titles];
        [AppUtils getConfigueLabel:titles font:PingFangSCMedium15 aliment:NSTextAlignmentCenter textcolor:RGBA(239,89,60,1) text:@"退出登录"];
        UITapGestureRecognizer *tao =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quit:)];
        _footView.userInteractionEnabled = YES;
        [_footView addGestureRecognizer:tao];
    }
    return _footView;
}
-(void)quit:(UITapGestureRecognizer *)ta {
    UIAlertController *aler =[UIAlertController alertControllerWithTitle:@"确定退出登录?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne  =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionTwo =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //清除登录信息
        [LoginUserDataModel clearUserInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [aler addAction:actionOne];
    [aler addAction:actionTwo];
    [self presentViewController:aler animated:YES completion:nil];
}
-(NSMutableArray *)data {
    if (!_data) {
        _data =[[NSMutableArray alloc] init];
    }
    return _data;
}
-(UITableView *)tabView {
    if (!_tabView) {
        _tabView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    }
    return _tabView;
}

-(void)initData {
    
    NSArray * listData =@[@[@"账号与安全",@"收货地址"],@[@"关于乐小转",@"意见反馈"]];
    [self.data addObjectsFromArray:listData];
    [self.tabView reloadData];
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //判断是否为商户
    [HKSetTool userIsAsShopsuccessBlock:^(id response) {
        self.shopId = response[@"data"][@"shopId"];
        
    } fail:^(NSString *error) {
        
    }];
    //是否实名认证了
    [HKSetTool userIsRealNamesuccessBlock:^(id response) {
       
        self.realNameState =response[@"data"][@"state"];
    } fail:^(NSString *error) {
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * sectionA =[self.data objectAtIndex:section];
    return  sectionA.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"TB"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier:@"TB"];
    }
    cell.accessoryType  =UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:15.f];
    cell.textLabel.textColor = RGB(51, 51, 51);
    NSString * titles =self.data[indexPath.section][indexPath.row];
    cell.textLabel.text = titles;
    return cell;
}

//跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                //账户与安全
                HKAccountVc *acc =[[HKAccountVc alloc] init];
                [self.navigationController pushViewController:acc animated:YES];
            }
                break;
            case 1:
            {
                HK_AddressInfoView *addreVC =[[HK_AddressInfoView alloc] init];
                [self.navigationController pushViewController:addreVC animated:YES];
            }
                break;
            case 2:
            {
               //隐私..
                HKBlacklistVc *vc =[[HKBlacklistVc alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section==1) {
        switch (indexPath.row) {
//            case 0:
//            {
//                if (self.realNameState.integerValue) {
//                    HKPersonAuthVc *person =[[HKPersonAuthVc alloc] init];
//                    person.state =self.realNameState.intValue;
//                    [self.navigationController pushViewController:person animated:YES];
//                }else {
//                    //实名认证
//                    HKRealNameAuthViewController * relaNmaeVC =[[HKRealNameAuthViewController alloc] init];
//                    [self.navigationController pushViewController:relaNmaeVC animated:YES];
//                }
//            }
             //   break;
            case 0:
            {
                HKAboutUsVc * aboutVC =[[HKAboutUsVc alloc] init];
                [self.navigationController pushViewController:aboutVC animated:YES];
//                if (self.shopId.length) {
//                    [EasyShowTextView showText:@"已经申请了"];
//                }else {
//                    //申请成为商家
//                    HKApplymerchantVc *appmechaVc =[[HKApplymerchantVc alloc] init];
//                    [self.navigationController pushViewController:appmechaVc animated:YES];
//                }
            }
                break;
            case 1:
            {
                // 意见反馈
                HKAdviceVc * comPlainVC =[[HKAdviceVc alloc] init];
                [self.navigationController pushViewController:comPlainVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section==2){
        switch (indexPath.row) {
            case  0:
            {
                //关于乐小转
                HKAboutUsVc * aboutVC =[[HKAboutUsVc alloc] init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            case 1:
            {
               // 意见反馈
                HKAdviceVc * comPlainVC =[[HKAdviceVc alloc] init];
                [self.navigationController pushViewController:comPlainVC animated:YES];
            }
                break;
            default:
                break;
        }
    }else  {
         //清除缓存....
        UIAlertController *aler =[UIAlertController alertControllerWithTitle:@"确认清理图片缓存?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOne  =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *actionTwo =[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [Toast loading];
            [self performSelector:@selector(clearMemory) withObject:nil afterDelay:1];
            
        }];
        [aler addAction:actionOne];
        [aler addAction:actionTwo];
        [self presentViewController:aler animated:YES completion:nil];
    }
}
//清除缓存
-(void)clearMemory {
    [Toast loaded];
    //清除图片缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [[SDImageCache sharedImageCache] clearMemory];//可不写
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * v =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
    v.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    return  v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  nil;
}

-(void)viewDidLayoutSubviews {
    if ([self.tabView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tabView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tabView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tabView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)setFoot {
    self.tabView.tableFooterView = self.footView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"设置";
    self.showCustomerLeftItem = YES;
    [self.view addSubview:self.tabView];
    [self initData];
    [self setFoot];
    
}
@end
