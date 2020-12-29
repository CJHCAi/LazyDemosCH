//
//  HK_ShopsDetailVc.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_ShopsDetailVc.h"
#import "HK_shopsDetailCell.h"
#import "HKShopHeadView.h"
#import "FFDropDownMenuView.h"
#import "HKShopTool.h"
#import "HKShopMessageVc.h"
#import "HKBaseCartListViewController.h"
@interface HK_ShopsDetailVc ()<sectionClickDelegete,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray *dataSoure;
@property(nonatomic,strong)FFDropDownMenuView *dropdownMenu;
@property (nonatomic, strong)HKShopHeadView *head;
@property (nonatomic, strong)HKShopInfo *infoData;
@end

@implementation HK_ShopsDetailVc

-(NSMutableArray *)dataSoure {
    if (!_dataSoure) {
        _dataSoure =[[NSMutableArray alloc] init];
    }
    return _dataSoure;
}
-(void)saveBlock:(HKShopResponse *)response{
    [HKShopTool collectionShopOrNot:response successBlock:^{
        if (response.data.isCollect) {
            
            [self->_head.saveBtn setImage:[UIImage imageNamed:@"dp_sc"] forState:UIControlStateNormal];
            self->_head.response.data.isCollect =0;
            [EasyShowTextView showText:@"取消收藏"];
        }else {
            [self->_head.saveBtn setImage:[UIImage imageNamed:@"dp_ysc"] forState:UIControlStateNormal];
            self->_head.response.data.isCollect =1;
            [EasyShowTextView showText:@"收藏成功"];
        }
    } fail:^(NSString *error) {
        [EasyShowTextView showText:error];
    }];
}
-(HKShopHeadView *)head {
    if (!_head) {
        _head =[[HKShopHeadView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,152)];
        _head.delegete = self;
       
    }
    return _head;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight -NavBarHeight -StatusBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HK_shopsDetailCell class] forCellReuseIdentifier:@"detail"];
        _tableView.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.scrollEnabled = NO;
        _tableView.tableHeaderView = self.head;
        self.head.response= self.response;
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HK_shopsDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    if (indexPath.section==0 && indexPath.row==0) {
        cell.tagLabel.text = @"联系客服";
        cell.rowImageV.hidden =NO;
        cell.messageLabel.hidden =YES;
        cell.rowImageV.image =[UIImage imageNamed:@"dpxq_kf"];
    }else if (indexPath.section==0 && indexPath.row ==1) {
        cell.tagLabel.text = @"店铺二维码";
        cell.rowImageV.hidden =NO;
        cell.messageLabel.hidden =YES;
        cell.rowImageV.image =[UIImage imageNamed:@"dpxq_ewm"];
    }else if (indexPath.section==1 && indexPath.row==0) {
        cell.tagLabel.text = @"店铺简介";
        cell.rowImageV.hidden =YES;
        cell.messageLabel.hidden =NO;
        cell.messageLabel.text =@"本店主营服饰，手工制作";
    }else {
        cell.tagLabel.text = @"开店时间";
        cell.rowImageV.hidden =YES;
        cell.messageLabel.hidden =NO;
        cell.messageLabel.text =self.infoData.data.createDate.length ?self.infoData.data.createDate : @"2018-9-18";
    }
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
     return  nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
    UIView * v =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,10)];
    v.backgroundColor =UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    return  v;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        [EasyShowTextView showText:@"联系客服"];
    }else if (indexPath.section==0 && indexPath.row==1) {
        [EasyShowTextView showText:@"查看店铺二维码"];
    }
}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
#pragma mark 获取店铺最新信息
    [self loadDetailInfo];
//    //设置不透明导航栏
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
//    [self.navigationController.navigationBar setShadowImage:nil];
//
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [AppUtils setPopHidenNavBarForFirstPageVc:self];
}

-(void)initNav {
    UIButton * moreBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0,0,40,40);
    [moreBtn setImage:[UIImage imageNamed:@"xq_gwc"] forState:UIControlStateNormal];
    UIBarButtonItem * itemMore =[[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    [moreBtn addTarget:self action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = itemMore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showCustomerLeftItem = YES;
    self.title =@"店铺详情";
    [self initNav];
    [self dropMenu];
    [self.view addSubview:self.tableView];
}
-(void)loadDetailInfo {
    [HKShopTool getShopDetailInfoWithShopId:self.response.data.shopId SuccessBlock:^(HKShopInfo *response) {
        self.infoData = response;
        self.head.info = response;
        [self.tableView reloadData];
    } fail:^(NSString *error) {
         [EasyShowTextView showText:error];
    }];
}
#pragma mark  初始化下拉菜单
-(void)dropMenu {
    NSArray *modelsArray =[self  getMenuModelsArray];
    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:130 eachItemHeight:45 menuRightMargin:15 triangleRightMargin:15];
    self.dropdownMenu.titleColor = [UIColor whiteColor];
    self.dropdownMenu.titleFontSize =15;
    self.dropdownMenu.menuRightMargin =15;
    self.dropdownMenu.menuItemBackgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.dropdownMenu.triangleColor =[[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.dropdownMenu.triangleSize =CGSizeMake(15, 8);
    
    self.dropdownMenu.ifShouldScroll = NO;
    [self.dropdownMenu setup];
}
/** 获取菜单模型数组 */
- (NSArray *)getMenuModelsArray {
   // __weak typeof(self) weakSelf = self;
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"消息" menuItemIconName:@"dp_xx"  menuBlock:^{
        HKShopMessageVc * messageVc =[[HKShopMessageVc alloc] init];
        messageVc.messageType = 2;
        [self.navigationController pushViewController:messageVc animated:YES];
        
    }];
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"首页" menuItemIconName:@"dp_sy" menuBlock:^{
        //不加主线程会造成 present 延迟弹出界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    FFDropDownMenuModel *menuModel2 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"搜索" menuItemIconName:@"dp_ss"  menuBlock:^{
        //调到搜索界面....
        [AppUtils pushGoodsSearchWithCurrentVc:self];
    }];
    FFDropDownMenuModel *menuModel3 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"我的关注" menuItemIconName:@"dp_wdgz"  menuBlock:^{
        HKShopMessageVc * messageVc =[[HKShopMessageVc alloc] init];
        messageVc.messageType = 1;
        [self.navigationController pushViewController:messageVc animated:YES];
        
    }];
    FFDropDownMenuModel *menuModel4 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"浏览记录" menuItemIconName:@"dp_lljl"  menuBlock:^{
        
        
    }];
    NSArray *menuModelArr = @[menuModel0, menuModel1,menuModel2,menuModel3,menuModel4];
    return menuModelArr;
}
#pragma mark 跳转购物车..
-(void)showMenuView {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKBaseCartListViewController *carVc =[[HKBaseCartListViewController alloc] init];
    [self.navigationController pushViewController:carVc animated:YES];
    
   // [self.dropdownMenu showMenu];
}

@end
