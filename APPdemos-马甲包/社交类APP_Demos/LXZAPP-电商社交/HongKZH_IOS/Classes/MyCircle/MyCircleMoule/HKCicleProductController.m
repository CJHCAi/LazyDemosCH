//
//  HKCicleProductController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCicleProductController.h"
#import "HKMyCircleViewModel.h"
#import "HKCicleProductHeadCell.h"
#import "HKFrindCicleInfoCell.h"
#import "HKCicleProductDetailCell.h"
#import "HKCicleProductTool.h"
#import "HKBaseCartListViewController.h"
#import "HKCicleHeadView.h"
#import "HKCollageShareView.h"
#import "HKShareBaseModel.h"
#import "CommodityDetailsViewController.h"
#import "CommodityDetailsRespone.h"
@interface HKCicleProductController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ProductSkuDelegete,BottomClickDelegete,SenderClickDelegete>
@property (nonatomic, strong)SDCycleScrollView *scollViews;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HKCicleProductResponse *response;
@property (nonatomic, strong)UILabel * indexLabel;
@property (nonatomic, strong)HKCicleProductTool *tool;
@property (nonatomic, strong)HKCicleHeadView *headNav;
@end

@implementation HKCicleProductController

-(void)viewWillDisappear:(BOOL)animated {
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)viewWillAppear:(BOOL)animated {
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,-StatusBarHeight,kScreenWidth,kScreenHeight+StatusBarHeight-SafeAreaBottomHeight-50) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.showsHorizontalScrollIndicator =NO;
        _tableView.bounces = NO;
      //注册cell.
        [_tableView registerClass:[HKCicleProductHeadCell class] forCellReuseIdentifier:@"head"];
        [_tableView registerClass:[HKFrindCicleInfoCell class] forCellReuseIdentifier:@"cicle"];
        [_tableView registerClass:[HKCicleProductDetailCell class] forCellReuseIdentifier:@"detail"];
    }
    return _tableView;
}

-(SDCycleScrollView *)scollViews {
    if (!_scollViews) {
        _scollViews =[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,kScreenWidth,350) delegate:self placeholderImage:nil];
        _scollViews.backgroundColor = RGB(242,242,242);
        _scollViews.showPageControl = NO;
        //增加一个Label显示当前的索引值..
        [_scollViews addSubview:self.indexLabel];
    }
    return _scollViews;
}
-(UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel =[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-15-44,CGRectGetHeight(self.scollViews.frame)-22-15,44,22)];
        [AppUtils getConfigueLabel:_indexLabel font:PingFangSCMedium14 aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@""];
        _indexLabel.text =[NSString  stringWithFormat:@"1/%lu",(unsigned long)self.response.data.images.count];
        _indexLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _indexLabel.layer.cornerRadius =10;
        _indexLabel.layer.masksToBounds =YES;
    }
    return _indexLabel;
}
-(HKCicleProductTool *)tool {
    if (!_tool) {
        _tool =[[HKCicleProductTool alloc] initWithFrame:CGRectMake(0,kScreenHeight-SafeAreaBottomHeight-50,kScreenWidth,50)];
        _tool.delegete =self;
    }
    return _tool;
}
#pragma mark 底部bar点击事件....
-(void)SeverBtnClick:(NSInteger)index {
    switch (index) {
        case 100:
        {
        //聊天...
            [AppUtils PushChatControllerWithType:ConversationType_PRIVATE uid:self.response.data.user.ID name:self.response.data.user.name headImg:self.response.data.user.headImg andCurrentVc:self];
        }
            break;
        case 200:
        {
            //进入购物车..
            HKBaseCartListViewController *baseCar =[[HKBaseCartListViewController alloc] init];
            [self.navigationController pushViewController:baseCar animated:YES];
        }
            break;
        case 300:
        {
          //加入购物车...
            NSDictionary * dic =[self.response mj_keyValues];
            CommodityDetailsRespone *respone =[CommodityDetailsRespone mj_objectWithKeyValues:dic];
            [HKSelectCommodityParametersViewController showVc:self respone:respone];
        }
            break;
        default:
            break;
    }
}

-(HKCicleHeadView *)headNav {
    if (!_headNav) {
        _headNav =[[HKCicleHeadView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,70)];
        _headNav.delegete = self;
    }
    return _headNav;
}
-(void)ClickSenderWithIndex:(NSInteger)index {
    if (index ==100) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        //分享商品..
        HKShareBaseModel * mdoel =[[HKShareBaseModel alloc] init];
        mdoel.subVc =self;
        HKMyGoodsModel * goodsModel =[[HKMyGoodsModel alloc] init];
        mdoel.shareType =SHARE_Type_GOODS;
        goodsModel.title =self.response.data.title;
        goodsModel.createDate = self.response.data.user.loginTime;
        HKCicleIMage *imageModel =self.response.data.images.firstObject;
        goodsModel.imgSrc =imageModel.imgSrc;
        goodsModel.isFormSelf = NO;
        goodsModel.productId = self.response.data.productId;
        mdoel.goodsModel = goodsModel;
        [HKCollageShareView showSelfBotomWithselectSheetBlock:nil shareModel:mdoel];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tool];
    [self.view addSubview:self.headNav];
    [self loadData];
   //获取购物车数量....
    [self getCarNumber];
}
-(void)getCarNumber {
    [HKMyCircleViewModel getCarNumberSuccess:^(id responde) {
        NSInteger count = [[responde objectForKey:@"data"] integerValue];
        self.tool.num  =count;
    }];
}
-(void)loadData {
    [HKMyCircleViewModel getCicleProductByProductId:self.productId success:^(HKCicleProductResponse *responde) {
        if (responde.code ==0) {
            self.response = responde;
            NSMutableArray * imageUrl =[[NSMutableArray alloc] init];
            for (HKCicleIMage *Images in self.response.data.images) {
                [imageUrl addObject:Images.imgSrc];
            }
            if (imageUrl.count) {
                self.scollViews.imageURLStringsGroup =imageUrl;
                self.tableView.tableHeaderView = self.scollViews;
            }
            self.tool.response  =self.response;
            [self.tableView reloadData];
        }else {
            [EasyShowTextView showText:@"数据请求失败"];
        }
    }];
}
-(void)showSkuView {
    NSDictionary * dic =[self.response mj_keyValues];
    CommodityDetailsRespone *respone =[CommodityDetailsRespone mj_objectWithKeyValues:dic];
    [HKSelectCommodityParametersViewController showVc:self respone:respone];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case  0:
            return 154;
            break;
       case 1:
            return 60;
            break;
       case 2:
            return 90;
            break;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        HKFrindCicleInfoCell * infoCell =[tableView dequeueReusableCellWithIdentifier:@"cicle" forIndexPath:indexPath];
        [AppUtils seImageView:infoCell.iconImageView withUrlSting:self.response.data.user.headImg placeholderImage:kPlaceholderHeadImage];
        infoCell.cicleNameLabel.text =self.response.data.user.name;
        infoCell.cicleNameLabel.font =BoldFont16;
        infoCell.tagLabel.text =self.response.data.user.loginTime;
        infoCell.row.hidden =NO;
        return infoCell;
    }else if (indexPath.section==2){
        HKCicleProductDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
        cell.res =self.response;
        return cell;
    }
    HKCicleProductHeadCell *cell =[tableView dequeueReusableCellWithIdentifier:@"head" forIndexPath:indexPath];
    cell.response = self.response;
    cell.delegete = self;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * footView =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
    footView.backgroundColor = RGB(239, 239, 239);
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0 ||section ==1) {
        return 8;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        HKMyFollowAndFansList *model =[[HKMyFollowAndFansList alloc] init];
        model.uid =self.response.data.user.ID;
        model.name =self.response.data.user.name;
        model.headImg =self.response.data.user.headImg;
        [AppUtils pushUserDetailInfoVcWithModel:model andCurrentVc:self];
    }
}

@end
