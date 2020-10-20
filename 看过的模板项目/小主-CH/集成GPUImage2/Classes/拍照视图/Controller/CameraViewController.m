//
//  CameraViewController.m
//  集成GPUImage2
//
//  Created by 七啸网络 on 2017/8/23.
//  Copyright © 2017年 youbei. All rights reserved.
//

#import "CameraViewController.h"
#import "CamerasManager.h"
#import "CameraViewModel.h"
//音量
#import "MPVolumeObserverPro.h"
//播放系统声音
#import "PlayMusicModel.h"
//弹出框
#import "AnimationView.h"
//魔法师
#import "CartoonView.h"
@interface CameraViewController ()<CameraViewModelDelegate,MPVolumeObserverProtocol,AnimationViewDeledate,UINavigationControllerDelegate>
@property(nonatomic,strong)UIView*picView;
@property(nonatomic,strong)UIImage * photoImage;
@property(nonatomic,strong)UIButton * removeBtn;
// 提示更换角度图片
@property(nonatomic,strong)UIImageView * imageShow;
//打印机动画定时器
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,strong)UIImageView * picone;
@property(nonatomic,strong)UIImageView * pictwo;
@property(nonatomic,strong)UIImageView * backImageView;
//播放音乐
@property(nonatomic,strong)PlayMusicModel * playMusicModel;
//弹出框
@property(nonatomic,strong)AnimationView * animationView;
//面部轮廓
@property(nonatomic,strong)UIImageView * reallyFaceImageView;
//魔法师
@property(nonatomic,strong) CartoonView * cartoonView;

@end

@implementation CameraViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //开启美颜相机
    [self.manager.stillCamera startCameraCapture];
    
    //加载弹出框和人脸模型
    [self viewWillLoadModels];
//    //创建 进行动画 的定时器
//    NSTimer*timer=[NSTimer  scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimerUpdate:) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
//    [timer setFireDate:[NSDate distantFuture]];
//    self.timer=timer;
 

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self.manager.stillCamera stopCameraCapture];
    
    [self.timer invalidate];
    self.timer=nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];


    
    //相机视图
    [self setCameraManager];
    //设置相机子控件
    [self setCameraSubviews];
    //设置音量键拍照
    [self setVolumeBtnTakePhoto];
    //自定义跳转动画
    [self SetCustomJumpAnimation];
}

-(void)dealloc
{
    DLog(@"照相页面释放了");
    @try {
        [self.manager removeObserver:self forKeyPath:@"getfloats"];
        [self.manager removeObserver:self forKeyPath:@"center"];
        
    }
    @catch (NSException *exception) {
    }
    
}

-(PlayMusicModel*)playMusicModel{
    if (_playMusicModel==nil) {
        _playMusicModel=[[PlayMusicModel alloc]init];
    }
    return _playMusicModel;
}

/**相机视图*/
-(void)setCameraManager{


    self.manager = [[CamerasManager alloc] initWithParentView:self.picView];
    
#pragma  mark--人脸检测
    [self.manager addObserver:self forKeyPath:@"getfloats" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.manager addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    

}

/** 人脸检测*/
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    id newName = [self.manager valueForKey:@"getfloats"];
    id center=[self.manager valueForKey:@"center"];
    
    //    NSLog(@"newName-----------%f",[newName floatValue]);
    //150
    if ([newName floatValue]>=MatchW(100)&&[newName floatValue]<=MatchW(350)&&[center CGPointValue].x>MatchW(110)&&[center CGPointValue].x<MatchW(290)&&[center CGPointValue].y>MatchW(230)&&[center CGPointValue].y<MatchW(500)) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //        [self initialize];
                if (self.cameraViewModel.shutterButton.enabled==NO) {
                    [self.cameraViewModel.shutterButton setEnabled:YES];
                    [self.cameraViewModel.shutterButton setBackgroundImage:[UIImage imageNamed:@"icon_camera_seleted"] forState:UIControlStateNormal];
                    self.cameraViewModel.shutterButton.frame=CGRectMake(0, 0, MatchWidth(80), MatchWidth(80));
                    self.cameraViewModel.shutterButton.centerX=self.view.centerX;
                    self.cameraViewModel.shutterButton.centerY=self.cameraViewModel.flashButton.centerY;
                    
                }
                
                
                
            });
        });
        
        
    }else
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //        [self onceToken];
                if (self.cameraViewModel.shutterButton.enabled==YES) {
                    
                    [self.cameraViewModel.shutterButton setEnabled:NO];
                    [self.cameraViewModel.shutterButton setBackgroundImage:[UIImage imageNamed:@"icon_camera_default"] forState:UIControlStateNormal];
                    self.cameraViewModel.shutterButton.frame=CGRectMake(SCREENWIDTH/2-MatchWidth(40)/2, SCREENHEIGHT-38-MatchWidth(40), MatchWidth(40), MatchWidth(40));                    //
                }
                
                
            });
        });
        
    }
}

/**设置相机子控件*/
-(void)setCameraSubviews{
    
    
    self.cameraViewModel=[CameraViewModel shareManagerUI];
    
    
    
    self.cameraViewModel.delegate=self;
    [self.cameraViewModel setViewDelegate:self];
    [self.cameraViewModel  initUI];



}
-(UIView*)picView
{
    if (_picView==nil) {
        _picView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:_picView];
        
    }
    return _picView;
}


#pragma mark--相机子控件代理
//拍照
-(void)didShutterBtnClick{

 [self takeCameraCache];
}
//切换前后镜按钮
-(void)didToggleBtnClick{

    [self.manager addVideoInputFrontCamera];

}
//闪光灯
-(void)didFlashBtnClickWith:(UIButton*)btn{
    
    [self.manager switchFlashModeWithBtn:btn];

}
//取消按钮
-(void)didCancleBtnClick{

#pragma mark--????????
//    self.navigationController.delegate=self;
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark 拍照后的操作
-(void)takeCameraCache
{
    
    WS(weak);
    [self.manager takePhotoWithImageBlock:^(UIImage *originImage, UIImage *ScreenshotsImage) {
        if (originImage&&ScreenshotsImage) {
            [weak.manager.stillCamera stopCameraCapture];
            
            weak.photoImage=ScreenshotsImage;
            
            //点击拍照后，现将图片赋给整个视图大小
            [weak.view addSubview:weak.imageShow];
            [weak.imageShow addSubview:weak.removeBtn];
            weak.imageShow.image=originImage;
            
      
#pragma mark --加载魔法师
            [weak.view addSubview:weak.cartoonView];
            
            [weak.cartoonView insertSubview:weak.imageShow atIndex:3];
            [weak.cartoonView insertSubview:weak.backImageView atIndex:3];
            double floats=originImage.size.width/originImage.size.height;
            
            [weak photoAnimation:floats withImage:ScreenshotsImage];
            
            
        }
        
        
    }];
    
}

-(UIImageView*)backImageView
{
    if (_backImageView==nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  MatchH((MatchH(200)+10)/2+80), MatchW(150), MatchH(200))];
        _backImageView.contentMode=UIViewContentModeScaleAspectFill;
        
        _backImageView.centerX=self.view.centerX;
        
        [self.cartoonView addSubview:_backImageView];
        
    }
    return _backImageView;
}
-(void)photoAnimation:(double)floats withImage:(UIImage*)image
{
    
    //这个是保存上一次请求的图片
    //展示的主题
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSInteger count= [defaults integerForKey:@"themes"];
    [defaults synchronize];
    
    //$$$$$$$$$$$$$$$$$$
    
    CGFloat H=MatchW(150)/floats;
    NSLog(@"%f==%f",H,floats);
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.playMusicModel playSoundEffect:@"Admission.wav"];
        
        self.imageShow.contentMode=UIViewContentModeScaleAspectFill;
        
        self.imageShow.frame = CGRectMake(SCREENWIDTH/2-MatchW(150)/2, SCREENHEIGHT/2-H/2, MatchW(150), H);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.imageShow.frame =CGRectMake(self.view.frame.size.width/2-MatchW(150)/2, MatchH(76), MatchW(150), H);
                
            } completion:^(BOOL finished) {
                
                UIView *mask      = [[UIView alloc] initWithFrame:self.imageShow.bounds];
                self.imageShow.maskView = mask;
                
                UIImageView *picOne = [[UIImageView alloc] initWithFrame:self.imageShow.bounds];
                picOne.backgroundColor=[UIColor whiteColor];
                //    picOne.image        = [UIImage imageNamed:@"mask1"];
                [mask addSubview:picOne];
                self.picone=picOne;
                
                //$$$$$$$$$$$$$$$$$$
                //王松锋这里要改
//                self.backImageView.image    = [UIImage imageNamed:self.imageArray[count-53]];
                
                
                UIView *mask1      = [[UIView alloc] initWithFrame:self.backImageView.bounds];
                self.backImageView.maskView = mask1;
                //$$$$$$$$$$$$$$$$$$
                
                UIImageView *picTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0, H, MatchW(150), H*2)];
                picTwo.backgroundColor=[UIColor whiteColor];
                [mask1 addSubview:picTwo];
                self.pictwo=picTwo;
                
                [self.timer setFireDate:[NSDate distantPast]];
                
                if (image) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
//                        [self postRequestWith:image];
                        
                        
                    });
                    
                }
                
                
                
            }];
        }
    }];
}

#pragma mark 动画视图
-(CartoonView*)cartoonView
{
    if (_cartoonView==nil) {
        _cartoonView=[[CartoonView alloc]initWithFrame:self.view.frame];
        
    }
    return _cartoonView;
}

#pragma mark 拍完照之后的展示图片

-(UIImageView*)imageShow
{
    if (_imageShow==nil) {
        _imageShow=[[UIImageView alloc]initWithFrame:self.view.frame];
        _imageShow.userInteractionEnabled=YES;
        
    }
    return _imageShow;
}


-(void)removePending{
    [_imageShow removeFromSuperview];
    [self.manager.stillCamera startCameraCapture];
}

-(UIButton *)removeBtn{
    if (_removeBtn==nil) {
        
       _removeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _removeBtn.frame=CGRectMake(60, 60, 60, 60);
        [_removeBtn addTarget:self action:@selector(removePending) forControlEvents:UIControlEventTouchUpInside];
        _removeBtn.backgroundColor=[UIColor redColor];

    }

    return _removeBtn;
}


#pragma mark--设置音量键拍照
-(void)setVolumeBtnTakePhoto{

    [MPVolumeObserverPro sharedInstance].delegate = self;
    [[MPVolumeObserverPro sharedInstance]startObserveVolumeChangeEvents];


}
/**点击音量键拍照*/
-(void)volumeButtonCameraClick:(MPVolumeObserverPro *)button{

    if (self.cameraViewModel.shutterButton.enabled==YES) {
        [self takeCameraCache];
        
    }


}

-(void)volumeButtonStarVideoClick:(MPVolumeObserverPro *)button{
    
    DLog(@"开始视频播放");
}

-(void)volumeButtonEndVideoClick:(MPVolumeObserverPro *)button{

    DLog(@"停止视频播放");
}


#pragma mark--弹出框
-(void)viewWillLoadModels{
    
    UIWindow * window=[[UIApplication sharedApplication]keyWindow];
    
    //面部轮廓
    [self.view addSubview:self.reallyFaceImageView];

    //弹出框
    _animationView=[[AnimationView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _animationView.AnimationViewDeledate=self;
    [window addSubview:_animationView];

        
}

/**弹出框消失,，面部轮廓消失*/
-(void)dismissEndCallBack{

    [UIView animateWithDuration:1 animations:^{
        
        _reallyFaceImageView.alpha=0;
    } completion:^(BOOL finished) {
        
        [_reallyFaceImageView removeFromSuperview];
    }];

}

/**面部轮廓*/
-(UIImageView*)reallyFaceImageView{
    if (_reallyFaceImageView==nil) {
        _reallyFaceImageView=[[UIImageView alloc]initWithFrame:CGRectMake(MatchWidth(71), MatchHeight(179), MatchWidth(273), MatchHeight(297))];
        _reallyFaceImageView.image=[UIImage imageNamed:@"面部轮廓"];
    }
    return _reallyFaceImageView;
}

/**定时器实现打印机动画*/
-(void)onTimerUpdate:(NSTimer*)timer
{
    
    [UIView animateWithDuration:0.15f delay:0.f options:0 animations:^{
        
        self.picone.y -= 10;
        self.imageShow.y+=10;
        
        self.pictwo.y-=10;
        self.backImageView.y+=10;
        
    } completion:^(BOOL finished) {
        
        
    }];                //$$$$$$$$$$$$$$$$$$
    [UIView animateWithDuration:1.0f delay:0.f options:0 animations:^{
        
        [self.playMusicModel playSoundEffect:@"transition.wav"];
        
    } completion:^(BOOL finished) {
        
        
    }];
    if (self.imageShow.y>=MatchH(150)) {
        
        [timer setFireDate:[NSDate distantFuture]];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.cameraViewModel shakeAnimationForView:self.backImageView];
        }];
        
    }
}

#pragma mark--自定义的跳转动画

-(void)SetCustomJumpAnimation{

//    self.animate = [[SFTrainsitionAnimate alloc] init];
//    self.animate.duration=2;


}
@end
