//
//  LBPhotoBrowserView.m
//  test
//
//  Created by dengweihao on 2017/8/2.
//  Copyright © 2017年 dengweihao. All rights reserved.
//

#import "LBPhotoBrowserConst.h"
#import "LBPhotoBrowserManager.h"
#import "LBPhotoBrowserView.h"
#import "LBZoomScrollView.h"
#import "UIImage+LBDecoder.h"

#if __has_include(<SDWebImage/SDWebImageManager.h>)
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCacheConfig.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#else
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "SDImageCacheConfig.h"
#import "UIImage+MultiFormat.h"
#endif

@interface LBScrollViewStatusModel : NSObject

@property (nonatomic , strong)NSNumber *scale;
@property (nonatomic , strong)NSNumber *contentOffsetX;
@property (nonatomic , strong)NSNumber *contentOffsetY;
@property (nonatomic , assign)BOOL isDisplaying;
@property (nonatomic , strong)UIImage *currentPageImage;

@end


@interface LBPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic , weak)LBZoomScrollView *zoomScrollView;

- (void)showWithURL:(NSURL *)url withStatusModel:(LBScrollViewStatusModel *)model andwithAnimation:(BOOL)animation;

@end

@interface LBPhotoBrowserView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , weak)UICollectionView *collectionView;

@property (nonatomic , strong)LBUrlsMutableArray *urls;

@property (nonatomic , strong)NSMutableArray *models;

@property (nonatomic , weak)UIPageControl *pageControl;


@end

@implementation LBScrollViewStatusModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scale = @1;
        self.contentOffsetX = @0;
        self.contentOffsetY = @0;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"model %p: scale: %@ contentOffsetX: %@ contentOffsetY: %@",self,self.scale,self.contentOffsetX,self.contentOffsetY];
}

@end

@implementation LBPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    LBZoomScrollView *zoomScrollView =[[LBZoomScrollView alloc]init];
    [self.contentView addSubview:zoomScrollView];
    _zoomScrollView = zoomScrollView;
}

- (void)showWithURL:(NSURL *)url withStatusModel:(LBScrollViewStatusModel *)model andwithAnimation:(BOOL)animation {
    [_zoomScrollView showWithURL:url andwithAnimation:animation andWithStatusModel:model];
}

@end

@implementation LBPhotoBrowserView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (NSMutableArray *)models {
    if (!_models) {
        _models = [[NSMutableArray alloc]init];
    }
    return _models;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.numberOfPages = self.urls.count;
        pageControl.currentPage = [LBPhotoBrowserManager defaultManager].selectedIndex;
        //[self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 20;
        // there page sapce is equal to 20
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH + 20, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
        [self addSubview:collectionView];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = [LBPhotoBrowserManager defaultManager].isNeedBounces;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor clearColor];

        [self collectionViewRegisterCellWithCollectionView:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (void)collectionViewRegisterCellWithCollectionView:(UICollectionView *)collentionView {
    NSString *ID = NSStringFromClass([LBPhotoCollectionViewCell class]);
    [collentionView registerClass:[LBPhotoCollectionViewCell class] forCellWithReuseIdentifier:ID];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remove) name:LBImageViewDidDismissNot object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionViewStopScrollEnable) name:LBImageViewBeiginDragNot object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionViewBeginScrollEnable) name:LBImageViewEndDragNot object:nil];
        [LBPhotoBrowserManager defaultManager].currentCollectionView = self.collectionView;
    }
    return self;
}

#pragma mark - 监听通知
// this have someting able to reduce memory 
- (void)remove{
    
    for (UIImageView *imageView in [LBPhotoBrowserManager defaultManager].imageViews) {
        imageView.hidden = NO;
    }
    [self removeFromSuperview];
    
}

- (void)collectionViewStopScrollEnable {
    self.collectionView.scrollEnabled = NO;
}
- (void)collectionViewBeginScrollEnable {
    self.collectionView.scrollEnabled = YES;
}


- (void)showImageViewsWithURLs:(LBUrlsMutableArray *)urls andSelectedIndex:(int)index{
    _urls = urls;
    if (_pageControl) {
        [_pageControl removeFromSuperview];
    }
    self.pageControl.bottom = SCREEN_HEIGHT - 50;
    self.pageControl.hidden = urls.count == 1? YES:NO;
    [self.models removeAllObjects];
    for (int i = 0 ; i < _urls.count; i++) {
        LBScrollViewStatusModel *model = [[LBScrollViewStatusModel alloc]init];
        model.isDisplaying = i == index ? YES:NO;
        [self.models addObject:model];
    }
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)showImageWithURLArray:(LBUrlsMutableArray *)urls fromCollectionView:(UICollectionView *)collectionView selectedIndex:(int)index {
    [self showImageViewsWithURLs:urls andSelectedIndex:index];
}

#pragma mark - collectionView的数据源&代理

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_urls) {
        return _urls.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ID = NSStringFromClass([LBPhotoCollectionViewCell class]);
    LBPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}
  // 新版的SDWebImage不知支持Gif 故采用了老版Gif的方式 但是这样加载太多Gif内存容易升高 在收到内存警告的时候 可以通过这个来清理内存 [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"]
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LBScrollViewStatusModel *model = self.models[indexPath.item];
    LBPhotoCollectionViewCell *currentCell = (LBPhotoCollectionViewCell *)cell;
    
    LBPhotoBrowserManager *mgr = [LBPhotoBrowserManager defaultManager];
    if (!model.currentPageImage) {
        UIImage *image = nil;
        NSString *address = self.urls[indexPath.row].absoluteString;
        if (isRemoteAddress(address) == NO) {
            
            NSData *data = [NSData dataWithContentsOfURL:self.urls[indexPath.row]];
            image = [UIImage sd_imageWithData:data]?:[UIImage imageNamed:@"LBLoadError.jpg"];
        }else {
            image =  [[SDImageCache sharedImageCache] imageFromCacheForKey:address];
        }
    
        if (image) {
            [self showLocalImage:image toCell:currentCell withModel:model atIndexPath:indexPath];
        }else {
            [self showRemoteImageCell:currentCell withModel:model atIndexPath:indexPath];
        }
        
    }
    // Just show imageView animation once. After showed, change the index
    [currentCell showWithURL:self.urls[indexPath.row] withStatusModel:model andwithAnimation:indexPath.item == mgr.selectedIndex];
    if (mgr.selectedIndex == indexPath.item) {
        mgr.selectedIndex = -1;
    }
    // Keep zooming and content off for scrollView on cell
    LBPhotoCollectionViewCell *photoCell = (LBPhotoCollectionViewCell *)cell;
    photoCell.zoomScrollView.zoomScale = model.scale.floatValue;
    photoCell.zoomScrollView.contentOffset = CGPointMake(model.contentOffsetX.floatValue, model.contentOffsetY.floatValue);
    
    //this have a thing when this method first show   UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath]  ---> cell = nil; but cell is existence
    if (!mgr.currentShowImageView) {
       mgr.currentShowImageView = [photoCell.zoomScrollView valueForKeyPath:@"imageView"];
    }
}
#pragma mark - 处理cell中图片的显示

/**
 about 3D touch, when image is loading, 3D touch should not usable
 */
- (void)showRemoteImageCell:(LBPhotoCollectionViewCell *)currentCell withModel:(LBScrollViewStatusModel *)model atIndexPath:(NSIndexPath *)indexPath{
    // 最新版的SDWebImage 不支持gif 默认取gif的第一帧
    weak_self;
    LBPhotoBrowserManager *mgr = [LBPhotoBrowserManager defaultManager];
    [[SDWebImageManager sharedManager] loadImageWithURL:self.urls[indexPath.row] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        LBPhotoBrowserLog(@"LBPhotoBrowseView line %d log: %d -- %d",__LINE__,(int)receivedSize ,(int)expectedSize);
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (error) {
            image = mgr.errorImage;
            LBPhotoBrowserLog(@"%@",error);
        }
        model.currentPageImage = image;
        if (image.images.count > 0) {
            if (mgr.lowGifMemory) {
                model.currentPageImage = image;
            }else {
                model.currentPageImage = [UIImage sdOverdue_animatedGIFWithData:data];
            }
        }
        [currentCell showWithURL:self.urls[indexPath.row] withStatusModel:model andwithAnimation:indexPath.item == mgr.selectedIndex];
        if (mgr.lowGifMemory && image.images.count >0 && indexPath.row == wself.pageControl.currentPage) {
            UIImage *currentImage = [mgr valueForKeyPath:@"currentGifImage"];
            if (!currentImage) {
                mgr.currentShowImageView = nil;
                [mgr setValue:data forKeyPath:@"spareData"];
                mgr.currentShowImageView = [currentCell.zoomScrollView valueForKeyPath:@"imageView"];
            }
        }
    }];
}

- (void)showLocalImage:(UIImage *)image toCell:(LBPhotoCollectionViewCell *)currentCell withModel:(LBScrollViewStatusModel *)model atIndexPath:(NSIndexPath *)indexPath {
    LBPhotoBrowserManager *mgr = [LBPhotoBrowserManager defaultManager];
    NSString *address = self.urls[indexPath.row].absoluteString;
    if (image.images.count > 0) {
        if (mgr.lowGifMemory == YES) {
            model.currentPageImage = image;
        }else{
            if (isRemoteAddress(address)) {
                [[SDImageCache sharedImageCache] queryCacheOperationForKey:self.urls[indexPath.row].absoluteString done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                    model.currentPageImage = [UIImage sdOverdue_animatedGIFWithData:data];
                    if ([SDImageCache sharedImageCache].config.shouldCacheImagesInMemory == NO) {
                        [currentCell showWithURL:self.urls[indexPath.row] withStatusModel:model andwithAnimation:indexPath.item == mgr.selectedIndex];
                    }
                }];
            }else {
                model.currentPageImage = [UIImage sdOverdue_animatedGIFWithData:[NSData dataWithContentsOfURL:self.urls[indexPath.row]]];
            }
        }
    }else {
        model.currentPageImage = image;
    }
}

#pragma mark - 代理方法

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  [UIScreen mainScreen].bounds.size;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.collectionView.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    if (!LBPhotoBrowserManager.defaultManager.currentShowImageView) {
        return;
    }
    LBPhotoCollectionViewCell *cell = (LBPhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
    LBPhotoBrowserManager.defaultManager.currentShowImageView = [cell.zoomScrollView valueForKeyPath:@"imageView"];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    [self changeImageViewsHideStatus];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self changeImageViewsHideStatus];
}


#pragma mark - 修改cell子控件的状态 的状态
- (void)changeImageViewsHideStatus {
    UIView *lastView = [LBPhotoBrowserManager defaultManager].helper.lastShowView;
    lastView.hidden = NO;
    UIView *currentView = [LBPhotoBrowserManager defaultManager].helper.currentShowView;
    currentView.hidden = YES;
    [self changeModelOfCellInRow:[LBPhotoBrowserManager defaultManager].helper.phtotoBrowserCurrentShowIndex];
}

- (void)changeModelOfCellInRow:(int)row {
     
    LBPhotoBrowserShowHelper *helper = [LBPhotoBrowserManager defaultManager].helper;
    [helper adjustCollectionViewContentOffsetWithIndexPath:[NSIndexPath indexPathForRow:helper.currentShowIndex inSection:0]];
    for (LBScrollViewStatusModel *model in self.models) {
        model.isDisplaying = NO;
    }
    if (row >= 0 && row < self.models.count) {
        LBScrollViewStatusModel *model = self.models[row];
        model.isDisplaying = YES;
    }
}
@end

