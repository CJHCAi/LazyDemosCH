//
//  ZQAlbumVC.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/29.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQAlbumVC.h"
#import "ZQAlbumModel.h"
#import "ZQAlbumCell.h"
#import "ZQPhotoFetcher.h"
#import "ZQPhotoModel.h"
#import "ZQBottomToolbarView.h"
#import "ZQPhotoPreviewVC.h"
#import "ZQVideoPlayVC.h"
#import "Typedefs.h"
#import "ZQTools.h"
#import "ZQPublic.h"
#import "NSString+Size.h"
#import "ZQAlbumNavVC.h"

static CGFloat kButtomBarHeight = 48;

@interface ZQAlbumVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZQAlbumCellDelegate, ZQPhotoPreviewVCDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZQBottomToolbarView *tbButtom;

@property (nonatomic, strong) NSMutableArray<ZQPhotoModel *> *selected;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectedIdx;//selection changed cell
@property (nonatomic, strong) NSArray<PHAsset *> *assets;
@property (nonatomic, strong) NSArray<ZQPhotoModel *> *models;

//for scrollView
@property (nonatomic, assign) CGPoint lastOffset;
@property (nonatomic, assign) NSTimeInterval lastOffsetCapture;
@property (nonatomic, assign) BOOL isScrollingFast;

@property (nonatomic, strong) NSCache *cacheThumb;
@property (nonatomic, strong) NSCache *cache;

@end
@implementation ZQAlbumVC


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadData];
    
    [self scrollToBottom];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self p_loadVisibleCellImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.cache removeAllObjects];
    [self.cacheThumb removeAllObjects];
}
- (void)scrollToBottom {
    if (self.models.count >= 1) {
        NSIndexPath *idxPath = [NSIndexPath indexPathForItem:self.models.count-1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:idxPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    
    CGFloat contentHeight = ((CGRectGetWidth(self.view.frame)-3)/4+2)*(self.models.count+3)/4;
    CGFloat frameHeightWithoutInset = self.collectionView.frame.size.height - (self.collectionView.contentInset.top+self.collectionView.contentInset.bottom);
    if (contentHeight > frameHeightWithoutInset) {
        [self.collectionView setContentOffset:CGPointMake(0, contentHeight-self.collectionView.frame.size.height) animated:NO];
    }
}

- (void)initUI {
    self.navigationItem.title = self.mAlbum.name;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setImage:[ZQTools image:_image(@"navi_back") withTintColor:ZQChoosePhotoNavBtnColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    NSString* title = _LocalizedString(@"OPERATION_CANCEL");
    CGSize s = [title textSizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(999, 999) lineBreakMode:NSLineBreakByWordWrapping];
    UIButton* btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, s.width+10, 48)];
    [btnRight setTitleColor:ZQChoosePhotoNavBtnColor forState:UIControlStateNormal];
    [btnRight setTitle:title forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kLineSpacing;
    layout.minimumInteritemSpacing = kLineSpacing;
    layout.itemSize = CGSizeMake(kAlbumCellWidth, kAlbumCellWidth);
    
    CGFloat topMargin = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect rect = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+topMargin, self.view.frame.size.width, kTPScreenHeight - kButtomBarHeight-topMargin);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsZero;
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZQAlbumCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ZQAlbumCell class])];
    [self.view addSubview:self.collectionView];
    
    CGFloat y = kTPScreenHeight - kButtomBarHeight;
    self.tbButtom = [[ZQBottomToolbarView alloc] initWithFrame:CGRectMake(0, y, kTPScreenWidth, kButtomBarHeight)];
    [self.view addSubview:self.tbButtom];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadData {
    ______WS();
    [ZQPhotoFetcher getAllPhotosInAlbum:self.mAlbum completion:^(NSArray<ZQPhotoModel *> * _Nonnull photos) {
        wSelf.models = [photos copy];
    }];
}


#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZQAlbumCell";
    ZQAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZQAlbumCell alloc] init];
    }
    cell.type = self.type;
    cell.model = self.models[indexPath.row];
    cell.delegate = self;
    cell.tag = indexPath.row;
    if ([self.mAlbum.name isEqualToString:_LocalizedString(@"Videos")]) {
        cell.bSingleSelection = YES;
    }
    else {
        cell.bSingleSelection = self.bSingleSelection;
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ZQAlbumCell *ce = (ZQAlbumCell *)cell;
    ce.cancelLoad = NO;
    [ce displayThumb:indexPath cache:self.cacheThumb];
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ZQAlbumCell *ce = (ZQAlbumCell *)cell;
    ce.cancelLoad = YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == ZQAlbumTypeVideo) {
        ZQVideoPlayVC *vc = [[ZQVideoPlayVC alloc] init];
        vc.model = self.models[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        ZQPhotoPreviewVC *vc = [[ZQPhotoPreviewVC alloc] init];
        vc.currentIdx = indexPath.row;
        vc.models = self.models;
        vc.selected = self.selected;
        vc.delegate = self;
        vc.maxImagesCount = self.maxImagesCount;
        vc.bSingleSelect = self.bSingleSelection;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint currentOffset = scrollView.contentOffset;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval timeDiff = currentTime - self.lastOffsetCapture;
    if (timeDiff > 0.1) {
        CGFloat distance = currentOffset.y - self.lastOffset.y;
        CGFloat scrollSpeed = fabs((distance*10)/1000);
        
        if (scrollSpeed > 0.4) {
            self.isScrollingFast = YES;
        }
        else {
            self.isScrollingFast = NO;
            [self p_loadVisibleCellImage];
        }
        self.lastOffset = currentOffset;
        self.lastOffsetCapture = currentTime;
    }
}
////快速滚才会调这个
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self p_loadVisibleCellImage];
//}
//慢慢地滚调这个
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self p_loadVisibleCellImage];
}

#pragma mark - Private method

- (void)p_loadVisibleCellImage {
    NSArray *visibleCells = [self.collectionView visibleCells];
    for (ZQAlbumCell *cell in visibleCells) {
//        [cell display:[self.collectionView indexPathForCell:cell]];
        [cell display:[self.collectionView indexPathForCell:cell] cache:self.cache];
    }
}

#pragma mark - ZQPhotoPreviewVC Delegate - 多选

- (void)ZQPhotoPreviewVC:(ZQPhotoPreviewVC *)vc changeSelection:(NSArray<ZQPhotoModel *> *)selection {
    [self.collectionView reloadData];
    self.selected = [selection mutableCopy];
    [self.tbButtom selectionChange:self.selected];
    
}
#pragma mark - CTAlbumCellDelegate - 多选

- (BOOL)ZQAlbumCell:(ZQAlbumCell *)cell changeSelection:(ZQPhotoModel *)model {
    if (self.selected.count >= self.maxImagesCount && model.bSelected == NO) {
        [ZQPhotoFetcher exceedMaxImagesCountAlert:self.maxImagesCount presentingVC:self navVC:((ZQAlbumNavVC*)self.navigationController)];
        return NO;
    }
    else {
        NSIndexPath *idx = [self.collectionView indexPathForCell:cell];
        ZQPhotoModel *m = self.models[idx.row];
        m.bSelected = model.bSelected;
        [self.selectedIdx addObject:idx];
        if (cell.bSelected) {
            [self.selected removeObject:model];
        }
        else {
            [self.selected addObject:model];
        }
        [self.tbButtom selectionChange:self.selected];
        
        return YES;
    }
}



- (NSMutableArray<ZQPhotoModel *> *)selected {
    if (!_selected) {
        _selected = [[NSMutableArray alloc] init];
    }
    return _selected;
}
- (NSMutableArray<NSIndexPath *> *)selectedIdx {
    if (!_selectedIdx) {
        _selectedIdx = [[NSMutableArray alloc] init];
    }
    return _selectedIdx;
}


- (NSCache *)cache {
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.totalCostLimit = cacheLimit;
    }
    return _cache;
}
- (NSCache *)cacheThumb {
    if (!_cacheThumb) {
        _cacheThumb = [[NSCache alloc] init];
        _cacheThumb.totalCostLimit = cacheThumbLimit;
    }
    return _cacheThumb;
}

@end
