//
//  FamilServiceViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "FamilServiceViewController.h"

#import "TopSearchView.h"
#import "CollectionFamilyView.h"
#import "FamilyShopView.h"
#import "SearchFamilyTreeViewController.h"
#import "WorshipViewController.h"
#import "TeachViewController.h"
#import "GeomancyIdentificationViewController.h"
#import "AppendServiceViewController.h"
#import "ExpertRecommendViewController.h"
#import "BannerView.h"
#import <MJRefresh.h>
#import "NewInfoViewController.h"

#define ScrollerView_Height 210
@interface FamilServiceViewController ()<CollectionFamilyDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) TopSearchView *topSearchView; /*顶部搜索*/
/** banner*/
@property (nonatomic, strong) BannerView *bannerView;

@property (nonatomic,strong) CollectionFamilyView *collecFamView; /*八种家谱集合视图*/

//@property (nonatomic,strong) FamilyShopView *famShop; /*商城*/

@property (nonatomic,strong) UITableView *tableView; /*表格*/

@property (nonatomic,strong) UIScrollView *backScrollerView; /*背景图*/

/** 页数*/
@property (nonatomic,assign) NSInteger jzdtPage;
/** 家族动态数组*/
@property (nonatomic, strong) NSMutableArray *jzdtArr ;
@end

@implementation FamilServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.view.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.backScrollerView];
    
    [self.view addSubview:self.topSearchView];
    [self.view addSubview:self.bannerView];
    [self getBanner];
    [self.backScrollerView addSubview:self.collecFamView];
    //[self.backScrollerView addSubview:self.famShop];
    [self.backScrollerView addSubview:self.tableView];
    self.jzdtPage = 1;
    [self getJzdtData];
}

#pragma mark - 获取数据
-(void)getBanner{
    NSDictionary *logDic = @{@"type":@"JPFW"};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:@"getbanner" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic);
        if (succe) {
            NSArray *array = [NSArray modelArrayWithClass:[BannerModel class] json:jsonDic[@"data"]];
            weakSelf.bannerView.modelArr = array;
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)getJzdtData{
    NSDictionary *logDic = @{@"pagenum":@(self.jzdtPage),@"pagesize":@5,@"type":@"JZDT",@"geid":[WFamilyModel shareWFamilModel].myFamilyId,@"istop":@""};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeGetNewsList success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic[@"data"]);
        if (succe) {
            NSDictionary *dic = [NSDictionary DicWithString:jsonDic[@"data"]];
            NSArray *JZDTArr = [NSArray modelArrayWithClass:[FamilyDTModel class] json:dic[@"datalist"]];
            if (JZDTArr.count != 0) {
                [weakSelf.jzdtArr addObjectsFromArray:JZDTArr];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            //MYLog(@"%@",JZDTArr);
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *** 协议方法 ***
//-(void)TopSearchViewDidTapView:(TopSearchView *)topSearchView{
//    MYLog(@"点击搜索栏");
//    SearchFamilyTreeViewController *searchFamilyTreeVC = [[SearchFamilyTreeViewController alloc]init];
//    [self.navigationController pushViewController:searchFamilyTreeVC animated:YES];
//}
-(void)TopSearchView:(TopSearchView *)topSearchView didRespondsToMenusBtn:(UIButton *)sender{
    MYLog(@"点击右上角菜单");
}

#pragma mark - UITableViewDataSource,UITabBarDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jzdtArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newscellIdentifier"];
    if (!cell) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newscellIdentifier"];
    }
    cell.familyDTModel = self.jzdtArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewInfoViewController *newInfoVC = [[NewInfoViewController alloc]initWithTitle:@"新闻详情" image:nil];
    newInfoVC.arId = ((NewsCell *)[tableView cellForRowAtIndexPath:indexPath]).familyDTModel.ArId;
    [self.navigationController pushViewController:newInfoVC animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

//-(void)familyShopViewDidTapView:(FamilyShopView *)famShop{
//    MYLog(@"点击商城");
//    ShoppingFirestViewController *shopVC = [[ShoppingFirestViewController alloc]init];
//    [self.navigationController pushViewController:shopVC animated:YES];
//}

-(void)CollevtionFamily:(CollectionFamilyView *)collecView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath{
    MYLog(@"点击collection -- %ld",(long)indexPath.row);
    //宗亲互助，在线祭祀，增值服务，教你修谱，专家推荐，风水鉴定，赏金寻亲，募捐圆梦
    switch (indexPath.row) {
        case 0:
        {
            FamilyHelpViewController *helpVc = [[FamilyHelpViewController alloc] initWithTitle:@"宗亲互助" image:nil];
            helpVc.type = @"SJXQ";
            [self.navigationController pushViewController:helpVc animated:YES];
        }
            break;
        case 1:
        {
            WorshipViewController *worshipVC = [[WorshipViewController alloc]init];
            [self.navigationController pushViewController:worshipVC animated:YES];
        }
            break;
        case 2:
        {
            AppendServiceViewController *appendServiceVC = [[AppendServiceViewController alloc]initWithTitle:@"增值服务" image:nil];
            [self.navigationController pushViewController:appendServiceVC animated:YES];
        }
            break;
        case 3:
        {
            TeachViewController *teachVc = [[TeachViewController alloc] initWithTitle:@"教你修谱" image:nil];
            [self.navigationController pushViewController:teachVc animated:YES];
        }
            break;
        case 4:
        {
            ExpertRecommendViewController *expertVC = [[ExpertRecommendViewController alloc]initWithTitle:@"专家推荐" image:nil];
            [self.navigationController pushViewController:expertVC animated:YES];
        }
            break;
        case 5:
        {
            MYLog(@"风水鉴定");
            GeomancyIdentificationViewController *geoVC = [[GeomancyIdentificationViewController alloc]initWithTitle:@"风水鉴定" image:nil];
            [self.navigationController pushViewController:geoVC animated:YES];
            
        }
            break;
        case 6:
        {
            FamilyHelpViewController *helpVc = [[FamilyHelpViewController alloc] initWithTitle:@"宗亲互助" image:nil];
            helpVc.type = @"SJXQ";
            [self.navigationController pushViewController:helpVc animated:YES];
            
        }
            break;
        case 7:
        {
            FamilyHelpViewController *helpVc = [[FamilyHelpViewController alloc] initWithTitle:@"宗亲互助" image:nil];
            helpVc.type = @"MJYM";
            [self.navigationController pushViewController:helpVc animated:YES];

        }
            break;
        default:
            break;
    }
    
}

#pragma mark *** getters ***

-(UIScrollView *)backScrollerView{
    if (!_backScrollerView) {
        _backScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, CGRectGetMinY(self.tabBarController.tabBar.frame))];
        _backScrollerView.contentSize = CGSizeMake(Screen_width, CGRectGetMaxY(self.tableView.frame));
        _backScrollerView.bounces = NO;
        _backScrollerView.contentOffset = CGPointMake(0, 0);
        _backScrollerView.scrollEnabled = YES;
    }
    return _backScrollerView;
}

-(TopSearchView *)topSearchView{
    if (!_topSearchView) {
        _topSearchView = [[TopSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, StatusBar_Height+NavigationBar_Height)];
        [_topSearchView.searchView removeFromSuperview];
        
    }
    return _topSearchView;
}

-(BannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[BannerView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, 0.6*Screen_width)];
    }
    return _bannerView;
}

-(CollectionFamilyView *)collecFamView{
    if (!_collecFamView) {
        _collecFamView = [[CollectionFamilyView alloc] initWithFrame:CGRectMake(0, 15, Screen_width*0.85, 130)];
        _collecFamView.center = CGPointMake(self.view.center.x,CGRectGetMaxY(self.bannerView.frame)+20+_collecFamView.bounds.size.height/2);
        _collecFamView.delegate = self;
        
    }
    return _collecFamView;
}
//-(FamilyShopView *)famShop{
//    if (!_famShop) {
//        _famShop = [[FamilyShopView alloc] initWithFrame:CGRectMake(0.05*Screen_width, CGRectGetMaxY(self.collecFamView.frame)+0.06*Screen_width, Screen_width, 34)];
//        _famShop.delegate = self;
//    }
//    return _famShop;
//}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collecFamView.frame)+10, Screen_width , 0.25*Screen_height)];
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 10)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
        _tableView.tableHeaderView = headerView;
        _tableView.backgroundColor = LH_RGBCOLOR(235, 235, 235);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.jzdtPage++;
            [self getJzdtData];
        }];
    }
    return _tableView;
}

-(NSMutableArray *)jzdtArr{
    if (!_jzdtArr) {
        _jzdtArr = [@[] mutableCopy];
    }
    return _jzdtArr;
}
@end
