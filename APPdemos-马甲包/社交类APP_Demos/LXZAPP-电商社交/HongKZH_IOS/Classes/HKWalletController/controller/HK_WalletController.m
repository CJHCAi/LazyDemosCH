//
//  HK_WalletController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_WalletController.h"
#import "HK_wallectHeaderView.h"
#import "Hk_walletCell.h"
#import "HK_WalletTool.h"
@interface HK_WalletController ()<UITableViewDelegate,UITableViewDataSource,PushIncomeViewDelegete>
@property (nonatomic, strong)HK_wallectHeaderView *headerView;
@property (nonatomic, strong)UITableView * listTableView;
@property (nonatomic, strong)NSMutableArray * dataSources;

@end

@implementation HK_WalletController

-(NSMutableArray *)dataSources {
    if (!_dataSources) {
        NSArray *arr= @[@"积分贷",@"话费充值",@"晒收入"];
        _dataSources =[[NSMutableArray alloc] initWithArray:arr];
    }
    return _dataSources;
}
-(HK_wallectHeaderView *)headerView {
    @weakify(self)
    if (!_headerView) {
        _headerView =[[HK_wallectHeaderView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH_S,330)];
        _headerView.block = ^(NSInteger index) {
            @strongify(self)
            if (index==1) {
            //充值
                [HK_WalletTool pushChargeController:self];
                
            }else {
            }
        };
    }
    _headerView.delegete =self;
    
    return _headerView;
    
}
#pragma mark 我的总资产
-(void)enterMyIncomeVc {
    
    [HK_WalletTool pushMyIncomeController:self];

}

-(UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headerView.frame)+10,kScreenWidth,kScreenHeight-NAVIGATION_HEIGHT_S-CGRectGetHeight(self.headerView.frame)-10) style:UITableViewStylePlain];
        _listTableView.delegate  =self;
        _listTableView.dataSource = self;
        _listTableView.tableFooterView =[[UIView alloc] init];
        _listTableView.scrollEnabled = NO;
        _listTableView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
        [_listTableView registerClass:[Hk_walletCell class] forCellReuseIdentifier:@"wallet"];
    
    }
    return _listTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Hk_walletCell * cell =[tableView dequeueReusableCellWithIdentifier:@"wallet" forIndexPath:indexPath];
    cell.nameLabel.text =self.dataSources[indexPath.row];
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            break;
        case  1:
            break;
         case  2:
            break;
        default:
            break;
    }
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
-(void)initNav {
    self.navigationItem.title = @"我的钱包";
    [self setShowCustomerLeftItem:YES];
    UIButton * rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [AppUtils getButton:rightBtn font:PingFangSCRegular15 titleColor:[UIColor colorFromHexString:@"4090f7"] title:@"明细"];
    rightBtn.frame = CGRectMake(0,0,30,20);
    [rightBtn addTarget:self action:@selector(checkList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * items =[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = items;
    
}
//查看明细
-(void)checkList {
    
    [HK_WalletTool pushWalletListController:self];
   
}
#pragma mark 获取用户钱包信息
-(void)getUserWallet {
    [HK_WalletTool getUserWalletInfoWithSuccessBlock:^(id responseObject) {
        NSInteger code =[responseObject[@"code"] integerValue];
        if (code) {
            NSString *msg =responseObject[@"msg"];
            if (msg.length) {
                [EasyShowTextView showText:msg];
            }
        }else {
            NSDictionary * data =responseObject[@"data"];
            if ([data isKindOfClass:[NSNull class]]) {
                return ;
            }
            id todayCount =data[@"dayIntegral"];
            id count =data[@"integral"];
            if ([count isKindOfClass:[NSNull class]]) {
                
            }else {
                CGFloat totalCount = [data[@"integral"] integerValue];
                self.headerView.totalCountLabel.attributedText =[self configuLabelImageWith:totalCount];
            }
            if ([todayCount isKindOfClass:[NSNull class]]) {
                
            }else {
                CGFloat todayCount = [data[@"dayIntegral"] integerValue];
                self.headerView.todayCountLabel.attributedText =[self configuLabelImageWith:todayCount];
            }
        }
    }];
}
-(NSMutableAttributedString *)configuLabelImageWith:(NSInteger)count {
    NSString *countStr =[NSString stringWithFormat:@"%zd",count];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"coin5"];
    attch.bounds = CGRectMake(0,-1,20,20);
    //创建带有图片的富文本
    NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attch];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",countStr]];
        [attri insertAttributedString:string atIndex:0];
        return  attri;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];    
    [self.view addSubview:self.headerView];
    
  //  [self.view addSubview:self.listTableView];
    [self getUserWallet];
}
@end
