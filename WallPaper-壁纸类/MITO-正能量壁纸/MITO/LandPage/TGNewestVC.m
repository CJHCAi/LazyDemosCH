//
//  TGNewestVC.m
//  baisibudejie
//
//  Created by targetcloud on 2017/5/31.
//  Copyright © 2017年 targetcloud. All rights reserved.
//  Blog http://blog.csdn.net/callzjy
//  Mail targetcloud@163.com
//  Github https://github.com/targetcloud

#import "TGNewestVC.h"
#import "ListImageViewCell.h"
#import "LBPhotoBrowserManager.h"
#import "LJSeeViewController.h"
#import "ListModel.h"
#import "PeoperModel.h"
@interface TGNewestVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic , strong)NSMutableArray *dataArr;
@property(nonatomic , strong)UICollectionView *collectionView;
@property(nonatomic ,copy)NSString * np;

@end

@implementation TGNewestVC

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _np = @"0";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavBar];
    [self initCollectView];
    [self loadData:_np];
}

- (void)loadData:(NSString*)page{
    
    NSString * url = [NSString stringWithFormat:@"http://s.budejie.com/topic/list/zuixin/31/bs0315-iphone-4.5.6/%@-40.json",page];
    
    [KTHttpTool post:url  params:nil success:^(id responseObj) {
     
         _np = responseObj[@"info"][@"np"];
        if (responseObj[@"list"]) {
            
            NSArray * arr = responseObj[@"list"];
            
            for (int i=0; i<arr.count; i++) {
                ListModel * model = [ListModel yy_modelWithDictionary:arr[i]];
                List_audioModel * mode = [List_audioModel yy_modelWithDictionary:model.audio];
                [self.dataArr addObject:mode];
                
            }
            
        }
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)initCollectView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-108) collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [self.collectionView registerClass:[ListImageViewCell class] forCellWithReuseIdentifier:@"imageCellIdentify"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    DefineWeakSelf;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf handleRefresh:@"0"];
        
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        [weakSelf handleRefresh:_np];
    }];
    
    
}

- (void)handleRefresh:(NSString*)page
{
    [self loadData:page];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer  endRefreshing];
}

#pragma mark -- UICollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

// 每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(kWidth/3 - 2, kHeight/3 - 2);
}

// 垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

// 水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

// cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ListImageViewCell *cell = (ListImageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellIdentify" forIndexPath:indexPath];
    
    List_audioModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionView Delegate
// 点击cell响应
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *dataImgUrlMArr = [NSMutableArray array];
    for (List_audioModel * model in self.dataArr) {
        [dataImgUrlMArr addObject:model.thumbnail.firstObject];
    }
    DefineWeakSelf;
    [[LBPhotoBrowserManager defaultManager] showImageWithURLArray:dataImgUrlMArr fromCollectionView:collectionView selectedIndex:(int)indexPath.row unwantedUrls:nil];
    [[[LBPhotoBrowserManager defaultManager] addLongPressShowTitles:@[@"保存图片至相册",@"预览",@"取消"]] addTitleClickCallbackBlock:^(UIImage *image, NSIndexPath *indexPath, NSString *title) {
        
        switch (indexPath.row) {
            case 0:
            {     [weakSelf collectPictrue:image];     }
                break;
            case 1:
            {    LJSeeViewController *seeVC = [[LJSeeViewController alloc] init];
                seeVC.image = image;
                [self presentViewController:seeVC animated:YES completion:nil];    }
                break;
                
            default:
                break;
        }
        
    }].lowGifMemory = NO;
}

- (void)collectPictrue:(UIImage *)imageView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已保存到相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImageWriteToSavedPhotosAlbum(imageView, nil, nil, nil);
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        self.dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)setupNavBar{
    //self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"review_post_nav_icon" highImageName:@"review_post_nav_icon_click" target:self action:@selector(check)];
   // self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_search_icon" highImageName:@"nav_search_icon_click" target:self action:@selector(search)];
    //self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"壁纸"]];
    self.navigationItem.title = @"发现";
}

- (void)check{
    TGFunc
}

- (void)search{
    TGFunc
}

@end
