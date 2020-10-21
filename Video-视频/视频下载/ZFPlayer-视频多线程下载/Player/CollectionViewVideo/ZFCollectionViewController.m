//
//  ZFCollectionViewController.m
//  Player
//
//  Created by 任子丰 on 17/3/22.
//  Copyright © 2017年 任子丰. All rights reserved.
//

#import "ZFCollectionViewController.h"
#import "ZFCollectionViewCell.h"
#import <ZFDownload/ZFDownloadManager.h>

@interface ZFCollectionViewController () <ZFPlayerDelegate>

@property (nonatomic, strong) NSMutableArray      *dataSource;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation ZFCollectionViewController

static NSString * const reuseIdentifier = @"collectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 5;
    CGFloat itemWidth = ScreenWidth/2 - 2*margin;
    CGFloat itemHeight = itemWidth*9/16 + 30;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.sectionInset = UIEdgeInsetsMake(10, margin, 10, margin);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    self.collectionView.collectionViewLayout = layout;
    [self requestData];
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}

- (void)requestData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.dataSource = @[].mutableCopy;
    NSArray *videoList = [rootDict objectForKey:@"videoList"];
    for (NSDictionary *dataDic in videoList) {
        ZFVideoModel *model = [[ZFVideoModel alloc] init];
        [model setValuesForKeysWithDictionary:dataDic];
        [self.dataSource addObject:model];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    if (ZFPlayerShared.isLandscape) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // 取到对应cell的model
    __block ZFVideoModel *model        = self.dataSource[indexPath.row];
    // 赋值model
    cell.model                         = model;
    __block NSIndexPath *weakIndexPath = indexPath;
    __block ZFCollectionViewCell *weakCell = cell;
    __weak typeof(self)  weakSelf      = self;
    // 点击播放的回调
    cell.playBlock = ^(UIButton *btn){
        
        // 分辨率字典（key:分辨率名称，value：分辨率url)
        NSMutableDictionary *dic = @{}.mutableCopy;
        for (ZFVideoResolution * resolution in model.playInfo) {
            [dic setValue:resolution.url forKey:resolution.name];
        }
        // 取出字典中的第一视频URL
        NSURL *videoURL = [NSURL URLWithString:dic.allValues.firstObject];
        
        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
        playerModel.title            = model.title;
        playerModel.videoURL         = videoURL;
        playerModel.placeholderImageURLString = model.coverForFeed;
        playerModel.scrollView       = weakSelf.collectionView;
        playerModel.indexPath        = weakIndexPath;
        // 赋值分辨率字典
        playerModel.resolutionDic    = dic;
        // player的父视图tag
        playerModel.fatherViewTag    = weakCell.topicImageView.tag;
        
        // 设置播放控制层和model
        [weakSelf.playerView playerControlView:nil playerModel:playerModel];
        // 下载功能
        weakSelf.playerView.hasDownload = YES;
        // 自动播放
        [weakSelf.playerView autoPlayTheVideo];
    };
    
    return cell;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}


@end
