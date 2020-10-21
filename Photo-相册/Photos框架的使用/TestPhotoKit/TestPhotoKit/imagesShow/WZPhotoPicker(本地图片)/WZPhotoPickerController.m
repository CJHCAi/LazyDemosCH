//
//  WZPhotoPickerController.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/5/19.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZPhotoPickerController.h"
#import "WZMediaAssetBaseCell.h"

#import "WZImageBrowseController.h"
#import "WZAssetBrowseController.h"
#import "WZRemoteImageBrowseController.h"

#pragma mark - WZPhotoPickerController
@interface WZPhotoPickerController ()
<UICollectionViewDelegate
, UICollectionViewDataSource
, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collection;

@end

@implementation WZPhotoPickerController

#pragma mark - initialize

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
    self.automaticallyAdjustsScrollViewInsets = false;
    if (!_mediaAssetArray) {
        _mediaAssetArray = [NSArray array];
    }
    
    [self createViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - create views
- (void)createViews {
    [self.view addSubview:self.collection];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回目录" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"选择完成" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
    
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = left;
        self.navigationItem.rightBarButtonItem = right;
    }
}

- (void)finish {
    //如果实现了代理
    if ([_delegate respondsToSelector:@selector(fetchImages:)]) {
        //获取选中目标  同步取出大小图
        NSLock *lock = [[NSLock alloc] init];
        [lock tryLock];
        NSMutableArray *mArray_images = [NSMutableArray array];
        for (WZMediaAsset *mediaAsset in self.mediaAssetArray) {
            if (mediaAsset.selected) {
                if (mediaAsset.origion) {
                    [mediaAsset fetchOrigionImageSynchronous:true handler:^(UIImage *image) {
                        [mArray_images addObject:image];
                    }];
                } else {
                    [WZMediaFetcher fetchImageWithAsset:mediaAsset.asset costumSize:WZMEDIAASSET_CUSTOMSIZE synchronous:true handler:^(UIImage *image) {
                        [mArray_images addObject:image];
                    }];
                }
            }
        }
      
        [lock unlock];
        [_delegate fetchImages:mArray_images];
        //同步完
        [self dismiss];
    } else {
        [self dismiss];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:true completion:^{
        if ([_delegate respondsToSelector:@selector(fetchAssets:)]) {
            NSMutableArray *mmediaAssetArray_callback = [NSMutableArray array];
            for (WZMediaAsset *mediaAsset in self.mediaAssetArray) {
                if (mediaAsset.selected) {
                    [mmediaAssetArray_callback addObject:mediaAsset];
                }
            }
            [_delegate fetchAssets:[NSArray arrayWithArray:mmediaAssetArray_callback]];
        }
    }];
}

-(void)back {
    //复原选择数据
    for (WZMediaAsset *asset in self.mediaAssetArray) {
        asset.selected = false;
        asset.origion = false;
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self dismissViewControllerAnimated:true completion:^{}];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mediaAssetArray.count;
}

- (__kindof WZMediaAssetBaseCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZMediaAssetBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WZMediaAssetBaseCell class]) forIndexPath:indexPath];
    
    @try {
        cell.asset = _mediaAssetArray[indexPath.row];
        __weak typeof(cell) weakCell = cell;
        __weak typeof(self) weakSelf = self;
         cell.selectedBlock = ^(BOOL selected) {
            if ([weakSelf overloadJudgement] && !weakCell.asset.selected) {
                
            } else {
                weakCell.asset.selected = !weakCell.asset.selected;
                weakCell.selectButton.selected = weakCell.asset.selected;
            }
        };   
    } @catch (NSException *exception) {
        
    }
    return cell;
}

- (BOOL)overloadJudgement {
    if (self.restrictNumber == 0) {
        return false;
    }
    
    NSUInteger restrictNumber = 0;
    for (WZMediaAsset *asset in self.mediaAssetArray) {
        if (asset.selected == true) {
            restrictNumber = restrictNumber + 1;
        }
    }
    if (self.restrictNumber <= restrictNumber) {
        return true;
    }
    
    return false;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    WZMediaAssetBaseCell *cell = (WZMediaAssetBaseCell *)[collectionView cellForItemAtIndexPath:indexPath];

    //浏览大图
    if (self.mediaAssetArray.count) {
        WZAssetBrowseController *VC = [[WZAssetBrowseController alloc] init];
        VC.imagesBrowseDelegate = (id<WZProtocolImageBrowse>)self;
        VC.mediaAssetArray = self.mediaAssetArray;
        VC.restrictNumber = self.restrictNumber;
        [VC showInIndex:indexPath.row animated:true];
        [self presentViewController:VC animated:true completion:^{}];
    }
}

#pragma mark - WZProtocolImageBrowse
- (void)backAction {
    [self.collection reloadData];
}

- (void)send {
    [self finish];
}

#pragma mark - WZProtocolMediaAsset
- (void)fetchAssets:(NSArray <WZMediaAsset *> *)assets {
    if (assets) {
    }
}

#pragma mark - Accessor
- (void)setMediaAssetArray:(NSArray<WZMediaAsset *> *)mediaAssetArray {
    _mediaAssetArray = [mediaAssetArray isKindOfClass:[NSArray class]]?mediaAssetArray:nil;
    if (_collection) {
        [_collection reloadData];
    }
}

- (UICollectionView *)collection {
    if (!_collection) {
        CGRect rect = self.navigationController?CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0):self.view.bounds;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat gap = 10.0;
        layout.minimumLineSpacing = gap;
        layout.minimumInteritemSpacing = gap;
        layout.sectionInset = UIEdgeInsetsMake(gap, gap, gap, gap);
        CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - gap * 5) / 4;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        
        _collection = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.dataSource = self;
        _collection.delegate = self;
        [_collection registerClass:[WZMediaAssetBaseCell class] forCellWithReuseIdentifier:NSStringFromClass([WZMediaAssetBaseCell class])];
    }
    return _collection;
}


@end
