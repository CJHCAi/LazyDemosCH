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

static int const KeyframePickerViewCellWidth = 67;

@interface JXVideoImagePickerViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;
/// 展示image
@property(nonatomic,strong) NSArray<JXVideoImage *> * displayKeyframeImages;

/** UI*/
@property (nonatomic, strong)JXUIService *UIService;

@property(nonatomic, strong) JXVideoImagePickerCursorViewController *cursorContainerViewController;

@end

@implementation JXVideoImagePickerViewController

#pragma mark - lazy loading

- (JXVideoImagePickerCursorViewController *)cursorContainerViewController{
    if (_cursorContainerViewController == nil) {
        _cursorContainerViewController = [[JXVideoImagePickerCursorViewController alloc]init];
    }
    return _cursorContainerViewController;
}


- (JXUIService *)UIService{
    if (_UIService == nil) {
        _UIService = [[JXUIService alloc]init];
    }
    return _UIService;
}


- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(KeyframePickerViewCellWidth, 30);
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
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        
    }
    
    return _collectionView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self loadData];
}


- (void)loadData{
    
    [JXVideoImageGenerator generateDefaultSequenceOfImagesFromAsset:[self getAsset] closure:^(NSArray<JXVideoImage *> *images) {
        
        self.displayKeyframeImages = images;
        self.UIService.displayKeyframeImages = images;
        [self.collectionView reloadData];
    }];
}

- (void)setupUI{
    
    [self.view addSubview:self.collectionView];
    [self addChildViewController:self.cursorContainerViewController];
    [self.view addSubview:self.cursorContainerViewController.view];
    
}




- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    JXWeakSelf(self);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.equalTo(weakself.view);
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-64);
        make.height.equalTo(@(60));
    }];
    
    
    [self.cursorContainerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakself.view);
        make.bottom.equalTo(weakself.collectionView);
        make.size.mas_equalTo(CGSizeMake(25, 60));
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



#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

@end
