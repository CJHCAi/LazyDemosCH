//
//  HKCouponSubVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCouponSubVc.h"
#import "HKCouPonCell.h"
#import "HKOutDateCounCell.h"
#import "HKCounFooterView.h"
#import "HKCounponTool.h"
#import "HKCollageVC.h"
#import "HKCounponDetailVc.h"
#import "HKPersonCuponVc.h"
@interface HKCouponSubVc ()<UITableViewDelegate,UITableViewDataSource,CounDetailDelegete>
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong) UITableView * tablView;
@property (nonatomic, strong)NSMutableArray *btnArr;
@property (nonatomic, strong)UIView * bottomMoreView;
@property (nonatomic, strong)NSMutableArray * dataSource;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)HKCounFooterView * foo;
@property (nonatomic, strong)HKCouponResponse * response;
@property (nonatomic, strong)HKBVipCopunResponse *vipResponse;
@end

@implementation HKCouponSubVc

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource =[[NSMutableArray alloc] init];
    }
    return _dataSource;
}
-(NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr =[[NSMutableArray alloc] init];
    }
    return _btnArr;
}

-(HKCounFooterView *)foo {
    if (!_foo) {
        _foo =[[HKCounFooterView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,25)];
    }
    return _foo;
}
-(UIView *)topView {
    if (!_topView) {
         _topView=[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,40)];
        _topView.backgroundColor =[UIColor whiteColor];
        NSArray *  titles =@[@"未使用",@"使用记录",@"已过期"];
        CGFloat btnW = kScreenWidth /titles.count;
        for (int i=0; i<titles.count; i++) {
            UIButton * btn =[HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(i*btnW,0,btnW,CGRectGetHeight(_topView.frame)) title:titles[i] font:PingFangSCRegular15 taget:self action:@selector(swichRootView:) supperView:_topView];
            [btn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
            if (i==0) {
                btn.tag = 1;
                [btn setTitleColor:RGBA(239,89,60,1) forState:UIControlStateNormal];
            }else if (i==1){
                btn.tag =4;
            }else if (i==2){
                btn.tag =3;
            }
            [self.btnArr addObject:btn];
        }
    }
    return _topView;
}
//切换标题颜色和scollView的索引
-(void)swichRootView:(UIButton *)sender {
    for (UIButton * btn in self.btnArr) {
        [btn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
    }
    [sender setTitleColor:RGBA(239,89,60,1) forState:UIControlStateNormal];
    
    self.page = 1;
    self.state =sender.tag;
    [self.dataSource removeAllObjects];
    //发起请求.....
    [self loadData];
}
-(UITableView *)tablView {
    if (!_tablView) {
        _tablView =[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topView.frame),kScreenWidth,kScreenHeight -NavBarHeight -StatusBarHeight - 90-SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tablView.delegate = self;
        _tablView.dataSource = self;
        _tablView.separatorStyle = UITableViewCellSeparatorStyleNone;
         [_tablView registerClass:[HKCouPonCell class] forCellReuseIdentifier:@"HKP"];
        _tablView.backgroundColor = MainColor
        //_tablView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
       // [_tablView.mj_footer setHidden: YES];
    }
    return _tablView;
}
-(void)loadMoreData {
    self.page ++;
    [self loadData];
    
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return  2;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.01f;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKCouPonCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HKP" forIndexPath:indexPath];
    cell.delegete = self;
    cell.indexPath = indexPath;
    
    if ([self.vipResponse.data isKindOfClass:[NSNull class]]|| self.vipResponse.data==nil) {
        
        cell.model  = [self.dataSource objectAtIndex:indexPath.row];
    }else {

        if (self.dataSource.count>1) {
            HKVipData *data =[self.dataSource lastObject];
            if (indexPath.row==self.dataSource.count-1) {
                cell.vipData =data;
            }else {
                cell.model =[self.dataSource objectAtIndex:indexPath.row];
            }
        }else {
            cell.vipData =[self.dataSource objectAtIndex:indexPath.row];
        }
    }
    return cell;
}
#pragma mark 点击事件 ->劵详情.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HKCounponDetailVc *detail =[[HKCounponDetailVc alloc] init];
    HKCounList *list =[self.dataSource objectAtIndex:indexPath.row];
    detail.detailID =list.couponId;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark CounDetailDelegete
-(void)setClickDelegeteWithModel:(HKCounList *)model andSender:(NSInteger)index WithNSIndexPath:(NSIndexPath *)path {
    if (![model isKindOfClass:[HKCounList class]]) {
        if (index==2) {
            //出售
            [AppUtils dismissNavGationToTabbarWithIndex:2 currentController:self];
        }else {
           //到新人专享..
            HKPersonCuponVc *perVc=[[HKPersonCuponVc alloc] init];
            [self.navigationController pushViewController:perVc animated:YES];
        }
    }
    if (model.state==1) {
        if (index ==2) {
            //出售
            [AppUtils dismissNavGationToTabbarWithIndex:2 currentController:self];
        }else {
            //立即使用.._>商品详情.
            [AppUtils pushGoodsInfoDetailWithProductId:model.productId andCurrentController:self];
        }
    }else {
       //删除....
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"确认要删除吗?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *delete =[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteAddress:model.couponId withState:model.state withIndexPath:path];
        }];
        [alert addAction:actionCancel];
        [alert addAction:delete];
        [actionCancel setValue:RGB(153,153,153) forKey:@"_titleTextColor"];
        [delete setValue:keyColor forKey:@"_titleTextColor"];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}
#pragma mark 删除劵
-(void)deleteAddress:(NSString *)uid withState:(NSInteger)state withIndexPath:(NSIndexPath *)indexPath {
    [HKCounponTool deleteUserCounponWithCounponId:uid successBlock:^{
        
            [self.dataSource removeObjectAtIndex:indexPath.row];
            //再将此条cell从列表删除,_tableView为列表
            [self.tablView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (!self.dataSource.count) {
            self.tablView.tableFooterView =[[UIView alloc] init];
        }else {
            self.tablView.tableFooterView = self.foo;
        }
        
        if (self.state==3) {
            NSInteger count = self.response.data.totalRow -1;
            UIButton * B =[self.btnArr objectAtIndex:1];
            if (count) {
                [B setTitle:[NSString stringWithFormat:@"使用记录(%zd)",count] forState:UIControlStateNormal];
            }else {
                  [B setTitle:[NSString stringWithFormat:@"使用记录"] forState:UIControlStateNormal];
            }
        }else {
            NSInteger count = self.response.data.totalRow -1;
            UIButton * B =[self.btnArr objectAtIndex:2];
            if (count) {
                [B setTitle:[NSString stringWithFormat:@"已过期(%zd)",count] forState:UIControlStateNormal];
            }else {
                [B setTitle:[NSString stringWithFormat:@"已过期"] forState:UIControlStateNormal];
            }
        }
            [self.tablView reloadData];
    } fail:^(NSString *error) {
        
        [EasyShowTextView showText:@"操作失败"];
    }];
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
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [AppUtils setPopHidenNavBarForFirstPageVc:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"优惠券";
    self.view.backgroundColor =RGB(254,254, 254);
    [self setShowCustomerLeftItem:YES];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tablView];
    [self.view addSubview:self.bottomMoreView];
    self.page =1;
    self.state = 1;
    [self loadData];
}

-(void)loadVipData {
    [HKCounponTool getMyVipListWithState:self.state page:self.page successBlock:^(HKBVipCopunResponse *response) {
        self.vipResponse = response;
    
        if (response.data==nil ||[response.data isKindOfClass:[NSNull class]]) {
            //刷新顶部的数量
            [self refreshHeaderCountWithState:self.state andtotalCount:self.response.data.totalRow];
        }else {

            [self.dataSource addObject:response.data];
            [self refreshHeaderCountWithState:self.state andtotalCount:self.response.data.totalRow+1];
        }
        [self.tablView reloadData];
        
    } fail:^(NSString *error) {
        
    }];
}
-(void)loadData {
    
    [HKCounponTool getCounponListWithState:self.state page:self.page successBlock:^(HKCouponResponse *response) {
        self.response = response;
        [self.tablView.mj_header endRefreshing];
        
        if (self.page==1) {
              self.tablView.tableFooterView = self.foo;
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            [self.tablView.mj_footer setHidden:NO];
        }
        if (response.data.list.count) {
            [self.dataSource addObjectsFromArray:response.data.list];
            [self.tablView.mj_footer endRefreshing];
        }
        else
        {
            [self.tablView.mj_footer setHidden:YES];
            if (self.page!=1) {
                [EasyShowTextView showText:@"全部加载完毕"];
            }else {
                self.tablView.tableFooterView = [[UIView alloc] init];
            }
        }
        [self loadVipData];
    } fail:^(NSString *error) {
        [self.tablView.mj_header endRefreshing];
        [self.tablView.mj_footer endRefreshing];
    }];
}

-(void)refreshHeaderCountWithState:(NSInteger)state andtotalCount:(NSInteger)total {
   //取到对应的Btn
    UIButton * indexB ;
    if (state==1) {
        indexB  = [self.btnArr objectAtIndex:0];
        if (!total) {
            [indexB setTitle:@"未使用" forState:UIControlStateNormal];
        }else {
            [indexB setTitle:[NSString stringWithFormat:@"未使用(%zd)",total] forState:UIControlStateNormal];
        }
    }else if (state ==4){
        indexB  = [self.btnArr objectAtIndex:1];
        if (!total) {
            [indexB setTitle:@"使用记录" forState:UIControlStateNormal];
        }else {
            [indexB setTitle:[NSString stringWithFormat:@"使用记录(%zd)",total] forState:UIControlStateNormal];
        }
    }else {
        indexB =[self.btnArr objectAtIndex:2];
        if (!total) {
            [indexB setTitle:@"已过期" forState:UIControlStateNormal];
        }else {
            [indexB setTitle:[NSString stringWithFormat:@"已过期(%zd)",total] forState:UIControlStateNormal];
        }
    }
}
-(UIView *)bottomMoreView {
    if (!_bottomMoreView) {
        _bottomMoreView =[[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight-50-NavBarHeight -StatusBarHeight-SafeAreaBottomHeight,kScreenWidth,50)];
        _bottomMoreView.backgroundColor =RGB(254,254,254);
        NSArray * bTitle  =@[@"拼单抢劵",@"更多劵"];
        CGFloat btnW = kScreenWidth /2;
        
        for (int i=0; i< bTitle.count; i++) {
            UIButton * bottmB =[HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(i*btnW,0,btnW,CGRectGetHeight(_bottomMoreView.frame)) title:bTitle[i] font:PingFangSCRegular16 taget:self action:@selector(actionCoupon:) supperView:_bottomMoreView];
            bottmB.tag =i+200;
            [bottmB setTitleColor:keyColor forState:UIControlStateNormal];
            [_bottomMoreView addSubview:bottmB];
            if (i==0) {
                UIView * line =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bottmB.frame),0,1,50)];
                line.backgroundColor = RGB(226,226,226);
                [_bottomMoreView addSubview:line];
            }
        }
    }
    return _bottomMoreView;
}
#pragma  mark 底部Bar的点击事件
-(void)actionCoupon:(UIButton *)sender {
    if (sender.tag==200) {
        //进入拼单抢劵页面
        HKCollageVC * collvc =[[HKCollageVC alloc] init];
        [self.navigationController pushViewController:collvc animated:YES];
    }else {

        [AppUtils dismissNavGationToTabbarWithIndex:2 currentController:self];
    }
}
@end
