//
//  CameraViewModel.m
//  EmptyDemo
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 LIZHAO. All rights reserved.
//

#import "CameraViewModel.h"
#import "Masonry.h"

@interface CameraViewModel()

@property(nonatomic,strong)UIImageView * faceImageView;

// 提示更换角度图片
@property(nonatomic,strong)UIImageView * imageShow;

@end
@implementation CameraViewModel

-(void)dealloc{
    DLog(@"相机Model释放了");
}
CameraViewModel * cameraViewModel;
+(CameraViewModel*)shareManagerUI{
    if (cameraViewModel==nil) {
        cameraViewModel=[[CameraViewModel alloc]init];
    }
    return cameraViewModel;
}

- (void)setViewDelegate:(UIViewController *)delegate{
    if (self) {
        self.actionViewController=delegate;
    }
}
#pragma mark 添加控件
-(void)initUI{
    [self.actionViewController.view addSubview:self.shutterButton];
    
    [self.actionViewController.view addSubview:self.toggleButton];
   
    
    [self.actionViewController.view addSubview:self.flashButton];
    
    
    [self.actionViewController.view addSubview:self.cancleButton];
    
    [self.actionViewController.view addSubview:self.faceImageView];
   
}

/**
 *  拍照按钮
 */
-(UIButton*)shutterButton
{
    if (_shutterButton==nil) {
        
        _shutterButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _shutterButton.backgroundColor = [UIColor redColor];
        [_shutterButton setBackgroundImage:[UIImage imageNamed:@"icon_camera_default"] forState:UIControlStateNormal];
        _shutterButton.layer.shadowColor=[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:0.4].CGColor;
        _shutterButton.layer.shadowOffset=CGSizeMake(0, 0);
        _shutterButton.layer.shadowRadius=4;
        [_shutterButton setEnabled:NO];
        _shutterButton.frame=CGRectMake(SCREENWIDTH/2-MatchWidth(40)/2, SCREENHEIGHT-38-MatchWidth(40), MatchWidth(40), MatchWidth(40));
        [_shutterButton addTarget:self action:@selector(shutterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _shutterButton;
}
-(void)shutterBtnClick{
    if ([self.delegate respondsToSelector:@selector(didShutterBtnClick)]) {
        [self.delegate didShutterBtnClick];
    }

}
/**
 *  切换前后镜按钮
 */
-(UIButton*)toggleButton{
    if (_toggleButton==nil) {
        _toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toggleButton.backgroundColor = [UIColor clearColor];
        [_toggleButton setBackgroundImage:[UIImage imageNamed:@"icon_Reverse"] forState:UIControlStateNormal];
        _toggleButton.layer.shadowColor=[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:0.4].CGColor;
        _toggleButton.layer.shadowOffset=CGSizeMake(0, 0);
        _toggleButton.layer.shadowRadius=4;
        
        _toggleButton.frame=CGRectMake(SCREENWIDTH-34-30, self.shutterButton.center.y-38/2, 34, 38);
        [_toggleButton addTarget:self action:@selector(toggleBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _toggleButton;
}
-(void)toggleBtnClick{
    if ([self.delegate respondsToSelector:@selector(didToggleBtnClick)]) {
        [self.delegate didToggleBtnClick];
    }
}
/**
 *  切换闪光灯按钮
 */
-(UIButton*)flashButton{
    if (_flashButton==nil) {
        //  闪光灯按钮
        _flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _flashButton.backgroundColor = [UIColor clearColor];
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"icon_flashlight"] forState:UIControlStateNormal];
        _flashButton.layer.shadowColor=[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:0.4].CGColor;
        _flashButton.layer.shadowOffset=CGSizeMake(0, 0);
        _flashButton.layer.shadowRadius=4;
       
        _flashButton.frame=CGRectMake(30, self.shutterButton.center.y-34/2, 35, 34);
        [_flashButton addTarget:self action:@selector(flashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
       }
    return _flashButton;
}
-(void)flashBtnClick:(UIButton*)btn{
    if ([self.delegate respondsToSelector:@selector(didFlashBtnClickWith:)]) {
        [self.delegate didFlashBtnClickWith:btn];
    }
}
/**
 *  取消按钮
 */
-(UIButton*)cancleButton{
    if (_cancleButton==nil) {
        //取消按钮
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.backgroundColor = [UIColor clearColor];
        [_cancleButton setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        _cancleButton.layer.shadowColor=[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:0.4].CGColor;
        _cancleButton.layer.shadowOffset=CGSizeMake(0, 0);
        _cancleButton.layer.shadowRadius=4;
        
        self.cancleButton.frame=CGRectMake(SCREENWIDTH-18-30, 20, 30, 30);
         [_cancleButton addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancleButton;
}
-(void)cancleBtnClick{
    if ([self.delegate respondsToSelector:@selector(didCancleBtnClick)]) {
        [self.delegate didCancleBtnClick];
    }

}
-(UIImageView*)faceImageView
{
    if (_faceImageView==nil) {
        //加一个人脸框。
        _faceImageView=[[UIImageView alloc]initWithFrame:CGRectMake(MatchWidth(102), MatchHeight(194), MatchWidth(211), MatchHeight(275.8))];
        _faceImageView.image=[UIImage imageNamed:@"面部虚线"];
    }
    return _faceImageView;
}

-(void)AlertView:(NSString*)text
{
    // 声明一个 UILabel 对象
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH*0.5-MatchWidth(300)/2, MatchHeight(300), MatchWidth(300), 30)];
    // 设置提示内容
    [tipLabel setText:text];
    tipLabel.backgroundColor = [UIColor blackColor];
    tipLabel.layer.cornerRadius = 5;
    tipLabel.layer.masksToBounds = YES;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    [self.actionViewController.view addSubview:tipLabel];
    // 设置时间和动画效果
    [UIView animateWithDuration:4.0 animations:^{
        tipLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 动画完毕从父视图移除
        [tipLabel removeFromSuperview];
    }];
}

/**
 *  抖动效果
 *
 *  @param view 要抖动的view
 */
- (void)shakeAnimationForView:(UIView *) view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x+2, position.y);
    CGPoint y = CGPointMake(position.x - 2, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:MAXFLOAT];
    [viewLayer addAnimation:animation forKey:nil];
}

@end
