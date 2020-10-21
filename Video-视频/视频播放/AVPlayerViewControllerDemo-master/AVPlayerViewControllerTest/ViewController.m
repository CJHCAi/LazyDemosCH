//
//  ViewController.m
//  AVPlayerViewControllerTest
//
//  Created by tanzhiwu on 2018/12/29.
//  Copyright © 2018 tanzhiwu. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>

#import "NSObject+BlockObserver.h"
#import <Aspects/Aspects.h>
#import "UIView+ViewDesc.h"
#import <Masonry/Masonry.h>

@interface ViewController ()
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong)AVPlayerViewController *playerVC;

//增加两个属性先
//记录音量控制的父控件，控制它隐藏显示的 view
@property (nonatomic, weak)UIView *volumeSuperView;
//记录我们 hook 的对象信息
@property (nonatomic, strong)id<AspectToken>hookAVPlaySingleTap;
//增加一个关闭按钮
@property (nonatomic, strong) UIControl *closeControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.videoUrl =  [[NSBundle mainBundle] pathForResource:@"guideMovie1" ofType:@"mov"];
        self.videoUrl = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
        /*
         因为是 http 的链接，所以要去 info.plist里面设置
         App Transport Security Settings
         Allow Arbitrary Loads  = YES
         */
        self.playerVC = [[AVPlayerViewController alloc] init];
        self.playerVC.player = [AVPlayer playerWithURL:[self.videoUrl hasPrefix:@"http"] ? [NSURL URLWithString:self.videoUrl]:[NSURL fileURLWithPath:self.videoUrl]];
        self.playerVC.view.frame = self.view.bounds;
        self.playerVC.showsPlaybackControls = YES;
        //self.playerVC.entersFullScreenWhenPlaybackBegins = YES;//开启这个播放的时候支持（全屏）横竖屏哦
        //self.playerVC.exitsFullScreenWhenPlaybackEnds = YES;//开启这个所有 item 播放完毕可以退出全屏
        [self.view addSubview:self.playerVC.view];
        
        
        //添加监听播放状态
        [self HF_addNotificationForName:AVPlayerItemDidPlayToEndTimeNotification block:^(NSNotification *notification) {
            NSLog(@"我播放结束了！");
    //        [self.navigationController setNavigationBarHidden:NO animated:YES];
        }];
        
        
        Class UIGestureRecognizerTarget = NSClassFromString(@"UIGestureRecognizerTarget");
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
        _hookAVPlaySingleTap = [UIGestureRecognizerTarget aspect_hookSelector:@selector(_sendActionWithGestureRecognizer:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo>info,UIGestureRecognizer *gest){
            if (gest.numberOfTouches == 1) {
                //AVVolumeButtonControl
                if (!self.volumeSuperView) {
                    UIView *view = [gest.view findViewByClassName:@"AVVolumeButtonControl"];
                    if (view) {
                        while (view.superview) {
                            view = view.superview;
                            if ([view isKindOfClass:[NSClassFromString(@"AVTouchIgnoringView") class]]) {
                                self.volumeSuperView = view;
    //                            [view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
                                [view HF_addObserverForKeyPath:@"hidden" block:^(__weak id object, id oldValue, id newValue) {
                                    NSLog(@"newValue ==%@",newValue);
                                    BOOL isHidden = [(NSNumber *)newValue boolValue];
                                    dispatch_async(dispatch_get_main_queue(), ^{
    //                                    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
                                        [self.closeControl setHidden:isHidden];
                                    });
                            
                                }];
                                break;
                            }
                        }
                    }
                }
            }
            
        } error:nil];
    #pragma clang diagnostic pop
        //这里必须监听到准备好开始播放了，才把按钮添加上去（系统控件的懒加载机制，我们才能获取到合适的 view 去添加），不然很突兀！
        [self.playerVC.player HF_addObserverForKeyPath:@"status" block:^(__weak id object, id oldValue, id newValue) {
            AVPlayerStatus status = [newValue integerValue];
            if (status == AVPlayerStatusReadyToPlay) {
                UIView *avTouchIgnoringView = self->_playerVC.view;
                [avTouchIgnoringView addSubview:self.closeControl];
                //这里判断是否刘海屏，不同机型的放置位置不一样！
                BOOL ishairScreen = [self.view isHairScreen];
                CGFloat margin = ishairScreen ?90:69;
                [self.closeControl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(avTouchIgnoringView).offset(-margin);
                    make.top.mas_equalTo(avTouchIgnoringView).offset(ishairScreen ?27:6);
                    make.width.mas_equalTo(60);
                    make.height.mas_equalTo(47);
                }];
                [avTouchIgnoringView setNeedsLayout];
            }
        }];
        
        if (self.playerVC.readyForDisplay) {
            [self.playerVC.player play];
        }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self presentViewController:self.playerVC animated:YES completion:^{
        
    }];
}


//别忘了释放资源
- (void)dealloc
{
    self.playerVC = nil;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.hookAVPlaySingleTap remove];
    
}


- (UIControl *)closeControl
{
    if (!_closeControl) {
        _closeControl = [[UIControl alloc] init];
        [_closeControl addTarget:self action:@selector(dimissSelf) forControlEvents:UIControlEventTouchUpInside];
//        _closeControl.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:0.8];
        _closeControl.backgroundColor = [UIColor orangeColor];
        _closeControl.tintColor = [UIColor colorWithWhite:1 alpha:0.55];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *normalImage = [UIImage imageNamed:@"closeAV.png" inBundle:bundle compatibleWithTraitCollection:nil];
        [_closeControl.layer setContents:(id)normalImage.CGImage];
        _closeControl.layer.contentsGravity = kCAGravityCenter;
        _closeControl.layer.cornerRadius = 17;
        _closeControl.layer.masksToBounds = YES;
    }
    return _closeControl;
    
}

- (void)dimissSelf
{
    if (self.navigationController.viewControllers.count >1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.playerVC.view removeFromSuperview];
    }
    
}


@end
