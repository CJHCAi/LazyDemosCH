//
//  ViewController.m
//  IOS_ShopDetail
//
//  Created by 苟应航 on 2018/8/20.
//  Copyright © 2018年 GH. All rights reserved.
//

#import "ViewController.h"

#define headViewHeight 600*SCALEWITH6
#define indexHeightShop SCREEN_HEIGHT==812?70:60

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,JoinShoppingVIewDelegate,scrollDelegate>
{
    ShopImageDetailController *_imgController; // 图片详情
    ShopHotController *_hotController;// 热门推荐
    ShopCommentsController *_commController;// 评论
    ShopNavView *_navheadview; // 导航view
    
    UIButton *_joinSoppingbtn;//加入购物车
    
    UIButton *_bayshop;//立即购买
    
    UILabel *_numberlabes; //购物车numberlabe
    UIView *_endheadview; // 底部的view
}
@property(nonatomic,strong)JoinShoppingVIew *popShopView; // 购物车 弹框

@property(nonatomic,strong)MainTouchTableVIew *tableview;  // 父控件

@property(nonatomic,retain)NSMutableArray *titleArr;

@property(nonatomic,retain)NSMutableArray *vcArr;

@property(nonatomic,retain)SelecterToolsScrolView *selectTools;

@property(nonatomic,retain)SelecterContentScrollView *contentScrView;

@property(nonatomic,strong)ShopHeadDetailView *headview;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveMainTableView;

@property (nonatomic, assign) BOOL isTopIsCanNotMoveParentScrollView;

@property(nonatomic,strong) UIScrollView * parentScrollView;
@end

@implementation ViewController

-(MainTouchTableVIew *)tableview{
    if (_tableview==nil) {
        _tableview=[[MainTouchTableVIew alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-(SCREEN_HEIGHT==812?70:60)) style:UITableViewStylePlain];
        _tableview.showsVerticalScrollIndicator=NO;
        _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        _tableview.dataSource=self;
        //支持下刷新。关闭弹簧效果
        _tableview.bounces =  NO;
        _tableview.delegate=self;
        [self.view addSubview:_tableview];
    }
    return _tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableview];
    [self loadsearchViewUI];
    [self loadheadview];
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.canScroll = YES;
    [self.tableview setContentOffset:CGPointMake(0, -headViewHeight) animated:YES];
    [self.tableview addSubview:self.headview];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 【头部导航】
-(void)loadsearchViewUI{
    _navheadview=[[ShopNavView alloc]init];
    _navheadview.titilelabe.text=@"商品详情";
    //    _navheadview.backgroundColor=LDrgba(16, 16, 16, 0.25);
    [self.view addSubview:_navheadview];
}
#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT-(SCREEN_HEIGHT==812?70:60)+1-SafeAreaTopHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
    [cell.contentView addSubview:self.loadViewUI];
    return cell;
}

-(UIView *)loadViewUI{
    _titleArr = [NSMutableArray array];
    _vcArr = [NSMutableArray array];
    NSArray *subTitle = [NSArray arrayWithObjects:@"商品详情",@"购买记录",@"热销推荐",nil]; //RevisionofTSupplyChaincontroller.h ThesupplychainVixxewController
    NSArray *cellType = [NSArray arrayWithObjects:@"ShopImageDetailController", @"ShopCommentsController",@"ShopHotController",nil];
    for (int i=0; i<subTitle.count; i++) {
        [_titleArr addObject:subTitle[i]];
        if ([cellType[i] isEqualToString:@"ShopImageDetailController"]) {
            _imgController = [[ShopImageDetailController alloc]init];
            _imgController.delegate=self;
            [self addChildViewController:_imgController];
            [_vcArr addObject:_imgController];
        }else if ([cellType[i] isEqualToString:@"ShopCommentsController"]) {
            _commController = [[ShopCommentsController alloc]init];
            _commController.delegate=self;
            [self addChildViewController:_commController];
            [_vcArr addObject:_commController];
        }else{
            _hotController = [[ShopHotController alloc]init];
            _hotController.delegate=self;
            
            [self addChildViewController:_hotController];
            [_vcArr addObject:_hotController];
        }
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    __weak typeof(self) weakSelf = self;
    _selectTools=[[SelecterToolsScrolView alloc]initWithSeletershopdetails:_titleArr andBool:NO andBtnBlock:^(UIButton *btn) {
        [weakSelf updateVCViewFrom:btn.tag];
    }];
    [view addSubview:_selectTools];
    
    _contentScrView = [[SelecterContentScrollView alloc]initWithSeleterinitWithSeleterWineWarehouse:_vcArr  Bool:NO andBtnBlock:^(int index) {
        [weakSelf updateSelectToolsIndex:index];
    }];
    [view addSubview:_contentScrView];
    
    UILabel *leanlabea=[UILabel new];
    leanlabea.backgroundColor=lencolor;
    [view addSubview:leanlabea];
    [leanlabea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(view.mas_top).mas_offset(Heightscrooler-1);
        make.height.mas_equalTo(1);
    }];
    
    
    return view;
    
}

-(void)updateSelectToolsIndex:(NSInteger)index
{
    [_selectTools updateSelecterToolsIndex:index];
}
-(void)updateVCViewFrom:(NSInteger )index
{
    [_contentScrView updateVCViewFromIndex:index];
}
#pragma mark -【底部购物车view】
-(void)loadheadview{
    
    UIView *endheadview=[UIView new];
    endheadview.backgroundColor=Kwhite;
    [self.view addSubview:endheadview];
    _endheadview=endheadview;
    [endheadview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(indexHeightShop);
    }];
    
    UILabel *topleanlabe=[UILabel new];
    topleanlabe.backgroundColor=lencolor;
    [endheadview addSubview:topleanlabe];
    [topleanlabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    UIImageView *gotoShoppingCart=[UIImageView new];
    gotoShoppingCart.userInteractionEnabled=YES;
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(puchgotoshop)];
    [gotoShoppingCart addGestureRecognizer:taps];
    gotoShoppingCart.image=GHImage(@"gotoShoppingCart");
    [endheadview addSubview:gotoShoppingCart];
    [gotoShoppingCart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*SCALEWITH6);
        make.centerY.mas_equalTo(endheadview.mas_centerY);
        make.width.height.mas_equalTo(25*SCALEWITH6);
    }];
    _numberlabes=[UILabel new];
    _numberlabes.layer.masksToBounds=YES;
    _numberlabes.textColor=Kwhite;
    _numberlabes.textAlignment=NSTextAlignmentCenter;
    _numberlabes.font=GHFont(8);
    _numberlabes.layer.cornerRadius=8;
    [endheadview addSubview:_numberlabes];
    [_numberlabes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.top.mas_equalTo(gotoShoppingCart.mas_top).mas_offset(-7);
        make.right.mas_equalTo(gotoShoppingCart.mas_right).mas_offset(14);
    }];
    UILabel *leanlabe=[UILabel new];
    leanlabe.backgroundColor=lencolor;
    [endheadview addSubview:leanlabe];
    [leanlabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(gotoShoppingCart.mas_right).mas_offset(20*SCALEWITH6);
        make.centerY.mas_equalTo(endheadview.mas_centerY);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *joinSoppingbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [joinSoppingbtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [joinSoppingbtn setTitleColor:Kwhite forState:UIControlStateNormal];
    joinSoppingbtn.tag=110;
    [joinSoppingbtn addTarget:self action:@selector(joinSoppingbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    joinSoppingbtn.layer.masksToBounds=YES;
    joinSoppingbtn.layer.cornerRadius=2;
    joinSoppingbtn.backgroundColor=AlltexthighlightedColor;
    joinSoppingbtn.titleLabel.font=GHFont(14);
    [endheadview addSubview:joinSoppingbtn];
    _joinSoppingbtn=joinSoppingbtn;
    [joinSoppingbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(leanlabe.mas_right).mas_offset(20*SCALEWITH6);
        make.centerY.mas_equalTo(endheadview.mas_centerY);
        make.width.mas_equalTo((SCREEN_WIDTH-136*SCALEWITH6)/2);
    }];
    
    
    UIButton *bayshop=[UIButton buttonWithType:UIButtonTypeCustom];
    bayshop.tag=100;
    [bayshop setTitle:@"立即购买" forState:UIControlStateNormal];
    [bayshop addTarget:self action:@selector(joinSoppingbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bayshop setTitleColor:AlltexthighlightedColor forState:UIControlStateNormal];
    bayshop.layer.masksToBounds=YES;
    bayshop.layer.cornerRadius=2;
    bayshop.titleLabel.font=GHFont(14);
    bayshop.backgroundColor=LDhax(@"#e5c7a6");
    [endheadview addSubview:bayshop];
    _bayshop=bayshop;
    [bayshop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(joinSoppingbtn.mas_right).mas_offset(20*SCALEWITH6);
        make.centerY.mas_equalTo(endheadview.mas_centerY);
        make.width.mas_equalTo(joinSoppingbtn.mas_width);
    }];
    
}
//569509392@qq.com


- (ShopHeadDetailView *)headview{
    if (_headview==nil) {
        _headview=[[ShopHeadDetailView alloc]initWithFrame:CGRectMake(0, -headViewHeight, SCREEN_WIDTH, headViewHeight) countbool:NO];
    }
    return _headview;
}


#pragma scrollDelegate
-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView
{
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.parentScrollView = scrollView;
    //离开顶部 主View 可以滑动
    self.canScroll = NO;
}

-(void)scrollViewChangeTab:(UIScrollView *)scrollView
{
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.parentScrollView = scrollView;
    /*
     * 如果已经离开顶端 切换tab parentScrollView的contentOffset 应该初始化位置
     * 这一规则 仿简书
     */
    if (self.canScroll) {
        self.parentScrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark  - 【scrollDelegate-商品详情的-】-----------

-(void)scrollviewhuadong{
    [self.tableview setContentOffset:CGPointMake(0, -headViewHeight) animated:YES];
    _imgController.tableview.scrollEnabled=NO;
    _tableview.scrollEnabled=YES;
    _hotController.tableview.scrollEnabled=NO;
    _commController.tableview.scrollEnabled=NO;
}

#pragma mark  ---- 【处理滑动时候不可以 滑动的属性】
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /*
     *  处理联动事件
     */
    //获取滚动视图y值的偏移量
    CGFloat tabOffsetY = 0;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY==-(SafeAreaTopHeight-1)) {
        _imgController.tableview.scrollEnabled=YES;
        _commController.tableview.scrollEnabled=YES;
        _hotController.tableview.scrollEnabled=YES;
        _tableview.scrollEnabled=NO;
        
    }else{
        _imgController.tableview.scrollEnabled=NO;
        _commController.tableview.scrollEnabled=NO;
        _hotController.tableview.scrollEnabled=NO;
        _tableview.scrollEnabled=YES;
    }
    if(offsetY<-64){
        if(offsetY<=-400){
            _navheadview.backgroundColor=[UIColor clearColor];
            return;
        }
        _navheadview.backgroundColor=LDrgba(16, 16, 16, 90/(-offsetY));
        _navheadview.alpha=1;
    }else{
        _navheadview.backgroundColor=LDrgba(16, 16, 16,1);
    }
    if (offsetY >=headViewHeight) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        offsetY = tabOffsetY;
    }
    self.isTopIsCanNotMoveParentScrollView = self.isTopIsCanNotMoveMainTableView;
    if (offsetY>=tabOffsetY) {
        
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.isTopIsCanNotMoveMainTableView = YES;
    }else{
        //        self.isTopIsCanNotMoveMainTableView = NO;
    }
    
    if (self.isTopIsCanNotMoveMainTableView != self.isTopIsCanNotMoveParentScrollView) {
        if (!self.isTopIsCanNotMoveParentScrollView && self.isTopIsCanNotMoveMainTableView) {
            //滑动到顶端
            self.canScroll = NO;
        }
        if(self.isTopIsCanNotMoveParentScrollView && !self.isTopIsCanNotMoveMainTableView){
            //离开顶端
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }else{
                self.parentScrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }else
    {
        if (!self.canScroll){
            
            //支持下刷新,下拉时maintableView 没有滚动到位置 parentScrollView 不进行刷新
            CGFloat parentScrollViewOffsetY = self.parentScrollView.contentOffset.y;
            if(parentScrollViewOffsetY >0)
                self.parentScrollView.contentOffset = CGPointMake(0, 0);
            
        }else
        {
            self.parentScrollView.contentOffset = CGPointMake(0, 0);
            
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  【弹出加入购物车----立即购买----】
-(void)joinSoppingbtnAction:(UIButton *)sender{
   UIView *popBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (sender.tag==110) {
        self.popShopView=[[JoinShoppingVIew alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) sender:sender.tag String:@"加入购物车" Backcolor:AllxianBinColor Textcolor:AlltexthighlightedColor prepaidbool:NO];
    }else{
        self.popShopView=[[JoinShoppingVIew alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) sender:sender.tag String:@"立即购买" Backcolor:AlltexthighlightedColor Textcolor:Kwhite prepaidbool:NO];
    }
    self.popShopView.delegate=self;
    [self.popShopView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmisshomeShareview)]];
    [Application addSubview:popBackView];
    self.popShopView.hidden=NO;
    popBackView.hidden=NO;
    popBackView.backgroundColor=LDrgba(000, 000, 000, 0.3);
    [popBackView addSubview:self.popShopView];
    [UIView animateWithDuration:0.25f animations:^{
        self.popShopView.frame = ContentViewPopFrame;
    }];
    
}

-(void)dissmisshomeShareview{
    if (self.popShopView) {
        UIView *popBackView = self.popShopView.superview;
        if(popBackView) {
            [UIView animateWithDuration:0.25f animations:^{
                popBackView.backgroundColor = PopViewInitBackColor;
                self.popShopView.frame = ContentViewInitFrame;
            } completion:^(BOOL finished) {
                self.popShopView.hidden=YES;
                popBackView.hidden=YES;
            }];
        }
    }
}
#pragma mark --确认-------[加入购物车：110] ---【立即购买 ：100】 -----
-(void)JoinOrBayAction:(NSInteger)sender count:(NSInteger)count{
    
    NSLog(@"%@===数量=%ld",sender==110?@"点击加入购物车":@"点击立即购买",count);
    
}
#pragma mark  - 去购物车----
-(void)puchgotoshop{
 
    NSLog(@"去购物车");
}
@end
