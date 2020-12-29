//
//  YCTypeViewController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/4/29.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCTypeViewController.h"
#import "YCNewViewController.h"
#import "YCSearchViewController.h"
#import "YCTypeCollectionViewCell.h"

@interface YCTypeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end
@implementation YCTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTitleView];
    [self setUpLayOut];
    [self setUpCollectionView];
    [self registerCell];
    [self requestData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.bFirstLoad && kArrayIsEmpty(self.dataSource)) {
        [self requestData];
    }
    self.bFirstLoad = YES;
}
#pragma mark - setUpTitleView
- (void)setUpTitleView
{
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH-30, 30)];
    titleView.text = @"         输入关键字";
    titleView.font = YC_Base_TitleFont;
    titleView.layer.cornerRadius = 5;
    titleView.layer.masksToBounds = YES;
    titleView.textColor = YC_Base_ContentColor;
    titleView.backgroundColor = YC_Base_BgGrayColor;
    UIImageView *searchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yc_nav_search"]];
    searchView.center = CGPointMake(17, 15);
    [titleView addSubview:searchView];
    self.navigationItem.titleView = titleView;
    
    titleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [titleView addGestureRecognizer:tap];
}
#pragma mark - tapAction
- (void)tapAction
{
    YCSearchViewController *searchVC = [[YCSearchViewController alloc] init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - setUpView
- (void)setUpLayOut
{
    self.layOut = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = (KSCREEN_WIDTH-10*4)/3;
    self.layOut.itemSize = CGSizeMake(itemWidth, 54.f/35*itemWidth);
    self.layOut.minimumLineSpacing = 10;
    self.layOut.minimumInteritemSpacing = 10;
    self.layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)setUpCollectionView
{
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64-49) collectionViewLayout:self.layOut];
    self.myCollectionView.backgroundColor = YC_Base_BgGrayColor;
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    [self.view addSubview:self.myCollectionView];
}
- (void)registerCell
{
    [self.myCollectionView registerClass:[YCTypeCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}
#pragma mark - request data
- (void)requestData
{
    [YCHudManager showLoadingInView:self.view];
    [YCNetManager getCategoryPicsWithCallBack:^(NSError *error, NSArray *pics) {
        [YCHudManager hideLoadingInView:self.view];
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
        } else {
            [self addNoResultView];
        }
    }];
}
#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCTypeCollectionViewCell *baseCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [baseCell setModel:self.dataSource[indexPath.item]];
    return baseCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YCBaseModel *model = self.dataSource[indexPath.item];
    if (kStringIsEmpty(model.tId)) return;
    YCNewViewController *newVC = [[YCNewViewController alloc] init];
    newVC.tId = model.tId;
    newVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
