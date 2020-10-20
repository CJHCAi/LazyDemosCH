
//
//  FamilyHelpViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/31.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "FamilyHelpViewController.h"
#import "HelpTableTableViewCell.h"
#import "AdgnatioHelpInfoViewController.h"
#import "FamilyHelpModel.h"
#import <MJRefresh.h>
#import "MyHelpModel.h"

#define BtnWidth 50
#define GapToleft 15
static NSString *const kReusableCellIdentifier = @"cellIdentifier";
static NSString *const kReuserableUITableViewCell = @"UITableViewCell";

@interface FamilyHelpViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UILabel *myLabel; /*label*/
@property (nonatomic,strong) UITableView *tableView; /*table*/
/** 数据*/
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 当前页*/
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation FamilyHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentPage = 1;
    [self initUI];
    [self getDataWithType:self.type];
}


#pragma mark *** 初始化界面 ***
-(void)initUI{
    NSArray *topTitles = @[@"赏金寻亲",@"募捐圆梦",@"我提供",@"我需要"];
    NSArray *imageNames = @[@"sj_icon_2",@"sj_icon_3",@"sj_icon_4",@"sj_icon_5"];
    for (int idx = 0; idx<topTitles.count; idx++) {
        
        //按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx+111;
        [btn addTarget:self action:@selector(respondsToAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:MImage(imageNames[idx]) forState:0];

        [self.view addSubview:btn];
        
        btn.sd_layout.topSpaceToView(self.comNavi,10).leftSpaceToView(self.view,GapToleft+idx*(BtnWidth+(Screen_width-GapToleft*2-topTitles.count*BtnWidth)/(topTitles.count-1))).widthIs(BtnWidth).heightIs(BtnWidth);
        
        //文字
        UILabel *label = [UILabel new];
        label.font = MFont(12);
        label.textAlignment = 1;
        label.text = topTitles[idx];
        [self.view addSubview:label];
        self.myLabel = label;
        
        label.sd_layout.topSpaceToView(btn,5).widthIs(BtnWidth).leftEqualToView(btn).heightIs(15);
    
        
    }
    //滚动图
    NSMutableArray *arr = [@[@"sj_bg",@"sj_icon_1",@"sj_icon_2"] mutableCopy];
    
    ScrollerView *scroView = [[ScrollerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myLabel.frame), Screen_width, 0.3*Screen_height) images:arr];
    [self.view addSubview:scroView];
    
    scroView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.myLabel,10);
    
    //tableView
    [self.view addSubview:self.tableView];
    
    self.tableView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.myLabel,0.3*Screen_height+20).bottomSpaceToView(self.tabBarController.tabBar,0);
    
}

#pragma mark - 请求数据
-(void)getDataWithType:(NSString *)type{
    self.type = type;
    NSDictionary *logDic = @{@"pagenum":@(self.currentPage),
                             @"pagesize":@3,
                             @"type":type,
                             @"memberid":[NSString stringWithFormat:@"%@",GetUserId],
                             @"geid":@0,
                             @"gemeid":@0,
                             @"istop":@"0"};
    WK(weakSelf);
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"zqhzlist" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            FamilyHelpModel *model = [FamilyHelpModel modelWithJSON:jsonDic[@"data"]];
            if (model.datalist.count != 0) {
                [weakSelf.dataSource addObjectsFromArray:model.datalist];
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark *** Events ***
-(void)respondsToAllBtn:(UIButton *)sender{
    MYLog(@"%ld",(long)sender.tag-111);
    [self.dataSource removeAllObjects];
    self.currentPage = 1;
    switch (sender.tag-111) {
        case 0:
            [self getDataWithType:@"SJXQ"];
            break;
        case 1:
            [self getDataWithType:@"MJYM"];
            break;
        case 2:
            [self getDataWithType:@"WTG"];
            break;
        case 3:
            [self getDataWithType:@"WXY"];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

-(void)loadMore{
    self.currentPage++;
    [self getDataWithType:self.type];
}


#pragma mark *** tableDataSource ***
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReusableCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[HelpTableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReusableCellIdentifier];
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.2*Screen_width+10;
   
}

#pragma mark *** tableViewDelegate ***
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AdgnatioHelpInfoViewController *detailVc = [[AdgnatioHelpInfoViewController alloc] initWithTitle:@"宗亲互助" image:nil];
    HelpTableTableViewCell *cell = (HelpTableTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    MyHelpModel *model = [[MyHelpModel alloc]init];
    model.ZqId = cell.model.ZqId;
    model.ZqTitle = cell.model.ZqTitle;
    model.ZqCover = cell.model.ZqCover;
    model.ZqIntencnt = cell.model.ZqIntencnt;
    model.ZqFollowcnt = cell.model.ZqFollowcnt;
    model.Syts = cell.model.Syts;
    detailVc.myHelpModel = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark *** getters ***
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HelpTableTableViewCell class] forCellReuseIdentifier:kReusableCellIdentifier];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReuserableUITableViewCell];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [@[] mutableCopy];
    }
    return _dataSource;
}

@end
