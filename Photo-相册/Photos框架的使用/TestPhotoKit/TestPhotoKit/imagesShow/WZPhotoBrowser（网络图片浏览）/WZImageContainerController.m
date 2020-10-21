//
//  WZImageContainerController.m
//  WZPhotoPicker
//
//  Created by admin on 17/5/24.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import "WZImageContainerController.h"

@implementation WZRemoteImgaeProgressView

#pragma mark - Initialize
+ (instancetype)customProgress {
    
    //进度的图的设置
    WZRemoteImgaeProgressView *progress = [[WZRemoteImgaeProgressView alloc] init];
    CGFloat viewHW = 50;
    progress.downloadProgressLayer = [[WZRoundRenderLayer alloc] initWithCircleRadius:viewHW / 2.0 layerLineWidth:5];
    progress.frame = CGRectMake(0.0, 0.0, viewHW, viewHW);
    [progress.layer addSublayer:progress.downloadProgressLayer];
    return progress;
}

#pragma mark - Public
- (void)setProgressRate:(float)rate {
    if (rate > 1) {rate = 1.0;};
    if (self.downloadProgressLayer) {
        self.downloadProgressLayer.renderAngle = (M_PI * 2.0) * rate;
    }
    
}

#pragma mark - Override
- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - frame.size.width) / 2.0, ([UIScreen mainScreen].bounds.size.height - frame.size.height) / 2.0, frame.size.width, frame.size.height)];
}

@end

@interface WZImageContainerController()

@property (nonatomic, strong) WZImageScrollView *scrollPictureView;

@end

@implementation WZImageContainerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollPictureView = [[WZImageScrollView alloc] init];
        [self.view addSubview:_scrollPictureView];
        [self.view addSubview:self.progress];
    }
    return self;
}

- (void)setMainVC:(UIViewController <WZProtocolImageScrollView>*)mainVC {
    if ([mainVC isKindOfClass:[UIViewController class]]) {
        _mainVC = mainVC;
        _scrollPictureView.imageScrollDelegate = (id<WZProtocolImageScrollView>)_mainVC;
    }
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Public
- (void)matchingPicture:(UIImage *)image {
    [_scrollPictureView matchingPicture:image];
}
- (void)focusingWithGesture:(UIGestureRecognizer *)gesture {
    [_scrollPictureView matchZoomWithGesture:gesture];
}


#pragma mark - Accessor
- (WZRemoteImgaeProgressView *)progress {
    if (!_progress) {
        _progress = [WZRemoteImgaeProgressView customProgress];
        _progress.hidden = true;
    }
    return _progress;
}
@end
