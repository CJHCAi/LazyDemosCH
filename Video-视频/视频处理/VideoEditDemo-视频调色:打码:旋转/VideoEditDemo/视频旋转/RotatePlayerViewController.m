//  RotatePlayerViewController.m
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/2/24.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import "RotatePlayerViewController.h"
#import "Masonry.h"
#import "NHPlayerView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SVProgressHUD.h"
#import <CoreImage/CoreImage.h>
#import <Accelerate/Accelerate.h>
#import "VideoRotate.h"


//获取导航栏+状态栏的高度
#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height


#define weakSelf(type)  __weak typeof(type) weak##type = type;


@interface RotatePlayerViewController (){
    int frameNum;
    NSTimer *timeOutTimer;
    NSArray *rotateButtonArray;
    VideoRotateEnum videoRotateEnum;
    VideoRotateEnum selectedRotateEnum;
    CGFloat offsetTransform;
    CGFloat time;
}


@property (strong,nonatomic)UIBarButtonItem *rightItem;
@property (strong,nonatomic)NHPlayerView *ContentView;
@property (strong,nonatomic)UIView *actionView;
@property (strong,nonatomic)UIView *clipView;
@property (strong,nonatomic)UIView *editActionView;


@property (strong,nonatomic)UIButton *rotate0Button;
@property (strong,nonatomic)UIButton *rotate90Button;
@property (strong,nonatomic)UIButton *rotate180Button;
@property (strong,nonatomic)UIButton *rotate270Button;

@property (strong,nonatomic)VideoRotate *videoRotate;

@property (strong,nonatomic)NSTimer *exportTimer;

@property (strong,nonatomic)NSTimer *showTimer;

@end

@implementation RotatePlayerViewController


-(VideoRotate *)videoRotate{
    if (!_videoRotate) {
        _videoRotate = [[VideoRotate alloc]init];
    }
    return _videoRotate;
}



-(UIView *)actionView{
    if (!_actionView) {
        _actionView = [[UIView alloc]init];
        [_actionView setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1.0]];
    }
    return _actionView;
}

-(UIView *)editActionView{
    if (!_editActionView) {
        _editActionView = [[UIView alloc]init];
    }
    return _editActionView;
}


-(NHPlayerView *)ContentView{
    if (!_ContentView) {
        _ContentView = [[NHPlayerView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, [UIScreen mainScreen].bounds.size.width, ((self.view.frame.size.height-getRectNavAndStatusHight)*2/3))];
        _ContentView.backgroundColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:1.0];
        
    }
    return _ContentView;
}


-(UIView *)clipView{
    if (!_clipView) {
        _clipView = [[UIView alloc]init];
        _clipView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:43.0f/255.0f blue:33.0f/255.0f alpha:0.6];
    }
    return _clipView;
}

-(UIButton *)rotate0Button{
    if (!_rotate0Button) {
        _rotate0Button = [[UIButton alloc]init];
        [_rotate0Button setTitle:@"0度" forState:UIControlStateNormal];
        _rotate0Button.layer.masksToBounds = YES;
        [_rotate0Button.layer setCornerRadius:27.0f];
        [_rotate0Button setBackgroundColor:[UIColor colorWithRed:65.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:1.0f]];
        [_rotate0Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rotate0Button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_rotate0Button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_rotate0Button addTarget:self action:@selector(touchRotate0Button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotate0Button;
}


-(UIButton *)rotate90Button{
    if (!_rotate90Button) {
        _rotate90Button = [[UIButton alloc]init];
        [_rotate90Button setTitle:@"90度" forState:UIControlStateNormal];
        _rotate90Button.layer.masksToBounds = YES;
        [_rotate90Button.layer setCornerRadius:27.0f];
        [_rotate90Button setBackgroundColor:[UIColor colorWithRed:65.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:1.0f]];
        [_rotate90Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rotate90Button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_rotate90Button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_rotate90Button addTarget:self action:@selector(touchRotate90Button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotate90Button;
}


-(UIButton *)rotate180Button{
    if (!_rotate180Button) {
        _rotate180Button = [[UIButton alloc]init];
        [_rotate180Button setTitle:@"180度" forState:UIControlStateNormal];
        _rotate180Button.layer.masksToBounds = YES;
        [_rotate180Button.layer setCornerRadius:27.0f];
        [_rotate180Button setBackgroundColor:[UIColor colorWithRed:65.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:1.0f]];
        [_rotate180Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rotate180Button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_rotate180Button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_rotate180Button addTarget:self action:@selector(touchRotate180Button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotate180Button;
}


-(UIButton *)rotate270Button{
    if (!_rotate270Button) {
        _rotate270Button = [[UIButton alloc]init];
        [_rotate270Button setTitle:@"270度" forState:UIControlStateNormal];
        _rotate270Button.layer.masksToBounds = YES;
        [_rotate270Button.layer setCornerRadius:27.0f];
        [_rotate270Button setBackgroundColor:[UIColor colorWithRed:65.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:1.0f]];
        [_rotate270Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rotate270Button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [_rotate270Button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_rotate270Button addTarget:self action:@selector(touchRotate270Button:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotate270Button;
}


-(void)UIAutoLayout{
    CGFloat PlayHeight = self.view.frame.size.height-getRectNavAndStatusHight;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:193.0/255.0 blue:7.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightButton setTitle:@"导出" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(importMovie) forControlEvents:UIControlEventTouchUpInside];
    _rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:_rightItem];
    
    // NSLog(@"NavgationHeight = %f",getRectNavAndStatusHight);
    
    [self.view addSubview:self.ContentView];
    [self.ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(getRectNavAndStatusHight);
        make.left.right.mas_offset(0);
        make.height.mas_offset(PlayHeight*2/3);
    }];
    
    [self.view setUserInteractionEnabled:YES];
    [self.actionView setUserInteractionEnabled:YES];
    [self.view addSubview:self.actionView];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ContentView.mas_bottom).offset(0);
        make.left.right.bottom.mas_offset(0);
    }];
    
    CGFloat actionTop = PlayHeight - PlayHeight*2/3;
    [self.actionView addSubview:self.editActionView];
    [self.editActionView setUserInteractionEnabled:YES];
    [self.editActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.actionView);
        make.top.mas_offset(actionTop - actionTop*3/4);
        make.height.mas_offset(80);
        make.width.mas_offset(self.view.frame.size.width * 0.8);
    }];

    [self.editActionView addSubview:self.rotate90Button];
    [self.rotate90Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.editActionView).mas_offset(-27-10);
        make.top.mas_offset(0);
        make.width.height.mas_offset(54);
    }];
    
    [self.editActionView addSubview:self.rotate180Button];
    [self.rotate180Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(self.rotate90Button.mas_right).offset(20);
        make.width.height.mas_offset(54);
    }];
    
    [self.editActionView addSubview:self.rotate270Button];
    [self.rotate270Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.equalTo(self.rotate180Button.mas_right).offset(20);
        make.width.height.mas_offset(54);
    }];
    
    [self.editActionView addSubview:self.rotate0Button];
    [self.rotate0Button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.right.equalTo(self.rotate90Button.mas_left).offset(-20);
        make.width.height.mas_offset(54);
    }];
    
    rotateButtonArray = [NSArray arrayWithObjects:self.rotate0Button,self.rotate90Button,self.rotate180Button,self.rotate270Button,nil];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏18号白色字体加粗。
    [self.navigationItem setTitle:@"视频旋转"];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.view setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1.0]];
    
    [self UIAutoLayout];
    
    //  NSURL *videoPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test1" ofType:@"mp4"]];
    //  _playUrl = videoPath;
    // 设置播放链接
    [self.ContentView setPlayerURLStr:_playUrl.absoluteString isEdit:NO];
  //  self.ContentView.playerURLStr = _playUrl.absoluteString;
 
    
    AVURLAsset * asset = [AVURLAsset assetWithURL:_playUrl];

    videoRotateEnum = [self degressFromVideoFileWithURL:asset];
    
    [self showVideoDefaultRotate:videoRotateEnum];
    
    [self.ContentView playerPlay];
    //监听挂起时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}



#pragma mark ----------------------------滑动手势返回处理-------------------------
- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    [_ContentView stopPlayer];
}
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        NSLog(@"页面pop成功了");
    }
}



-(void)EnterBackgroundNotification{

}

-(void)WillEnterForegroundNotification{

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


-(void)showTouchRotateButton:(UIButton *)touchButton{
    for (UIButton *button in rotateButtonArray) {
        if (button == touchButton) {
            [button setEnabled:NO];
            [button setBackgroundColor:[UIColor whiteColor]];
        }else{
            [button setEnabled:YES];
            [button setBackgroundColor:[UIColor colorWithRed:65.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:1.0f]];
        }
    }
}

-(void)showVideoDefaultRotate:(VideoRotateEnum)rotate{
    switch (rotate) {
        case VideoRotate0:
            [_rotate0Button setEnabled:NO];
            [_rotate0Button setBackgroundColor:[UIColor whiteColor]];
            break;
        case VideoRotate90:
            [_rotate90Button setEnabled:NO];
            [_rotate90Button setBackgroundColor:[UIColor whiteColor]];
            break;
        case VideoRotate180:
            [_rotate180Button setEnabled:NO];
            [_rotate180Button setBackgroundColor:[UIColor whiteColor]];
            break;
        case VideoRotate270:
            [_rotate270Button setEnabled:NO];
            [_rotate270Button setBackgroundColor:[UIColor whiteColor]];
            break;
        default:
            [_rotate0Button setEnabled:NO];
            [_rotate0Button setBackgroundColor:[UIColor whiteColor]];
            break;
    }
    
}




-(void)touchRotate0Button:(id)sender{
    UIButton *rotate0Button = (UIButton *)sender;
    [self showTouchRotateButton:rotate0Button];
    __weak RotatePlayerViewController *weakself = self;
    selectedRotateEnum = VideoRotate0;
    [self.videoRotate videoChangeRotateWithAsset:[AVAsset assetWithURL:_playUrl] Rotate:VideoRotate0 completion:^(CGAffineTransform transform) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGAffineTransform mtansform = CGAffineTransformRotate(transform, -offsetTransform);
            [UIView animateWithDuration:1.0f animations:^{
                
                [weakself.ContentView.playerLayer setAffineTransform:mtansform];
            } completion:^(BOOL finished) {
                // [self.ContentView playerReplace:playerItem];
            }];
        });
        [weakself.showTimer invalidate];
       // weakself.showTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:weakself selector:@selector(reloadPlayer) userInfo:nil repeats:NO];
    }];
}


-(void)touchRotate90Button:(id)sender{
    UIButton *rotate90Button = (UIButton *)sender;
    [self showTouchRotateButton:rotate90Button];
    __weak RotatePlayerViewController *weakself = self;
    selectedRotateEnum = VideoRotate90;
    [self.videoRotate videoChangeRotateWithAsset:[AVAsset assetWithURL:_playUrl] Rotate:VideoRotate90 completion:^(CGAffineTransform transform) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0f animations:^{
                CGAffineTransform mtansform = CGAffineTransformRotate(transform, -offsetTransform);
                [weakself.ContentView.playerLayer setAffineTransform:mtansform];
            } completion:^(BOOL finished) {
                // [self.ContentView playerReplace:playerItem];
            }];
        });
        [weakself.showTimer invalidate];
    }];
}


-(void)touchRotate180Button:(id)sender{
    UIButton *rotate180Button = (UIButton *)sender;
    [self showTouchRotateButton:rotate180Button];
    __weak RotatePlayerViewController *weakself = self;
    selectedRotateEnum = VideoRotate180;
    [self.videoRotate videoChangeRotateWithAsset:[AVAsset assetWithURL:_playUrl] Rotate:VideoRotate180 completion:^(CGAffineTransform transform) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0f animations:^{
                CGAffineTransform mtansform = CGAffineTransformRotate(transform, -offsetTransform);
                [weakself.ContentView.playerLayer setAffineTransform:mtansform];
            } completion:^(BOOL finished) {
                // [self.ContentView playerReplace:playerItem];
            }];
        });
        [weakself.showTimer invalidate];
    }];
}

-(void)touchRotate270Button:(id)sender{
    UIButton *rotate270Button = (UIButton *)sender;
    [self showTouchRotateButton:rotate270Button];

    __weak RotatePlayerViewController *weakself = self;
    selectedRotateEnum = VideoRotate270;
    [self.videoRotate videoChangeRotateWithAsset:[AVAsset assetWithURL:_playUrl] Rotate:VideoRotate270 completion:^(CGAffineTransform transform) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0f animations:^{
                CGAffineTransform mtansform = CGAffineTransformRotate(transform, -offsetTransform);
                [weakself.ContentView.playerLayer setAffineTransform:mtansform];
            } completion:^(BOOL finished) {
                // [self.ContentView playerReplace:playerItem];
            }];
        });
        [weakself.showTimer invalidate];
    }];
}




-(VideoRotateEnum)degressFromVideoFileWithURL:(AVAsset *)asset
{
    VideoRotateEnum degress = VideoRotate0;
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            offsetTransform = M_PI_2;
            degress = VideoRotate90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            offsetTransform = M_PI_2*3;
            degress = VideoRotate270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            offsetTransform = 0;
            degress = VideoRotate0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            offsetTransform = 180;
            degress = VideoRotate180;
        }
    }
    
    return degress;
}

-(void)updateExportProgress{
    if (self.videoRotate.exportSession) {
        [SVProgressHUD showProgress:self.videoRotate.exportSession.progress status:@"正在导出视频..."];
        if (self.videoRotate.exportSession.progress >= 1.0f) {
            [self.exportTimer invalidate];
        }
    }
}


-(void)importMovie{

    // If Add watermark has been applied to the composition, create a video composition animation tool for export
    weakSelf(self);
    if(self.videoRotate.mutableVideoComposition) {
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = CGRectMake(0, 0, self.videoRotate.mutableVideoComposition.renderSize.width, self.videoRotate.mutableVideoComposition.renderSize.height);
        videoLayer.frame = CGRectMake(0, 0, self.videoRotate.mutableVideoComposition.renderSize.width, self.videoRotate.mutableVideoComposition.renderSize.height);
        [parentLayer addSublayer:videoLayer];
        self.videoRotate.mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showProgress:0.0f status:@"正在导出视频..."];
        [self.exportTimer invalidate];
        self.exportTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateExportProgress) userInfo:nil repeats:YES];
        
        
        [self.videoRotate exportWithAsset:[AVAsset assetWithURL:_playUrl] completion:^(NSError *error) {
            if (!error) {
                
                [weakself.exportTimer invalidate];
                [SVProgressHUD showProgress:1.0f status:@"正在导出视频..."];
                [SVProgressHUD showSuccessWithStatus:@"视频已保存到相册" hidewithInterVal:1.0f];
            }else{
                [weakself.exportTimer invalidate];
                [SVProgressHUD showErrorWithStatus:@"视频导出失败" hideInterVal:1.0f];
            }
        }];

    }else{
        weakSelf(self);
        
        [self.videoRotate videoChangeRotateWithAsset:[AVAsset assetWithURL:_playUrl] Rotate:videoRotateEnum completion:^(CGAffineTransform transform) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
                [SVProgressHUD showProgress:0.0f status:@"正在导出视频..."];
                [weakself.exportTimer invalidate];
                weakself.exportTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:weakself selector:@selector(updateExportProgress) userInfo:nil repeats:YES];
                [weakself.videoRotate exportWithAsset:[AVAsset assetWithURL:weakself.playUrl] completion:^(NSError *error) {
                    if (!error) {
                        [weakself.exportTimer invalidate];
                        [SVProgressHUD showProgress:1.0f status:@"正在导出视频..."];
                        [SVProgressHUD showSuccessWithStatus:@"视频已保存到相册" hidewithInterVal:1.0f];
                    }else{
                        [weakself.exportTimer invalidate];
                        [SVProgressHUD showErrorWithStatus:@"视频导出失败" hideInterVal:1.0f];
                    }
                }];
            });
        }];
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_exportTimer invalidate];
    [_ContentView playerPause];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"player dealloc");
}

@end
