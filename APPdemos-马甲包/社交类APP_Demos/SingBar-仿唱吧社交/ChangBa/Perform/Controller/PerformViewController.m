//
//  PerformViewController.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/17.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "PerformViewController.h"
#import "PerformCollectionViewCell.h"
#import "PerformHeaderCollectionReusableView.h"
#import "PerformanceBaseClass.h"
#import "PlayingViewController.h"
#import <SVPullToRefresh.h>
#import "HopeViewController.h"

@interface PerformViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *performCV;
@property (nonatomic, strong) NSArray *performances;
@property (nonatomic, strong) NSMutableArray *musicPaths;
@property (nonatomic, strong) NSMutableArray *artworkImages;
@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation PerformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏设置
    self.title = @"精彩表演";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"杭州榜" style:UIBarButtonItemStyleDone target:self action:nil];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setImage:[UIImage imageNamed:@"mini_paly_btn_normal"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"mini_play_btn_press"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(gotoPlayingViewAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    //创建collectionView
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    UICollectionView *performCV = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    performCV.delegate = self;
    performCV.dataSource = self;
    performCV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:performCV];
    self.performCV = performCV;
    //解决刷新tableview上移
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.performCV.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    //注册Cell
    //    [self.performCV registerClass:[PerformCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.performCV registerClass:[PerformCollectionViewCell class] forCellWithReuseIdentifier:@"PerformCollectionViewCell"];
    
    [self.performCV registerClass:[PerformHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    //请求数据
    [Utils requestPerformancesWithCallback:^(id obj) {
        PerformanceBaseClass *performance = obj;
        self.performances = performance.result;
        
        self.musicPaths = [NSMutableArray array];
        self.artworkImages = [NSMutableArray array];
        self.titles = [NSMutableArray array];
        for (PerformanceResult *result in self.performances) {
            [self.musicPaths addObject:result.workpath];
            [self.artworkImages addObject:result.song.icon];
            [self.titles addObject:result.song.name];
        }
        [self.performCV reloadData];
    }];
    __block PerformViewController *mySelf = self;
    //添加下拉刷新
    [self.performCV addPullToRefreshWithActionHandler:^{
        NSLog(@"开始刷新");
        [mySelf loadData];
    }];
}
#pragma mark - 方法 Methods
- (void)loadData{
    //请求数据
    [Utils requestPerformancesWithCallback:^(id obj) {
        PerformanceBaseClass *performance = obj;
        self.performances = performance.result;
        
        self.musicPaths = [NSMutableArray array];
        self.artworkImages = [NSMutableArray array];
        self.titles = [NSMutableArray array];
        for (PerformanceResult *result in self.performances) {
            [self.musicPaths addObject:result.workpath];
            [self.artworkImages addObject:result.song.icon];
            [self.titles addObject:result.song.name];
        }
        
        [self.performCV reloadData];
        //结束动画
        [self.performCV.pullToRefreshView stopAnimating];
    }];

    
}
//
- (void)gotoPlayingViewAction{
    PlayingViewController *playingVC = [PlayingViewController sharePlayingVC];
    [self.navigationController pushViewController:playingVC animated:YES];
}


#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //分区
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.performances.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PerformCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PerformCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor grayColor];
    PerformanceResult *performanceResult = self.performances[indexPath.row];
    NSURL *url = [NSURL URLWithString:performanceResult.song.icon];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cat"]];
    cell.imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    PerformanceResult *performanceResult = self.performances[indexPath.row];
    
    PlayingViewController *playingVC = [PlayingViewController sharePlayingVC];
    playingVC.musicPaths = self.musicPaths;
    playingVC.artworkImages = self.artworkImages;
    playingVC.titles = self.titles;
    playingVC.currentIndex = indexPath.row;
    [self.navigationController pushViewController:playingVC animated:YES];
}
//控制显示大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return CGSizeMake(kScreenW, 280);
    }
    if (indexPath.row < 9) {
        return CGSizeMake((kScreenW-1)/2, 150);
    }
    return CGSizeMake((kScreenW - 2) / 3, 120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    //宽随意 不起作用 永远都是collectionView的宽
    return CGSizeMake(0, 220);
}
//当分组的头 和分组的尾 需要显示的时候会执行此方法
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    PerformHeaderCollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [view addGestureRecognizer:tapGR];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return view;
}

- (void)tap:(UITapGestureRecognizer *)sender{
    HopeViewController *hopeVC = [[HopeViewController alloc]init];
    [self.navigationController pushViewController:hopeVC animated:YES];
}
@end
