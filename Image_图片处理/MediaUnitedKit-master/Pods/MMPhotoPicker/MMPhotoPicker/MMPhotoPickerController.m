//
//  MMPhotoPickerController.m
//  MMPhotoPicker
//
//  Created by LEA on 2017/11/10.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMPhotoPickerController.h"
#import "MMPhotoAssetController.h"

#pragma mark - ################## MMPhotoPickerController
@interface MMPhotoPickerController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<MMPhotoAlbum *> *photoAlbums;
@property (nonatomic,strong) MMPhotoAlbum *selectPhotoAlbum;

@end

@implementation MMPhotoPickerController

#pragma mark - 初始化
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
    self.title = @"照片";
    self.view.backgroundColor = RGBColor(240.0, 240.0, 240.0, 1.0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonItemAction:)];
    [self.view addSubview:self.tableView];
    // 相册权限
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: { // 权限打开
                    [self loadAlbumData]; // 加载相册
                    break;
                }
                case PHAuthorizationStatusDenied: // 权限拒绝
                case PHAuthorizationStatusRestricted: { // 权限受限
                    if (oldStatus == PHAuthorizationStatusNotDetermined) {
                        [self barButtonItemAction:nil]; // 返回
                        return;
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请在设置>隐私>照片中开启权限"
                                                                   delegate:self
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        });
    }];
}

- (void)loadAlbumData
{
    self.photoAlbums = [[NSMutableArray alloc] init];
    // 获取智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
        // 过滤掉已隐藏、视频、最近删除
        if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden && collection.assetCollectionSubtype !=  PHAssetCollectionSubtypeSmartAlbumVideos && collection.assetCollectionSubtype != 1000000201)
        {
            NSArray<PHAsset *> *assets = [MMPhotoUtil getAllAssetWithAssetCollection:collection ascending:NO];
            if (!self.showEmptyAlbum) { // 不显示空相册
                if ([assets count]) {
                    MMPhotoAlbum *album = [[MMPhotoAlbum alloc] init];
                    album.name = collection.localizedTitle;
                    album.assetCount = assets.count;
                    album.collection = collection;
                    album.coverAsset = assets.firstObject;
                    // '所有照片'置顶
                    if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                        [self.photoAlbums insertObject:album atIndex:0];
                        _selectPhotoAlbum = album;
                    } else {
                        [self.photoAlbums addObject:album];
                    }
                }
            } else { // 显示空相册
                MMPhotoAlbum *album = [[MMPhotoAlbum alloc] init];
                album.name = collection.localizedTitle;
                album.assetCount = assets.count;
                album.collection = collection;
                if (assets.count > 0) {
                    album.coverAsset = assets.firstObject;
                }
                // '所有照片'置顶
                if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                    _selectPhotoAlbum = album;
                    [self.photoAlbums insertObject:album atIndex:0];
                } else {
                    [self.photoAlbums addObject:album];
                }
            }
        }
    }];
    // 获取用户创建相册
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<PHAsset *> *assets = [MMPhotoUtil getAllAssetWithAssetCollection:collection ascending:NO];
        if (assets.count > 0) {
            MMPhotoAlbum *album = [[MMPhotoAlbum alloc] init];
            album.name = collection.localizedTitle;
            album.assetCount = assets.count;
            album.coverAsset = assets.firstObject;
            album.collection = collection;
            [self.photoAlbums addObject:album];
        }
    }];
    [self.tableView reloadData];
    // 跳转
    [self pushAlbumByPhotoAlbum:_selectPhotoAlbum animated:NO];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-kTopBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kRowHeight;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

#pragma mark - 取消
- (void)barButtonItemAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(mmPhotoPickerControllerDidCancel:)]) {
        [self.delegate mmPhotoPickerControllerDidCancel:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photoAlbums count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MMPhotoAlbumCell";
    MMPhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMPhotoAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.textColor = [UIColor grayColor];
    // 封面
    MMPhotoAlbum *album = [self.photoAlbums objectAtIndex:indexPath.row];
    if (album.coverAsset) {
        [MMPhotoUtil getImageWithAsset:album.coverAsset size:cell.imageView.size completion:^(UIImage *image) {
            cell.imageView.image = image;
        }];
    } else {
        cell.imageView.image = [UIImage imageNamed:MMPhotoPickerSrcName(@"mmphoto_empty")];
    }
    // 数量
    NSString *text = [NSString stringWithFormat:@"%@  (%ld)",album.name, (long)album.assetCount];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[album.name length])];
    [attributedText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:NSMakeRange(0,[album.name length])];
    cell.textLabel.attributedText = attributedText;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 跳转
    MMPhotoAlbum *photoAlbum = [self.photoAlbums objectAtIndex:indexPath.row];
    [self pushAlbumByPhotoAlbum:photoAlbum animated:YES];
}

#pragma mark - 跳转
- (void)pushAlbumByPhotoAlbum:(MMPhotoAlbum *)photoAlbum animated:(BOOL)animated
{
    MMPhotoAssetController *controller = [[MMPhotoAssetController alloc] init];
    controller.photoAlbum = photoAlbum;
    controller.mainColor = self.mainColor;
    controller.maximumNumberOfImage = self.maximumNumberOfImage;
    controller.showOriginImageOption = self.showOriginImageOption;
    controller.singleImageOption = self.singleImageOption;
    controller.cropImageOption = self.cropImageOption;
    controller.imageCropSize = self.imageCropSize;
    
    __weak typeof(self) weakSelf = self;
    [controller setCompletion:^(NSArray *info, BOOL isOrigin, BOOL isCancel){
        weakSelf.isOrigin = isOrigin;
        if (isCancel) { // 取消
            if ([weakSelf.delegate respondsToSelector:@selector(mmPhotoPickerControllerDidCancel:)]) {
                [weakSelf.delegate mmPhotoPickerControllerDidCancel:weakSelf];
            } else {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        } else { // 确认选择
            if ([weakSelf.delegate respondsToSelector:@selector(mmPhotoPickerController:didFinishPickingMediaWithInfo:)]) {
                [weakSelf.delegate mmPhotoPickerController:weakSelf didFinishPickingMediaWithInfo:info];
            }
        }
    }];
    [self.navigationController pushViewController:controller animated:animated];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self barButtonItemAction:nil];
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

#pragma mark - ################## MMPhotoAlbum
@implementation MMPhotoAlbum

@end

#pragma mark - ################## MMPhotoAlbumCell
@implementation MMPhotoAlbumCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.contentScaleFactor = [UIScreen mainScreen].scale;
    self.imageView.clipsToBounds = YES;
    self.imageView.frame = CGRectMake(0, 0, kRowHeight, kRowHeight);
    self.textLabel.frame = CGRectMake(self.imageView.right+10, 0, self.width-kRowHeight-40, kRowHeight);
    self.separatorInset = UIEdgeInsetsZero;
}

@end
