//
//  ViewController.m
//  YLPhotoBrowserDemo
//
//  Created by 杨磊 on 2018/3/22.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "ViewController.h"
#import "WaterfallPBCollectionViewCell.h"
#import "YLWaterFallLayout.h"
#import "UIImageView+WebCache.h"
#import "SDWebImagePrefetcher.h"
#import "YLPhotoBrowserViewController.h"
#define WaterfallPBCell @"WaterfallPBCollectionViewCell"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YLWaterFallLayoutDeleaget>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataAry;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayoutAndCollectionView];
    [self photos];
}

- (void)setupLayoutAndCollectionView
{
    //禁用SD解压缩 对于高分辨率图来说，解压缩操作会造成内存飙升，即使是几M的图片，解压缩过程中也是有可能消耗上G的内存！
    SDImageCache *canche = [SDImageCache sharedImageCache];
    canche.config.shouldDecompressImages = NO;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = NO;
    self.title = @"图片";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 创建布局
    self.collectionView.backgroundColor = [UIColor whiteColor];
    UINib *nib = [UINib nibWithNibName:@"WaterfallPBCollectionViewCell" bundle: [NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:WaterfallPBCell];
}
#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallPBCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:WaterfallPBCell forIndexPath:indexPath];
    cell.pic = [self.dataAry objectAtIndex:indexPath.item];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YLPhotoBrowserViewController *vc = [YLPhotoBrowserViewController new];
    vc.index = indexPath.item;
    [vc.dataAry removeAllObjects];
    [vc.dataAry addObjectsFromArray:[self.dataAry copy]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  - <LMHWaterFallLayoutDeleaget>
- (CGFloat)waterFallLayout:(YLWaterFallLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth{
    
    NSString *thumb = [self.dataAry objectAtIndex:indexPath];
    NSString *imgeUrl = [NSString stringWithFormat:@"%@",thumb];
    imgeUrl = [imgeUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgeUrl];
    UIImageView *textimage = [[UIImageView alloc] initWithImage:cachedImage];
    CGFloat pich = 106.f * itemWidth / 168.f;
    if (textimage.frame.size.width > 0)
    {//如果图片下载好 就可以按照图片真实比例瀑布流了
        CGFloat w = textimage.frame.size.width;
        CGFloat h = textimage.frame.size.height;
        pich = itemWidth * h / w;
    }
    pich = MIN(pich, 300);//最大300
    pich = MAX(pich, 106.f * itemWidth / 168.f);
    return pich;
}

- (CGFloat)rowMarginInWaterFallLayout:(YLWaterFallLayout *)waterFallLayout{
    
    return 10;
    
}

- (NSUInteger)columnCountInWaterFallLayout:(YLWaterFallLayout *)waterFallLayout{
    
    return 2;
    
}

#pragma mark - 数据
- (void)photos
{
    self.dataAry = [NSMutableArray array];
    NSArray *picArr = [URL componentsSeparatedByString:@","];
    for (NSString *url in picArr) {
        NSString *strUrl = [url stringByReplacingOccurrencesOfString:@"," withString:@""];
        strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.dataAry addObject:strUrl];
    }
    [self.collectionView reloadData];
}

- (void)dealloc
{
    SDImageCache *canche = [SDImageCache sharedImageCache];
    canche.config.shouldDecompressImages = YES;
    
    SDWebImageDownloader *downloder = [SDWebImageDownloader sharedDownloader];
    downloder.shouldDecompressImages = YES;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        YLWaterFallLayout * waterFallLayout = [[YLWaterFallLayout alloc]init];
        waterFallLayout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:waterFallLayout];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
