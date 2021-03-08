//
//  ZQVideoPlayVC.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/27.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQVideoPlayVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ZQPhotoModel.h"
#import "ZQPhotoFetcher.h"
#import "ZQAlbumNavVC.h"
#import "ProgressHUD.h"
#import "ZQTools.h"
#import "ZQPublic.h"
#import "NSString+Size.h"


@interface ZQVideoPlayVC ()
@property (nonatomic, strong) UIImageView *ivPlay;
@property (nonatomic, strong) UIView *vBottomBar;
@property (nonatomic, strong) UIButton *btnFinish;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) BOOL bPause;

@property (nonatomic, strong) UIImage *exportImage;
//@property (nonatomic, strong)
@end
@implementation ZQVideoPlayVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.navigationItem.title = _LocalizedString(@"OPERATION_PREVIEW");
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[ZQTools createImageWithColor:kLightBottomBarBGColor] forBarMetrics:UIBarMetricsDefault];
    UIButton* btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    [btnLeft addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setImage:[ZQTools image:_image(@"navi_back") withTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    
    self.vBottomBar = [[UIView alloc] init];
    self.vBottomBar.backgroundColor = kLightBottomBarBGColor;//[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    self.vBottomBar.frame = CGRectMake(0, kTPScreenHeight - kBottomToolbarHeight, kTPScreenWidth, kBottomToolbarHeight);
    [self.view addSubview:self.vBottomBar];
    
    self.btnFinish = [[UIButton alloc] init];
    [self.btnFinish setTitle:_LocalizedString(@"OPERATION_OK") forState:UIControlStateNormal];
    self.btnFinish.titleLabel.font = [UIFont systemFontOfSize:16];
    self.btnFinish.titleLabel.textColor = ZQAlbumBarTintColor;
    [self.btnFinish setTitleColor:ZQAlbumBarTintColor forState:UIControlStateNormal];
    CGSize size = [self.btnFinish.titleLabel.text textSizeWithFont:self.btnFinish.titleLabel.font constrainedToSize:CGSizeMake(self.view.frame.size.width, 50) lineBreakMode:NSLineBreakByTruncatingTail];
    self.btnFinish.frame = CGRectMake(kTPScreenWidth-ZQSide_X-size.width, 0, size.width, kBottomToolbarHeight);
    [self.vBottomBar addSubview:self.btnFinish];
    [self.btnFinish addTarget:self action:@selector(okVideoSelect) forControlEvents:UIControlEventTouchUpInside];
    
    self.ivPlay = [[UIImageView alloc] init];
    UIImage *image = _image(@"MMVideoPreviewPlay");
    self.ivPlay.image = image;
    self.ivPlay.frame = CGRectMake((kTPScreenWidth-image.size.width)/2, (kTPScreenHeight-image.size.height)/2, image.size.width, image.size.height);
    self.ivPlay.hidden = YES;
    [self.view addSubview:self.ivPlay];
    
    self.bPause = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[ZQTools createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [super viewWillDisappear:animated];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setModel:(ZQPhotoModel *)model {
    _model = model;
    ______WS();
    [ZQPhotoFetcher getVideoWithAssets:self.model.asset completionHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        wSelf.player = [AVPlayer playerWithPlayerItem:playerItem];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] addObserver:wSelf selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:wSelf.player.currentItem];
            [[NSNotificationCenter defaultCenter] addObserver:wSelf selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
            AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:wSelf.player];
            playLayer.frame = wSelf.view.frame;
            [wSelf.view.layer addSublayer:playLayer];
            wSelf.ivPlay.hidden = NO;
            [wSelf.view bringSubviewToFront:wSelf.vBottomBar];
            [wSelf.view bringSubviewToFront:wSelf.ivPlay];
        });
    }];
    
}
- (void)playerItemDidReachEnd:(NSNotification *)note {
    [self pause];
    AVPlayerItem *item = [note object];
    [item seekToTime:kCMTimeZero];
}
- (void)applicationDidEnterBackground:(NSNotification *)note {
    [self pause];
}
- (void)okVideoSelect {
    NSTimeInterval maxDur = ((ZQAlbumNavVC *)self.navigationController).maxVideoDurationInSeconds;
    if (maxDur > 0.01 && self.model.asset.duration > maxDur) {
       
            NSString* message = [NSString stringWithFormat:_LocalizedString(@"VIDEO_CHOICE_LIMIT"), (NSInteger)maxDur/60];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:_LocalizedString(@"OPERATION_OK") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        
    }
    
    [ProgressHUD show];
    
    ______WS();
    
    [ZQPhotoFetcher getPhotoFastWithAssets:self.model.asset photoWidth:kTPScreenWidth completionHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        
        ZQAlbumNavVC *nav = (ZQAlbumNavVC *)wSelf.navigationController;
        wSelf.exportImage = image;//先存小图，再存大图
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nav.updateUIFinishVideoPicking) {
                nav.updateUIFinishVideoPicking(image);
            }
        });
    }];
    
    [ZQPhotoFetcher exportVideoDegradedWithAssets:self.model.asset progress:^(CGFloat progress) {
        //在progressHUD上加一个progress label
        [ProgressHUD sharedInstance].progress = progress;
    } completionHandler:^(AVAsset * _Nullable playerAsset, NSDictionary * _Nullable info, NSURL * _Nullable url) {
        ZQAlbumNavVC *nav = (ZQAlbumNavVC *)wSelf.navigationController;
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD hide];
            [nav dismissViewControllerAnimated:YES completion:^{
                if (nav.didFinishPickingVideoHandle) {
                    nav.didFinishPickingVideoHandle(url, wSelf.exportImage, playerAsset);
                }
            }];
            
        });
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.bPause) {
        [self play];
    }
    else {
        [self pause];
    }
}

- (void)play {
    [self.player play];
    self.bPause = NO;
    [self.navigationController.navigationBar setHidden:YES];
    [self.vBottomBar setHidden:YES];
    self.ivPlay.hidden = YES;
}
- (void)pause {
    [self.player pause];
    self.bPause = YES;
    [self.navigationController.navigationBar setHidden:NO];
    [self.vBottomBar setHidden:NO];
    self.ivPlay.hidden = NO;
}
@end
