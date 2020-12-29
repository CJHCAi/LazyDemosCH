//
//  HKCollageDetailVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCollageDetailVc.h"
#import "HKCollageDetailHeaderCell.h"
#import "HKCollageDetailOrderCell.h"
#import "HKColageFriendCell.h"
#import "HK_orderShopFooterView.h"
#import "HKCollageShareView.h"
#import "HKShareBaseModel.h"
#import "HKCounponTool.h"
#import "CountDown.h"
#import "HK_orderTool.h"
@interface HKCollageDetailVc ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)HK_orderShopFooterView * footViews;
@property (nonatomic, strong)HKCollageOrderResponse *response;
@property (nonatomic, strong)CountDown * countDown;
@property (nonatomic, strong)NSIndexPath *indexPath;
@end

@implementation HKCollageDetailVc
-(HK_orderShopFooterView *)footViews {
    if (!_footViews) {
        _footViews =[[HK_orderShopFooterView alloc] initWithFrame:CGRectMake(0,kScreenHeight-48-NavBarHeight-StatusBarHeight-SafeAreaBottomHeight,kScreenWidth,48)];
        _footViews.layer.borderWidth =1;
        _footViews.layer.borderColor  =[[UIColor colorFromHexString:@"cccccc"] CGColor];
        [_footViews.rightBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        [_footViews.rightBtn addTarget:self action:@selector(contactSaler) forControlEvents:UIControlEventTouchUpInside];
        _footViews.leftBtn.hidden =NO;
        [_footViews.leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_footViews.leftBtn addTarget:self action:@selector(cancleOrder) forControlEvents:UIControlEventTouchUpInside];
        if (!self.isFromOrder) {
            _footViews.leftBtn.hidden =YES;
        }
    }
    return _footViews;
}
#pragma mark  联系卖家
-(void)contactSaler {
    [EasyShowTextView showText:@"联系卖家"];
}
#pragma mark 取消订单
-(void)cancleOrder {
   //验证时间 是否超过.... 当前时间 和订单结束时间比较.....
    NSTimeInterval time =[HK_orderTool AgetCountTimeWithString:self.response.data.endDate andNowTime:self.response.data.currentTime];
    
    DLog(@"...time=%.f...结束时间==%@...当前时间==%@",time,self.response.data.endDate,self.response.data.currentTime);
    
    if (time >0) {
        [HK_orderTool cancelUserOderWithOrderNumber:self.orderId handleBlock:^{
            if (self.isFromOrder) {
                if (self.block) {
                    self.block();
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else {
                Class HKCollageVc = NSClassFromString(@"HKCollageVC");
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[HKCollageVc class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            }
        } failError:^(NSString *msg) {
            [EasyShowTextView showText:@"操作失败"];
        }];
    }else {
        [self alertCancelFail];
    }  
}
#pragma mark 取消订单失败
-(void)alertCancelFail {
    UIAlertController *alertV =[UIAlertController alertControllerWithTitle:@"暂时无法取消订单" message:@"发起拼单半小时后，若未拼单成功将自动取消订单并退还乐币哦" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [action setValue:keyColor forKey:@"titleTextColor"];
    [alertV addAction:action];
    [self presentViewController:alertV animated:YES completion:nil];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-48-SafeAreaBottomHeight) style:UITableViewStyleGrouped
                         ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MainColor
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator =NO;
        [_tableView registerClass:[HKColageFriendCell class] forCellReuseIdentifier:@"friend"];
        [_tableView registerClass:[HKCollageDetailHeaderCell class] forCellReuseIdentifier:@"header"];
        [_tableView registerNib:[UINib nibWithNibName:@"HKCollageDetailOrderCell" bundle:nil] forCellReuseIdentifier:@"order"];
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        HKColageFriendCell * sucCell =[tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
        sucCell.response = self.response;
        
        return sucCell;
    }else if (indexPath.section ==2) {
        HKCollageDetailOrderCell *orderCell=[tableView dequeueReusableCellWithIdentifier:@"order" forIndexPath:indexPath];
        orderCell.response = self.response;
        return orderCell;
    }
    HKCollageDetailHeaderCell *headerCell =[tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
    headerCell.response = self.response;
    self.indexPath = indexPath;
    headerCell.block = ^{
        
        HKShareBaseModel*shareM = [[HKShareBaseModel alloc]init];
        shareM.copun = self.response;
        shareM.subVc = self;
        [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:shareM];
    };
    return headerCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        return 155;
    }else if (indexPath.section==2){
        return 130;
    }
    return 270;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     return 0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
     return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * v =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
    v.backgroundColor = MainColor;
    return v;
}
-(void)viewWillAppear:(BOOL)animated {
        //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"拼单详情";
    self.view.backgroundColor =[UIColor whiteColor];
    self.showCustomerLeftItem =YES;
    [self.view addSubview:self.footViews];
    [self.view addSubview:self.tableView];
    [self getOrderInfo];
    self.countDown = [[CountDown alloc] init];
    ///每秒回调一次
    [self.countDown countDownWithPER_SECBlock:^{
        
        [self updateTimeInVisibleCells];
    }];
}

-(void)updateTimeInVisibleCells {
    if (self.indexPath) {
        
        HKCollageDetailHeaderCell  *cell =[self.tableView cellForRowAtIndexPath:self.indexPath];
         cell.response = self.response;
    }
}
-(void)getOrderInfo {
    [HKCounponTool getCollageOrderInfo:self.orderId successBlock:^(HKCollageOrderResponse *response) {
        self.response = response;
        [self.tableView reloadData];
        
    } fail:^(NSString *error) {
        
    }];
}
@end
