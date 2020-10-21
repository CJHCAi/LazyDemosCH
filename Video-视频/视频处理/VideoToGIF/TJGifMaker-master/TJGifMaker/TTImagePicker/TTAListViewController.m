//
//  TTAListViewController.m
//  videoStudy_1
//
//  Created by 李曈 on 2017/2/24.
//  Copyright © 2017年 lt. All rights reserved.
//

#import "TTAListViewController.h"
#import <Photos/Photos.h>
#import "TTPhotosGridViewController.h"
#import "TTConst.h"

//#define kAListCellIdentifier @"com.tt.aListcell"

static  NSString *  const  kAListCellIdentifier = @"com.tt.aListcell";

#pragma mark - TTAListCellModel

@interface TTAListCellModel : NSObject

@property (copy, nonatomic) NSString * colletionTitle;

@property (strong, nonatomic) UIImage * headImg;

@property (strong, nonatomic) NSNumber * totalCount;

@property (strong, nonatomic) NSNumber * index;

@end

@implementation TTAListCellModel


@end

#pragma mark - TTAListCell

@interface TTAListCell : UITableViewCell

@property (strong, nonatomic) TTAListCellModel * model;

@property (strong, nonatomic) UIImageView * groupHeadView;

@property (strong, nonatomic) UILabel * decriptionTitleLabel;

@property (strong, nonatomic) NSNumber * groupCount;

@end

@implementation TTAListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    _groupHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80,70)];
    _groupHeadView.contentMode = UIViewContentModeScaleAspectFill;
    _groupHeadView.clipsToBounds = YES;
    [self.contentView addSubview:_groupHeadView];
    
    _decriptionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_groupHeadView.frame.size.width  + 5, 0,TTScreenWidth - _groupHeadView.frame.size.width - 20, _groupHeadView.frame.size.height)];
    _decriptionTitleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_decriptionTitleLabel];
}

-(void)setModel:(TTAListCellModel *)model{
    _groupHeadView.image = model.headImg;
    if (!model.totalCount) {
        model.totalCount = @0;
    }
    _decriptionTitleLabel.text = [NSString stringWithFormat:@"%@ (%@)",model.colletionTitle,model.totalCount];
}

@end

#pragma mark - TTAListCTTAListViewControllerell

@interface TTAListViewController ()<UITableViewDelegate,UITableViewDataSource,PHPhotoLibraryChangeObserver>{

}

@property (strong, nonatomic) UITableView * aListView;

@property (copy, nonatomic) NSArray * aListArray;

@property (strong, nonnull) NSMutableArray * listModelArray;

@property (copy, nonatomic) TTSelectedImg selectImgBlock;

@property (assign, nonatomic) NSInteger maxPhotoNum;

//PHFetchResult
//system create
@property (strong, nonatomic) PHFetchResult * alist_smart;
//user create
@property (strong, nonatomic) PHFetchResult * alist_album;
@end

@implementation TTAListViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setConfig];
    }
    return self;
}

-(void)setConfig{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetMaxPhotoNum:) name:TTSetMaxPhotoNumNotice object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self congfig];
    [self setUpUI];
    
}
-(void)congfig{
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}
-(void)dealloc{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//设置最大选择数量的通知
-(void)resetMaxPhotoNum:(NSNotification *)message{
    NSNumber * max = message.object;
    self.maxPhotoNum = [max integerValue];
}

-(void)setUpUI{
    
    self.title = @"照片";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    _aListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TTScreenWidth, TTScreenHeight - 64)];
    _aListView.delegate = self;
    _aListView.dataSource = self;
    _aListView.rowHeight = 70.0f;
    _aListView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    [self.view addSubview:_aListView];
    [_aListView registerClass:[TTAListCell class] forCellReuseIdentifier:kAListCellIdentifier];
    [_aListView setTableFooterView:[UIView new]];
    [self getAListFromSystems];

    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancle)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

}

-(void)cancle{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 获取所有相册信息
 */
-(void)getAListFromSystems{
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"estimatedAssetCount" ascending:NO];
    PHFetchOptions * fetchOptions= [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[sort];
    _alist_smart = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum  subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    _alist_album = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum  subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    [self readFetchResult];
}
-(void)readFetchResult{
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:_alist_smart.count + _alist_album.count];
    self.listModelArray = [[NSMutableArray alloc] init];
    //这是所有照片
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
    PHFetchOptions * options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[descriptor];
    PHFetchResult * fetchResult = [PHAsset fetchAssetsWithOptions:options];
    TTAListCellModel * model = [TTAListCellModel new];
    model.index = @(0);
    model.colletionTitle = @"所有照片";
    [self.listModelArray addObject:model];
    [mArray addObject:fetchResult];
    
    for (NSInteger i = 0; i < _alist_album.count; i++) {
        PHCollection * collection = _alist_album[i];
        [mArray addObject:collection];
        TTAListCellModel * model = [TTAListCellModel new];
        model.index = @(i + 1);
        model.colletionTitle = collection.localizedTitle;
        [self.listModelArray addObject:model];
    }
    for (NSInteger i = 0; i < _alist_smart.count; i++) {
        PHCollection * collection = _alist_smart[i];
        [mArray addObject:collection];
        TTAListCellModel * model = [TTAListCellModel new];
        model.index = @(i + _alist_album.count + 1);
        model.colletionTitle = collection.localizedTitle;
        [self.listModelArray addObject:model];
    }
    self.aListArray = mArray.copy;
    mArray = nil;
    [_aListView reloadData];
    [self getFristImgForEveryColletcion];
}

-(void)getFristImgForEveryColletcion{
    //取出相册中的第一个相片
    PHImageManager * manager = [PHCachingImageManager defaultManager];
    PHFetchOptions * options = [[PHFetchOptions alloc] init];
    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
    PHImageRequestOptions * requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    dispatch_queue_t queue = dispatch_queue_create("com.tt.getheadImg", DISPATCH_QUEUE_SERIAL);
    dispatch_group_t group = dispatch_group_create();
    __weak typeof (self)wealSelf = self;
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < wealSelf.aListArray.count; i ++) {
            dispatch_group_enter(group);
            PHAssetCollection * collection = (PHAssetCollection *)self.aListArray[i];
            options.sortDescriptors = @[descriptor];
            PHFetchResult * fetchResult = nil;
            if (i != 0) {
                fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            }else{
                fetchResult = [PHAsset fetchAssetsWithOptions:options];
            }
            if (fetchResult.count > 0) {
                PHAsset * asset = fetchResult[0];
                [manager requestImageForAsset:asset targetSize:CGSizeMake(80 * TTScale, 70 * TTScale) contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    TTAListCellModel * model = _listModelArray[i];
                    model.totalCount = @(fetchResult.count);
                    model.headImg = result;
                    dispatch_group_leave(group);
                }];
            }else{
                dispatch_group_leave(group);
                UIImage * defaultImg = [UIImage imageNamed:@"tt_img_default@2x"];
                TTAListCellModel * model = _listModelArray[i];
                model.totalCount = @(fetchResult.count);
                model.headImg = defaultImg;
            }
            
        }
    });
    dispatch_group_notify(group, queue, ^{
        NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        [wealSelf.listModelArray sortUsingDescriptors:@[sort]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [wealSelf.aListView reloadData];
        });
    });
}


-(void)completeChooseImage:(TTSelectedImg)block{
    _selectImgBlock = block;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listModelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTAListCell * cell = [tableView dequeueReusableCellWithIdentifier:kAListCellIdentifier];
    TTAListCellModel * model = _listModelArray[indexPath.row];
    cell.model = model;
    return cell;
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTPhotosGridViewController * girdVC = [[TTPhotosGridViewController alloc] init];
    PHFetchResult * fetchResult = nil;
    if (indexPath.row != 0) {
        PHAssetCollection * assetCollection = (PHAssetCollection *)self.aListArray[indexPath.row];
        PHFetchOptions * options = [[PHFetchOptions alloc] init];
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
        options.sortDescriptors = @[descriptor];
        fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    }else{
        fetchResult = self.aListArray[0];
    }
    
    girdVC.fetchResult = fetchResult;
    girdVC.maxPhotoNum = self.maxPhotoNum ? self.maxPhotoNum : 6;
    [girdVC completeChooseImage:^(NSArray *images) {
        _selectImgBlock(images);
    }];
    [self.navigationController pushViewController:girdVC animated:YES];
}
#pragma mark -PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self getAListFromSystems];
    });
}
@end
