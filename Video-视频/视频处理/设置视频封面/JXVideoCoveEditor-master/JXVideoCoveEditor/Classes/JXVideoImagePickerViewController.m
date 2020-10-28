//
//  JXVideoImagePickerViewController.m
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXVideoImagePickerViewController.h"
#import "JXUIService.h"
#import "JXVideoImagePickerCell.h"
#import "JXVideoImageGenerator.h"
#import "JXVideoImagePickerCursorViewController.h"
#import "JXVideoImagePickerVideoPlayerController.h"



static CGFloat const KeyframePickerViewCellHeight = 40;

@interface JXVideoImagePickerViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;

/** UI*/
@property (nonatomic, strong)JXUIService *UIService;

@property(nonatomic, strong) JXVideoImagePickerCursorViewController *cursorContainerViewController;


@property(nonatomic, strong) JXVideoImagePickerVideoPlayerController *displayerVC;

@end

@implementation JXVideoImagePickerViewController

#pragma mark - lazy loading

- (JXVideoImagePickerVideoPlayerController *)displayerVC{
    if (_displayerVC == nil) {
        _displayerVC = [[JXVideoImagePickerVideoPlayerController alloc]init];
        _displayerVC.asset = [self getAsset];
        
        JXWeakSelf(self);
        [_displayerVC setResultImageBlock:^(UIImage *resultImage) {
            JXStrongSelf(self);
            
            if (self.generatedKeyframeImageHandler) {
                self.generatedKeyframeImageHandler(resultImage);
            }
            
        }];
    }
    return _displayerVC;
}

- (JXVideoImagePickerCursorViewController *)cursorContainerViewController{
    if (_cursorContainerViewController == nil) {
        _cursorContainerViewController = [[JXVideoImagePickerCursorViewController alloc]init];
    }
    return _cursorContainerViewController;
}


- (JXUIService *)UIService{
    if (_UIService == nil) {
        _UIService = [[JXUIService alloc]init];
        _UIService.asset = [self getAsset];
        JXWeakSelf(self);
        [_UIService setScrollDidBlock:^(CMTime currentTime) {
            JXStrongSelf(self);

            [self.displayerVC seekToTime:currentTime];
        }];
    }
    return _UIService;
}


- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(KeyframePickerViewCellWidth, KeyframePickerViewCellHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.dataSource = self.UIService;
        _collectionView.delegate = self.UIService;
        
        [_collectionView registerClass:[JXVideoImagePickerCell class] forCellWithReuseIdentifier:kVideoCellIdentifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        //左右留白（屏幕一半宽），目的是让collectionView中的第一个和最后一个cell能滚动到屏幕中央
        _collectionView.contentInset = UIEdgeInsetsMake(0, JXScreenW * 0.5, 0, JXScreenW * 0.5);
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _collectionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    JXWeakSelf(self);
    
    [self.UIService loadData:[self getAsset] callBlock:^{
        [weakself.collectionView reloadData];
    }];
}


- (void)setupUI{
    
    
    [self addChildViewController:self.displayerVC];
    [self.view addSubview:self.displayerVC.view];
    [self.view addSubview:self.collectionView];
    [self addChildViewController:self.cursorContainerViewController];
    [self.view addSubview:self.cursorContainerViewController.view];
    
    
    
    JXWeakSelf(self);
    
    
    
    [self.displayerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.right.left.equalTo(weakself.view);
        make.top.equalTo(weakself.view.mas_top).offset(64);
        make.height.equalTo(@200);
        
    }];
    
//    self.displayerVC.view.backgroundColor = [UIColor redColor];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.equalTo(weakself.view);
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-64);
        make.height.equalTo(@(KeyframePickerViewCellHeight));
    }];
    
    
    [self.cursorContainerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakself.view);
        make.bottom.equalTo(weakself.collectionView);
        make.size.mas_equalTo(CGSizeMake(25, KeyframePickerViewCellHeight));
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Actions
- (AVAsset *)getAsset{
    
    if (_asset) {
        return _asset;
    }
    
    NSURL *videoURL = [NSURL URLWithString:_videoPath];
    
    if (videoURL == nil || videoURL.scheme == nil ) {
        videoURL = [NSURL fileURLWithPath:_videoPath];
    }
    
    if (videoURL) {
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        return urlAsset;
    }
    
    
    return nil;
    
}




@end
