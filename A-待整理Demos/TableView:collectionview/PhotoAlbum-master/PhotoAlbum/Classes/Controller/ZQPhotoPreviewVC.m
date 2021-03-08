//
//  ZQPhotoPreviewVC.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/1.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQPhotoPreviewVC.h"
#import "ZQPhotoFetcher.h"
#import "ZQBottomToolbarView.h"
#import "ZQPreviewCell.h"
#import "ZQPhotoModel.h"
#import <Photos/Photos.h>
#import "ZQCropViewOverlay.h"
#import "ZQAlbumNavVC.h"
#import "ZQTools.h"
#import "ZQPublic.h"
#import "ViewUtils.h"

#define kImageThumbSize 80


@interface ZQPhotoPreviewVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) ZQBottomToolbarView *bottomBar;
@property (nonatomic, strong) ZQCropViewOverlay *cropOverlay;

@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnSelectBotm;

@property (nonatomic, strong) NSCache *cache;

@end

@implementation ZQPhotoPreviewVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.cache removeAllObjects];
}

- (void)initUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[ZQTools createImageWithColor:kLightBottomBarBGColor] forBarMetrics:UIBarMetricsDefault];
    UIButton* btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [btnLeft setImage:[ZQTools image:_image(@"navi_back") withTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    if (!self.bSingleSelect) {
        CGSize size = _image(@"photo_def_photoPickerVC").size;
        self.btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [self.btnSelect setImage:_image(@"photo_def_photoPickerVC") forState:(UIControlStateNormal)];
        [self.btnSelect setImage:_image(@"photo_sel_photoPickerVc") forState:(UIControlStateSelected)];
        self.btnSelect.selected = NO;
        [self.btnSelect addTarget:self action:@selector(selectPhoto) forControlEvents:(UIControlEventTouchUpInside)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnSelect];
    }
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kTPScreenWidth, kTPScreenHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    CGRect rect = CGRectMake(self.view.origin.x, self.view.origin.y, kTPScreenWidth, kTPScreenHeight);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ZQPreviewCell class] forCellWithReuseIdentifier:NSStringFromClass([ZQPreviewCell class])];
    
    NSIndexPath *idx = [NSIndexPath indexPathForItem:self.currentIdx inSection:0];
    [self.collectionView scrollToItemAtIndexPath:idx atScrollPosition:(UICollectionViewScrollPositionLeft) animated:NO];
    
    CGFloat y = kTPScreenHeight - kBottomToolbarHeight;
    self.bottomBar = [[ZQBottomToolbarView alloc] initWithFrame:CGRectMake(0, y, kTPScreenWidth, kBottomToolbarHeight)];
    [self.view addSubview:self.bottomBar];
    self.bottomBar.btnPreview.hidden = YES;
    self.bottomBar.vLine.hidden = YES;
    self.bottomBar.selectedNum = self.selected.count;
    self.bottomBar.bSingleSelection = self.bSingleSelect;
    [self.bottomBar selectionChange:self.selected];
    if (self.bSingleSelect) {
        [self.bottomBar.btnFinish setTitle:_LocalizedString(@"OPERATION_SELECT") forState:(UIControlStateNormal)];
        self.bottomBar.btnFinish.enabled = YES;
        [self.bottomBar.btnFinish sizeToFit];
        CGRect frame = self.bottomBar.frame;
        self.bottomBar.btnFinish.frame = CGRectMake(frame.origin.x+frame.size.width-self.bottomBar.btnFinish.width-16, 0.5, self.bottomBar.btnFinish.frame.size.width, frame.size.height);
    }

    //单选隐藏nav bar
    [self.navigationController setNavigationBarHidden:self.bSingleSelect animated:NO];
    
    ZQAlbumNavVC *nav = (ZQAlbumNavVC *)self.navigationController;
    if (self.bSingleSelect && nav.bEnableCrop) {
        self.cropOverlay = [[ZQCropViewOverlay alloc] init];
        [self.view addSubview:self.cropOverlay];
        self.bottomBar.hidden = YES;
    }
    else {
        self.bottomBar.backgroundColor = kLightBottomBarBGColor;
    }
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ZQPhotoModel *model = self.models[self.currentIdx];
    self.btnSelect.selected = model.bSelected;
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[ZQTools createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    if (self.bSingleSelect) {
        [self.navigationController setNavigationBarHidden:NO];
    }
    [super viewWillDisappear:animated];
}



- (void)getCurrentCrop:(CGRect)rect {
    NSArray *cells = [self.collectionView visibleCells];
    ZQPreviewCell *cell = [cells firstObject];
    
    UIImage *cropImage = [cell crop:rect];
    
    ZQAlbumNavVC *nav = (ZQAlbumNavVC *)self.navigationController;
    [nav dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nav.didFinishPickingPhotosHandle) {
                nav.didFinishPickingPhotosHandle(@[cropImage]);
            }
        });
        
    }];
    
}


#pragma mark - Change Selection - 多选

- (void)selectPhoto {
    if (self.selected.count >= self.maxImagesCount && self.btnSelect.selected == NO) {
        [ZQPhotoFetcher exceedMaxImagesCountAlert:self.maxImagesCount presentingVC:self navVC:((ZQAlbumNavVC*)self.navigationController)];
        return;
    }
    else {
        _btnSelect.selected = !_btnSelect.selected;
        
        NSArray *cells = [self.collectionView visibleCells];
        ZQPreviewCell *cell = [cells firstObject];
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        ZQPhotoModel *model = self.models[indexPath.row];
        model.bSelected = _btnSelect.selected;
        if (model.bSelected) {
            [self.selected addObject:model];
        }
        else {
            [self.selected removeObject:model];
        }
        [self.bottomBar selectionChange:self.selected];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZQPhotoPreviewVC:changeSelection:)]) {
            [self.delegate ZQPhotoPreviewVC:self changeSelection:self.selected];
        }
    }
    
}



#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([ZQPreviewCell class]);
    ZQPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZQPreviewCell alloc] init];
    }
    cell.mPhoto = self.models[indexPath.row];
    ______WS();
    if (!self.bSingleSelect) {
        cell.singleTapBlock = ^{
            BOOL bHidden = wSelf.navigationController.navigationBarHidden;
            [wSelf.navigationController setNavigationBarHidden:!bHidden animated:YES];
            [wSelf setBottomBarHiddenAnimate];
        };
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ZQPreviewCell *c = (ZQPreviewCell *)cell;
    [c display:self.bSingleSelect cache:self.cache indexPath:indexPath];
    self.btnSelect.selected = c.mPhoto.bSelected;
}


- (void)setBottomBarHiddenAnimate {
    ______WS();
    CGFloat viewHeight = self.view.height;
    CGFloat newY = self.bottomBar.y < viewHeight ? viewHeight : viewHeight-kBottomToolbarHeight;
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.bottomBar.origin = CGPointMake(0, newY);
    }];

}

#pragma mark - Getter

- (NSCache *)cache {
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.totalCostLimit = cacheLimit;
    }
    return _cache;
}

@end
