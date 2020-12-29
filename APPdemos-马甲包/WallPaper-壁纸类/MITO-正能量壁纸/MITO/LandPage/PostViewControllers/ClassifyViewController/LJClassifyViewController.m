//
//  LJClassifyViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJClassifyViewController.h"
#import "AFNetworking.h"
#import "LJBeautifulCityCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import <Ono.h>
#import "LJObjectsViewController.h"
#import <MJRefresh.h>

@interface LJClassifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,FRGWaterfallCollectionViewDelegate>{
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
    
}

@property (nonatomic, strong) NSMutableArray *cellHeights;

@end

@implementation LJClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    [self setupUI];
    [self loadData];
    
}

- (void)setupBase{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分类";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithColor:[UIColor whiteColor] highColor:[UIColor redColor] target:self action:@selector(cancel) title:@"取消"];
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupUI {
    FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] initWithWidth:self.view.frame.size.width / 2 - 10];
    cvLayout.delegate = self;
    cvLayout.topInset = 2.5f;
    cvLayout.bottomInset = 2.5f;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:cvLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:245.0/255.0 blue:250.0/255.0 alpha:1];
    [_collectionView registerNib:[UINib nibWithNibName:@"LJBeautifulCityCell" bundle:nil] forCellWithReuseIdentifier:@"CITYCELL"];
    [self.view addSubview:_collectionView];
    
   
}

#pragma mark 数据相关
- (void)loadData {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://360web.shoujiduoduo.com/wallpaper/wplist.php?user=868637010417434&prod=WallpaperDuoduo2.3.6.0&isrc=WallpaperDuoduo2.3.6.0_360ch.apk&type=getcate&mac=802275a25111&dev=K-Touch%253ET6%253EK-Touch%2BT6&vc=2360" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseObject error:nil];
        NSArray *array = [document.rootElement childrenWithTag:@"category"];
        
        for (ONOXMLElement *elemet in array) {
            NSDictionary *dict = elemet.attributes;
            LJBeautifulCityModel *model = [[LJBeautifulCityModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArray addObject:model];
        }
        [_collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
       
    }];
}

#pragma mark UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJBeautifulCityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CITYCELL" forIndexPath:indexPath];
    if (_dataArray.count > 1) {
        cell.model = _dataArray[indexPath.row];
    }
    return cell;
    
}

#pragma mark UICollectionViewDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeights[indexPath.section + 1 * indexPath.item] floatValue];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LJBeautifulCityModel *model = _dataArray[indexPath.row];
    LJObjectsViewController *objVC = [[LJObjectsViewController alloc] init];
    objVC.isFromClassify = YES;
    objVC.isFromSearch = NO;
    objVC.titleN = model.name;
    objVC.viewControllerType = [model.ID integerValue];
    objVC.urlStr = @"http://360web.shoujiduoduo.com/wallpaper/wplist.php?user=868637010417434&prod=WallpaperDuoduo2.3.6.0&isrc=WallpaperDuoduo2.3.6.0_360ch.apk&type=getlist&listid=%ld&st=hot&pg=%ld&pc=20&mac=802275a25111&dev=K-Touch%%253ET6%%253EK-Touch%%2BT6&vc=2360";
    [self.navigationController pushViewController:objVC animated:YES];
}

- (NSMutableArray *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray arrayWithCapacity:900];
        for (NSInteger i = 0; i < 900; i++) {
            _cellHeights[i] = @(arc4random()%80*2 + 100) ;
        }
    }
    return _cellHeights;
}



@end
