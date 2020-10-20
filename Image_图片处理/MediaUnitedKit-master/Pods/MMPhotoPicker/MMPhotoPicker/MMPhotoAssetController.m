//
//  MMPhotoAssetController.m
//  MMPhotoPicker
//
//  Created by LEA on 2017/11/10.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMPhotoAssetController.h"
#import "MMPhotoPreviewController.h"
#import "MMPhotoCropController.h"

#pragma mark - ################## MMPhotoAssetController
static NSString *const CellIdentifier = @"MMPHAssetCell";

@interface MMPhotoAssetController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray<MMPHAsset *> *mmPHAssetArray;
@property (nonatomic,strong) NSMutableArray<PHAsset *> *selectedAssetArray;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *previewBtn;
@property (nonatomic,strong) UIButton *originBtn;
@property (nonatomic,strong) UIButton *finishBtn;
@property (nonatomic,strong) UILabel *numberLab;

// 是否回传原图[可用于控制图片压系数]
@property (nonatomic, assign) BOOL isOrigin;

@end

@implementation MMPhotoAssetController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isOrigin = NO;
        _cropImageOption = NO;
        _singleImageOption = NO;
        _showOriginImageOption = NO;
        _mainColor = kMainColor;
        _maximumNumberOfImage = 9;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.photoAlbum.name;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction)];
    
    // 初始化
    _isOrigin = NO;
    if (!_mainColor) {
        _mainColor = kMainColor;
    }
    if (_maximumNumberOfImage == 0) {
        _maximumNumberOfImage = 9;
    }
    [self.view addSubview:self.collectionView];
    if (!_cropImageOption && !_singleImageOption) {
        self.collectionView.height = self.view.height-kTopBarHeight-kBottomHeight;
        // 是否显示原图选项
        _originBtn.hidden = !self.showOriginImageOption;
        [self.view addSubview:self.bottomView];
    }
    // 获取指定相册所有照片
    self.mmPHAssetArray = [[NSMutableArray alloc] init];
    self.selectedAssetArray = [[NSMutableArray alloc] init];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.photoAlbum.collection options:option];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        if (asset.mediaType == PHAssetMediaTypeImage) {
            MMPHAsset *mmAsset = [[MMPHAsset alloc] init];
            mmAsset.asset = asset;
            mmAsset.isSelected = NO;
            [self.mmPHAssetArray addObject:mmAsset];
        }
    }];
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-kTopBarHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[MMPHAssetCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, self.view.width, kBottomHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.userInteractionEnabled = NO;
        _bottomView.alpha = 0.5;
        
        CGFloat btHeight = 50.0f;
        // 上边框
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, _bottomView.width, 0.5);
        layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        [_bottomView.layer addSublayer:layer];
        
        // 预览
        _previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, btHeight)];
        _previewBtn.tag = 100;
        [_previewBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_previewBtn];
        
        // 原图
        _originBtn = [[UIButton alloc] initWithFrame:CGRectMake(_previewBtn.right+10, 0, 90, btHeight)];
        _originBtn.tag = 101;
        [_originBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_originBtn setTitle:@"原图" forState:UIControlStateNormal];
        [_originBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_originBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_originBtn setImage:[UIImage imageNamed:MMPhotoPickerSrcName(@"mmphoto_mark")] forState:UIControlStateNormal];
        [_originBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_originBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_originBtn];
        
        _numberLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-70, (btHeight-20)/2, 20, 20)];
        _numberLab.backgroundColor = _mainColor;
        _numberLab.layer.cornerRadius = _numberLab.frame.size.height/2;
        _numberLab.layer.masksToBounds = YES;
        _numberLab.textColor = [UIColor whiteColor];
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.font = [UIFont boldSystemFontOfSize:13.0];
        _numberLab.adjustsFontSizeToFitWidth = YES;
        [_bottomView addSubview:_numberLab];
        _numberLab.hidden = YES;
        
        _finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-60, 0, 60, btHeight)];
        _finishBtn.tag = 102;
        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:_mainColor forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_finishBtn];
    }
    return _bottomView;
}

#pragma mark - 事件处理
- (void)rightBarItemAction
{
    if (self.completion) {
        self.completion(nil, _isOrigin, YES);
    }
}

- (void)leftBarItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonAction:(UIButton *)btn
{
    if (btn.tag == 100) // 预览
    {
        MMPhotoPreviewController *previewVC = [[MMPhotoPreviewController alloc] init];
        previewVC.assetArray = self.selectedAssetArray;
        [previewVC setPhotoDeleteBlock:^(PHAsset *asset) {
             for (MMPHAsset *mmAsset in self.mmPHAssetArray) {
                 if (mmAsset.asset == asset)  {
                     NSInteger index = [self.mmPHAssetArray indexOfObject:mmAsset];
                     mmAsset.isSelected = NO;
                     [self.mmPHAssetArray replaceObjectAtIndex:index withObject:mmAsset];
                     [self.collectionView reloadData];
                     break;
                 }
             }
             [self updateUI];
         }];
        [self.navigationController pushViewController:previewVC animated:YES];
    }
    else if (btn.tag == 101)  // 原图
    {
        if (_isOrigin) {
            [_originBtn setImage:[UIImage imageNamed:MMPhotoPickerSrcName(@"mmphoto_mark")] forState:UIControlStateNormal];
        } else {
            [_originBtn setImage:[UIImage imageNamed:MMPhotoPickerSrcName(@"mmphoto_marked")] forState:UIControlStateNormal];
        }
        _isOrigin = !_isOrigin;
    }
    else // 确定
    {
        if (!self.completion) {
            NSLog(@"警告:未设置回传!!!");
            return;
        }
        NSMutableArray *result = [[NSMutableArray alloc] init];
        NSInteger totalNumber = [self.selectedAssetArray count];
        for(NSInteger i = 0; i < totalNumber; i ++)
        {
            PHAsset *asset = [self.selectedAssetArray objectAtIndex:i];
            // 获取图片
            [MMPhotoUtil getImageWithAsset:asset completion:^(UIImage *image) {
                // 封装
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                if (asset.location) {
                    [dictionary setObject:asset.location forKey:MMPhotoLocation];
                }
                [dictionary setObject:@(asset.mediaType) forKey:MMPhotoMediaType];
                [dictionary setObject:image forKey:MMPhotoOriginalImage];
                // 加入数组
                [result addObject:dictionary];
                // 回传
                if (i == totalNumber-1) {
                    self.completion(result, _isOrigin, NO);
                }
            }];
        }
    }
}

- (void)updateUI
{
    if (![self.selectedAssetArray count]) {
        self.bottomView.alpha = 0.5;
        _numberLab.hidden = YES;
        self.bottomView.userInteractionEnabled = NO;
    } else {
        self.bottomView.alpha = 1.0;
        _numberLab.hidden = NO;
        _numberLab.text = [NSString stringWithFormat:@"%d",(int)[self.selectedAssetArray count]];
        self.bottomView.userInteractionEnabled = YES;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger eachLine = 4;
    if (kDeviceIsIphone6p) {
        eachLine = 5;
    }
    CGFloat cellWidth = (self.view.width-(eachLine+1)*kBlankWidth)/eachLine;
    return CGSizeMake(cellWidth, cellWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kBlankWidth, kBlankWidth, kBlankWidth, kBlankWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kBlankWidth;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mmPHAssetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMPHAsset *mmAsset = [self.mmPHAssetArray objectAtIndex:indexPath.row];
    // 赋值
    MMPHAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.asset = mmAsset.asset;
    cell.selected = mmAsset.isSelected;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MMPHAsset *mmAsset = [self.mmPHAssetArray objectAtIndex:indexPath.row];
    PHAsset *asset = mmAsset.asset;
    // 图片裁剪
    if (_cropImageOption)
    {
        // 获取图片
        [MMPhotoUtil getImageWithAsset:asset completion:^(UIImage *image) {
            MMPhotoCropController *controller = [[MMPhotoCropController alloc] init];
            controller.originalImage = image;
            controller.imageCropSize = self.imageCropSize;
            [controller setImageCropBlock:^(UIImage *cropImage){
                if (!self.completion) {
                    NSLog(@"警告:未设置回传!!!");
                    return;
                }
                // 封装
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                if (asset.location) {
                    [dictionary setObject:asset.location forKey:MMPhotoLocation];
                }
                [dictionary setObject:@(asset.mediaType) forKey:MMPhotoMediaType];
                [dictionary setObject:cropImage forKey:MMPhotoOriginalImage];
                // 回传
                self.completion(@[dictionary], _isOrigin, NO);
            }];
            [self.navigationController pushViewController:controller animated:YES];
        }];
        return;
    }
    
    // 选择一个>>直接返回
    if (_singleImageOption)
    {
        if (!self.completion) {
            NSLog(@"警告:未设置回传!!!");
            return;
        }
        // 获取图片
        [MMPhotoUtil getImageWithAsset:asset completion:^(UIImage *image) {
            // 封装
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            if (asset.location) {
                [dictionary setObject:asset.location forKey:MMPhotoLocation];
            }
            [dictionary setObject:@(asset.mediaType) forKey:MMPhotoMediaType];
            [dictionary setObject:image forKey:MMPhotoOriginalImage];
            // 回传
            self.completion(@[dictionary], _isOrigin, NO);
        }];
        return;
    }
    
    // 提醒
    if (([self.selectedAssetArray count] == _maximumNumberOfImage) && !mmAsset.isSelected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多可以添加%ld张图片",(long)_maximumNumberOfImage]
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    mmAsset.isSelected = !mmAsset.isSelected;
    [self.mmPHAssetArray replaceObjectAtIndex:indexPath.row withObject:mmAsset];
    [self.collectionView reloadData];
    
    if (mmAsset.isSelected) {
        [self.selectedAssetArray addObject:asset];
    } else {
        [self.selectedAssetArray removeObject:asset];
    }
    [self updateUI];
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

#pragma mark - ################## MMPHAsset
@implementation MMPHAsset

@end

#pragma mark - ################## MMPHAssetCell
@interface MMPHAssetCell ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *overLay;

@end

@implementation MMPHAssetCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.overLay];
        self.overLay.hidden = YES;
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.masksToBounds = YES;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    }
    return _imageView;
}

- (UIImageView *)overLay
{
    if (!_overLay) {
        _overLay = [[UIImageView alloc] initWithFrame:self.bounds];
        _overLay.image = [UIImage imageNamed:MMPhotoPickerSrcName(@"mmphoto_overlay")];
    }
    return _overLay;
}

#pragma mark - setter
- (void)setSelected:(BOOL)selected
{
    self.overLay.hidden = !selected;
}

- (void)setAsset:(PHAsset *)asset
{
    [MMPhotoUtil getImageWithAsset:asset size:self.imageView.size completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

@end
