//
//  WZPhotoCatalogueController.m
//  WZPhotoPicker
//
//  Created by wizet on 2017/5/21.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZPhotoCatalogueController.h"
#import "WZPhotoPickerController.h"

#pragma mark - WZPhotoCatalogueController
@interface WZPhotoCatalogueController()

@property (nonatomic, strong) WZPhotoPickerController *pickerVC;

@end

@implementation WZPhotoCatalogueCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews {
    self.imageView.frame = CGRectMake(self.frame.size.width - self.frame.size.height + 10, 10, self.frame.size.height - 20, self.frame.size.height - 20);
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
    [self.contentView addSubview:_titleLabel];
    self.backgroundColor = [UIColor lightGrayColor];
    
    _button = [[UIButton alloc] initWithFrame:self.bounds];
    [_button addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button];
    [self.contentView sendSubviewToBack:_button];
    [_button setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:205.0 / 255 green:205.0 / 255 blue:205.0 / 255 alpha:1.0]] forState:UIControlStateNormal];
    [_button setBackgroundImage:[[self class] imageWithColor:[UIColor colorWithRed:238.0 / 255 green:238.0 / 255 blue:238.0 / 255 alpha:1.0]] forState:UIControlStateHighlighted];
    
}

- (void)clickedBtn:(UIButton *)sender {
    if (_clickedBlock) {
        _clickedBlock();
    }
}

- (void)setMediaAssetCollection:(WZMediaAssetCollection *)mediaAssetCollection {
    if ([mediaAssetCollection isKindOfClass:[WZMediaAssetCollection class]]) {
        _mediaAssetCollection = mediaAssetCollection;
        self.titleLabel.text = mediaAssetCollection.title;
        [_mediaAssetCollection coverHandler:^(UIImage *image) {
            self.imageView.image = image;
        }];
    }
}

@end

#pragma mark - WZPhotoCatalogueController
@interface WZPhotoCatalogueController ()

<UICollectionViewDelegate
, UICollectionViewDataSource
, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSArray <WZMediaAssetCollection *>* mediaAssetArrayCollection;

@end

@implementation WZPhotoCatalogueController

#pragma mark - initialize
+ (void)showPickerWithPresentedController:(UIViewController <WZProtocolMediaAsset>*)presentedController {
    WZPhotoCatalogueController *VC = [[WZPhotoCatalogueController alloc] init];
    VC.pickerVC.delegate = (id<WZProtocolMediaAsset>)presentedController;
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:VC];
    [presentedController presentViewController:navigationVC animated:true completion:^{}];
}

#pragma mark - Lifecycle
- (instancetype) init {
    if (self = [super init]) {
        _pickerVC  = [[WZPhotoPickerController alloc] init];
        _pickerVC.restrictNumber = 9;//选图限制
        _mediaAssetArrayCollection = [NSArray array];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSStringFromClass([self class]);
    self.automaticallyAdjustsScrollViewInsets = false;
    [self getAuthorization];
    [self createViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - CreateViews
- (void)createViews {
    [self.view addSubview:self.collection];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    if (self.navigationController) {
        self.navigationItem.leftBarButtonItem = left;
    }
}

-(void)back {
    [self dismissViewControllerAnimated:true completion:^{}];
}

#pragma mark - fetchAuthorization
- (void)getAuthorization {
    [NSObject requestPhotosLibraryAuthorization:^(BOOL ownAuthorization) {
        if (ownAuthorization) {
            //action
            dispatch_async(dispatch_get_main_queue(), ^{
                _mediaAssetArrayCollection = [WZMediaFetcher fetchAssetCollection];
                [_collection reloadData];
            });
        } else {
            //提示可到设置页面获取权限
            [self showAlter];
        }
    }];
}

- (void)showAlter {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"尚未获取到相册权限" message:@"是否到设置处进行权限设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSObject openAppSettings];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alter dismissViewControllerAnimated:true completion:nil];
    }];
    [alter addAction:actionSure];
    [alter addAction:actionCancel];
    [self presentViewController:alter animated:true completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mediaAssetArrayCollection.count;
}

- (__kindof WZPhotoCatalogueCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __block WZPhotoCatalogueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WZPhotoCatalogueCell class]) forIndexPath:indexPath];
    @try {
        if ([_mediaAssetArrayCollection[indexPath.row] isKindOfClass:[WZMediaAssetCollection class]]) {
            
            cell.mediaAssetCollection = _mediaAssetArrayCollection[indexPath.row];
            
            __weak typeof(self) weakSelf = self;
            cell.clickedBlock = ^(){
                //点击目录 进入章节
                weakSelf.pickerVC.mediaAssetArray = weakSelf.mediaAssetArrayCollection[indexPath.row].mediaAssetArray;
                if (weakSelf.navigationController) {
                    [weakSelf.navigationController pushViewController:weakSelf.pickerVC animated:true];
                }
            };
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.debugDescription);
    }
    return cell;
}

#pragma mark - Accessor
- (UICollectionView *)collection {
    if (!_collection) {
        CGRect rect = self.navigationController?CGRectMake(0.0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0):self.view.bounds;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat gap = 10.0;
        layout.minimumLineSpacing = gap;
        layout.minimumInteritemSpacing = gap;
        CGFloat itemW = ([UIScreen mainScreen].bounds.size.width);
        CGFloat itemH = 44 + gap * 2.0;
        layout.itemSize = CGSizeMake(itemW, itemH);
        
        _collection = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.delaysContentTouches = false;
        _collection.dataSource = self;
        _collection.delegate = self;
        [_collection registerClass:[WZPhotoCatalogueCell class] forCellWithReuseIdentifier:NSStringFromClass([WZPhotoCatalogueCell class])];
    }
    return _collection;
}

@end
