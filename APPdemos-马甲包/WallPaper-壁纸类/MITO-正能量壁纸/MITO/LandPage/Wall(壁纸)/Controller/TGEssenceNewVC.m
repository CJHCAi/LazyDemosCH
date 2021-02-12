//
//  TGEssenceNewVC.m
//  baisibudejie
//
//  Created by targetcloud on 2017/5/29.
//  Copyright © 2017年 targetcloud. All rights reserved.
//  Blog http://blog.csdn.net/callzjy
//  Mail targetcloud@163.com
//  Github https://github.com/targetcloud

#import "TGEssenceNewVC.h"
#import "ImageViewCell.h"
#import "PeoperModel.h"
#import "TGPublishV.h"
#import "LJSeeViewController.h"
#import "LBPhotoBrowserManager.h"
@interface TGEssenceNewVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic , strong)NSMutableArray *dataArr;
@property(nonatomic , strong)UICollectionView *collectionView;

@end
const int PageSize = 10;
@implementation TGEssenceNewVC

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavBar];
    [self initCollectView];
    [self loadData];
}

- (void)loadData{
    
    NSString * url = [NSString stringWithFormat:@"http://service.picasso.adesk.com/v1/wallpaper/category"];
    
    [KTHttpTool post:url  params:nil success:^(id responseObj) {
        
        NSArray * categoryArray = responseObj[@"res"][@"category"];
        for (NSDictionary * dict in categoryArray) {
            PeoperModel * model = [PeoperModel yy_modelWithDictionary:dict];
            model.cover = [model.cover stringByReplacingOccurrencesOfString:@"640x480" withString:@"375x667"];
            [self.dataArr  addObject:model];
        }
        [self.collectionView  reloadData];
      
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)initCollectView{
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight-108) collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [self.collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:@"imageCellIdentify"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    DefineWeakSelf;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf handleRefresh];
       
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
         [weakSelf handleRefresh];
    }];
    
    
}

- (void)handleRefresh
{

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
    ImageViewCell *cell = (ImageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellIdentify" forIndexPath:indexPath];
    
    PeoperModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionView Delegate
// 点击cell响应
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *dataImgUrlMArr = [NSMutableArray array];
    for (PeoperModel * model in self.dataArr) {
        [dataImgUrlMArr addObject:model.cover];
    }
    DefineWeakSelf;
    [[LBPhotoBrowserManager defaultManager] showImageWithURLArray:dataImgUrlMArr fromCollectionView:collectionView selectedIndex:(int)indexPath.row unwantedUrls:nil];
    [[[LBPhotoBrowserManager defaultManager] addLongPressShowTitles:@[@"保存图片至相册",@"预览",@"取消"]] addTitleClickCallbackBlock:^(UIImage *image, NSIndexPath *indexPath, NSString *title) {
        
        switch (indexPath.row) {
            case 0:
            {
                [weakSelf collectPictrue:image];
            }
                break;
            case 1:
            {
                LJSeeViewController *seeVC = [[LJSeeViewController alloc] init];
                seeVC.image = image;
                [self presentViewController:seeVC animated:YES completion:nil];
            }
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
    
    //self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"nav_item_game_icon-1" highImageName:@"nav_item_game_click_icon-1" target:self action:@selector(test)];
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"RandomAcross" highImageName:@"RandomAcrossClick" target:self action:@selector(randomAcross)];
    self.navigationItem.title = @"壁纸";
    
}

- (void)test{
    TGFunc
}

-(void)randomAcross{
    TGFunc
    
}

@end
