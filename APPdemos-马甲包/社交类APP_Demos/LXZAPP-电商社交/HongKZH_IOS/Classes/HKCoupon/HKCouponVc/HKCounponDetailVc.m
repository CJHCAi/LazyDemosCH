//
//  HKCounponDetailVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCounponDetailVc.h"
#import "HKCounDetailFootView.h"
#import "HKconPonCell.h"
#import "HKDetailTimeCell.h"
#import "HKShopCounCell.h"
#import "HKCounponTool.h"
#import "HKCollageShareView.h"
#import "HKCollageInfoToolBar.h"
#import "CountDown.h"
#import "HK_UserInfoDataModel.h"
#import "HK_orderTool.h"
#import "HKLaunchCollageVc.h"
#import "HK_PaymentActionSheet.h"
#import "HK_PaymentActionSheetTwo.h"
#import "HKNewPerSonTool.h"
#import "HKShareBaseModel.h"
@interface HKCounponDetailVc ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HKCollageInfoToolBarDelegate,HK_PaymentActionSheetDelegate,HK_PaymentActionSheetTwoDelegate>
@property (nonatomic, strong)HKCounDetailFootView * footView;
@property (nonatomic, strong)SDCycleScrollView *scrollView;
@property (nonatomic, strong)UITableView *tableView;
//优惠券
@property (nonatomic, strong)HKMyCopunDetailResponse *response;
//拼团
@property (nonatomic, strong)HKCollageResPonse * collageRes;
//新人折扣劵
@property (nonatomic, strong)HKUserVipResponse *vipResponse;
@property (nonatomic, strong)HKCollageInfoToolBar * infoBar;
@property (nonatomic, strong)CountDown * countDown;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)NSMutableArray * imageSource;
@property (nonatomic, strong)UILabel * indexLabel;
//订单ID
@property (nonatomic, copy) NSString *orderId;
@end
@implementation HKCounponDetailVc

-(NSMutableArray *)imageSource {
    if (!_imageSource) {
        _imageSource =[[NSMutableArray alloc] init];
    }
    return _imageSource;
}
-(SDCycleScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,kScreenWidth,350) delegate:self placeholderImage:nil];
        _scrollView.backgroundColor = RGB(242,242,242);
        _scrollView.showPageControl = NO;
        //增加一个Label显示当前的索引值..
        [_scrollView addSubview:self.indexLabel];
    }
    return _scrollView;
}
-(UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-44,CGRectGetHeight(self.scrollView.frame)-22-15,44,22)];
        [AppUtils getConfigueLabel:_indexLabel font:PingFangSCMedium14 aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@""];
        _indexLabel.text =[NSString  stringWithFormat:@"1/%lu",(unsigned long)self.imageSource.count];
        _indexLabel.backgroundColor = RGB(155,155,155);
        _indexLabel.layer.cornerRadius =10;
        _indexLabel.layer.masksToBounds =YES;
    }
    return _indexLabel;
}
-(HKCounDetailFootView *)footView {
    if (!_footView) {
        _footView =[[HKCounDetailFootView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,120)];
    }
    return _footView;
}
-(UITableView *)tableView {
    if (!_tableView) {
        if (self.hasToolBar) {
            _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight-50-SafeAreaBottomHeight) style:UITableViewStylePlain
                         ];
        }else {
            _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight) style:UITableViewStylePlain
                         ];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView =self.footView;
        _tableView.backgroundColor = MainColor
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = YES;
       //155.....
        [_tableView registerClass:[HKconPonCell class] forCellReuseIdentifier:@"con"];
       // 50...
        [_tableView registerClass:[HKDetailTimeCell class] forCellReuseIdentifier:@"timeEnd"];
       //150....
        [_tableView registerClass:[HKShopCounCell class] forCellReuseIdentifier:@"shopD"];
        
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return  4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        HKconPonCell * cell =[tableView dequeueReusableCellWithIdentifier:@"con" forIndexPath:indexPath];
        if (self.response) {
              cell.response = self.response;
        }else if (self.collageRes) {
              cell.collageRes = self.collageRes;
        }else {
            cell.vipResponse = self.vipResponse;
        }
        return cell;
    }else if (indexPath.section==1) {
        HKDetailTimeCell *timeCell =[tableView dequeueReusableCellWithIdentifier:@"timeEnd" forIndexPath:indexPath];
        self.indexPath =indexPath;
        if (self.response) {
               timeCell.endStr = self.response.data.endTime;
        }else if (self.collageRes){
            timeCell.endStr = self.collageRes.data.endTime;
            
            [timeCell setTeamNumber:self.collageRes.data.num];
        }else  {
           // [timeCell clearText];
        }
        return timeCell;
        
    }else if (indexPath.section ==2) {
        HKShopCounCell *shopCell =[tableView dequeueReusableCellWithIdentifier:@"shopD" forIndexPath:indexPath];
        shopCell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        if (self.response) {
                shopCell.response = self.response;
        }else if (self.collageRes) {
            shopCell.collageRes = self.collageRes;
        }else {
            shopCell.vipResponse = self.vipResponse;
        }
        return shopCell;
    }else if (indexPath.section ==3) {
        return [[UITableViewCell alloc] init];
    }
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"tips"];
    if (cell==nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tips"];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"咨询与售后";
        cell.textLabel.textColor =RGB(51,51,51);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
         return cell;
}
#pragma mark 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
   //商品详情
        NSString *productId;
        if (self.response) {
            productId =self.response.data.productId;
        }else if (self.collageRes) {
            productId =self.collageRes.data.productId;
        }else if (self.vipResponse){
            productId = self.vipResponse.data.productId;
        }
        [AppUtils pushGoodsInfoDetailWithProductId:productId andCurrentController:self];
        
    }else if (indexPath.section==3) {
        [EasyShowTextView showText:@"咨询与售后"];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case  0:
            return 155;
            break;
        case  1:
        {
            if (self.hasToolBar && self.isVipUser) {
                return 0;
            }
             return 50;
        }
            break;
        case 2:
            return 150;
            break;
        case 3:
            return 0;
            break;
        default:
            break;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hasToolBar && self.isVipUser && section==1) {
        return 0;
    }else if (section==3) {
        return 0;
    }
       return 1;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [HK_BaseRequest buildPostRequest:get_usergetUserIntegral body:@{kloginUid:LOGIN_UID} success:^(id  _Nullable responseObject) {
        HK_UserInfoDataModel * model =[HK_UserInfoDataModel mj_objectWithKeyValues:responseObject];
        if (!model.code) {
            id interger =model.data;
            if ([interger isKindOfClass:[NSNull class]]) {
                [LoginUserData sharedInstance].integral =0;
            }else {
                [LoginUserData sharedInstance].integral =model.data.integral;
            }
        }else {
            [EasyShowTextView showText:@"获取用户乐币失败"];
        }
    } failure:^(NSError * _Nullable error) {
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.showCustomerLeftItem = YES;
    self.view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [AppUtils addBarButton:self title:@"分享" action:@selector(alertShare) position:PositionTypeRight];
    if (self.hasToolBar) {
        if (self.isVipUser) {
            self.title =@"商品折扣劵";
            [self.view addSubview:self.infoBar];
            [self loadVipData];
            
        }else {
            //获取拼团详情
            self.title = @"拼团详情";
            //获取拼团详情
            [self.view addSubview:self.infoBar];
            [self loadCollageData];
          
        }
    }else {
         self.title = @"劵详情";
       //获取劵详情
        [self loadCountData];
    }
    self.countDown = [[CountDown alloc] init];
    ///每秒回调一次
    [self.countDown countDownWithPER_SECBlock:^{
        
        [self updateTimeInVisibleCells];
    }];
}
-(void)updateTimeInVisibleCells {
    if (self.indexPath) {
        HKDetailTimeCell *cell =[self.tableView cellForRowAtIndexPath:self.indexPath];
        if (self.response) {
            cell.endStr = self.response.data.endTime;
        }else {
          cell.endStr = self.collageRes.data.endTime;
        }
    }
}
-(void)toolBlock:(NSInteger)sender{
    switch (sender) {
        case  100:
            [EasyShowTextView showText:@"联系客服"];
            break;
        case  200:
            [EasyShowTextView showText:@"收藏"];
            break;
        case 300:
        {
             [self showPayViews];
        }
            break;
        default:
            break;
    }
}
-(HKCollageInfoToolBar *)infoBar {
    if (!_infoBar) {
        _infoBar =[[HKCollageInfoToolBar alloc] initWithFrame:CGRectMake(0,kScreenHeight-NavBarHeight-StatusBarHeight-50-SafeAreaBottomHeight,kScreenWidth,50)
                   ];
        _infoBar.delegate =self;
        if (self.isVipUser) {
            [_infoBar RefreshToolBarUI];
        }
    }
    return _infoBar;
}
-(void)pop {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 购买折扣劵失败提示...
-(void)alertContollerTip {
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"您没有新人专享资格劵无法获得参与抢购机会!"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:RGB(51,51,51) range:NSMakeRange(0, alertControllerStr.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, alertControllerStr.length)];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:keyColor range:NSMakeRange(3,7)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    UIAlertAction *cancleA =[UIAlertAction actionWithTitle:@"返回首页" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [cancleA setValue:RGB(153,153,153) forKey:@"titleTextColor"];
    [alertController addAction:cancleA];
    UIAlertAction *define =[UIAlertAction actionWithTitle:@"去集市" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [AppUtils dismissNavGationToTabbarWithIndex:2 currentController:self];
        
    }];
    [define setValue:keyColor forKey:@"titleTextColor"];
    [alertController addAction:define];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)rechargeCallback{
    HK_RechargeController * reVc =[[HK_RechargeController alloc] init];
    [self.navigationController pushViewController:reVc animated:YES];
}
-(void)paymentCallback{
    
    if (self.isVipUser) {
        //新人专享接口
        [HKCounponTool buyNewUserVipCuponWithVipCouponId:self.detailID successBlock:^(NSString *response) {
            [EasyShowTextView showText:@"购买成功"];
            [self performSelector:@selector(pop) withObject:nil afterDelay:1.5];
        } fail:^(NSString *error) {
            
            [self alertContollerTip];
        }];
    }else {
        [HKCounponTool buyCollageOrderWithCollageCounId:self.detailID successBlock:^(NSString *response) {
            self.orderId = response;
            [self lunchCollage];
            
        } fail:^(NSString *error) {
            HKLaunchCollageVc * lucnVc =[[HKLaunchCollageVc alloc] init];
            lucnVc.successLunch = NO;
            lucnVc.failMessage = error;
            lucnVc.intergal=self.collageRes.data.integral;
            [self.navigationController pushViewController:lucnVc animated:YES];
        }];
    }
}
#pragma mark 支付....
-(void)showPayViews {
    //1.获取用户乐币
    NSInteger userIntergal =[LoginUserData sharedInstance].integral;
    NSInteger count = self.collageRes.data.integral ? self.collageRes.data.integral:self.vipResponse.data.integral;
    if (userIntergal>=count) {
        //弹出支付界面
        HK_PaymentActionSheet *payment = [HK_PaymentActionSheet showInView:self.navigationController.view];
        [payment configueCellWithTotalCount:count];
        payment.delegate = self;
        
    }else {
        //弹出充值
        HK_PaymentActionSheetTwo *recharge = [HK_PaymentActionSheetTwo showInView:self.navigationController.view];
        recharge.delegate = self;
        [recharge configueCellWithTotalCount:count];
        
    }
}
#pragma mark 发起拼团...
-(void)lunchCollage {
    //支付-->吊拼团接口..
    [HKCounponTool buyCollageByOrderId:self.orderId successBlock:^{
        HKLaunchCollageVc * lucnVc =[[HKLaunchCollageVc alloc] init];
        lucnVc.successLunch = YES;
        lucnVc.orderId =self.orderId;
        [self.navigationController pushViewController:lucnVc animated:YES];
    } fail:^(NSString *error) {
        HKLaunchCollageVc * lucnVc =[[HKLaunchCollageVc alloc] init];
        lucnVc.successLunch = NO;
        lucnVc.failMessage = error;
        lucnVc.intergal=self.collageRes.data.integral;
        [self.navigationController pushViewController:lucnVc animated:YES];
    }];
}
-(void)alertShare {
    id model;
    if (self.response) {
        model = self.response;
    }else if (self.collageRes) {
        model = self.collageRes;
    }else {
        model = self.vipResponse;
    }
    [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:[HKCounponTool getShareModelFromResponse:model controller:self]];
}
-(void)loadVipData {
    [HKNewPerSonTool getUserVipDetailWithVipCouponId:self.detailID SuccessBlock:^(HKUserVipResponse *renponse) {
        self.vipResponse = renponse;
        NSMutableArray *imgArr =[[NSMutableArray alloc] init];
        if (renponse.data.imgs.count) {
            for (HKUserVipList *model in renponse.data.imgs) {
                [imgArr addObject:model.imgSrc];
                [self.imageSource addObject:model];
            }
        }
        if (imgArr.count) {
            self.scrollView.imageURLStringsGroup = imgArr;
            self.tableView.tableHeaderView = self.scrollView;
        }
        [self.infoBar setCountLabelWithNumber:self.vipResponse.data.integral];
        [self.tableView reloadData];
    } fail:^(NSString *error) {
        
    }];
}
-(void)loadCollageData {
    [HKCounponTool getCollageDetailCounponId:self.detailID successBlock:^(HKCollageResPonse *response) {
        self.collageRes = response;
        NSMutableArray *imgArr =[[NSMutableArray alloc] init];
        if (response.data.imgs.count) {
            for (HKCollageImgs *model in response.data.imgs) {
                [imgArr addObject:model.imgSrc];
                [self.imageSource addObject:model];
            }
        }
        if (imgArr.count) {
            self.scrollView.imageURLStringsGroup = imgArr;
            self.tableView.tableHeaderView = self.scrollView;
            
        }
        [self.tableView reloadData];
    } fail:^(NSString *error) {
    }
     ];
}
-(void)loadCountData {
    [HKCounponTool getCouponDetailWithCounponId:self.detailID successBlock:^(HKMyCopunDetailResponse *response) {
        self.response = response;
        NSMutableArray *imgArr =[[NSMutableArray alloc] init];
        if (response.data.imgs.count) {
            for (HKMycopunImgs *model in response.data.imgs) {
                [imgArr addObject:model.imgSrc];
                [self.imageSource addObject:model];
            }
        }
        if (imgArr.count) {
            self.scrollView.imageURLStringsGroup = imgArr;
            self.tableView.tableHeaderView = self.scrollView;
        }
        [self.tableView reloadData];
    } fail:^(NSString *error) {
        
    }];
}
#pragma mark SDScollViewDelegete
//滑动到索引
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    self.indexLabel.text =[NSString stringWithFormat:@"%ld/%lu",index+1,(unsigned long)self.imageSource.count];
}
//点击 ->进入商品详情
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *productId;
    if (self.response) {
        HKMycopunImgs * model = self.response.data.imgs[index];
        productId = model.productId;
    }else if (self.collageRes) {
        HKCollageImgs * model = self.collageRes.data.imgs[index];
        productId = model.productId;
    }else if (self.vipResponse) {
        HKUserVipList *model =  self.vipResponse.data.imgs[index];
        productId = model.productId;
    }
    [AppUtils pushGoodsInfoDetailWithProductId:productId andCurrentController:self];
}
@end
