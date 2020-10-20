//
//  CartoonView.m
//  CameraDemo
//
//  Created by apple on 2017/6/28.
//  Copyright © 2017年 yangchao. All rights reserved.
//

#import "CartoonView.h"

@interface CartoonView()
@property(nonatomic,strong)UIImageView * bgImageView;
@property(nonatomic,strong)UIImageView * circleImageView;
@property(nonatomic,strong)UIImageView * printerImageView;
@property(nonatomic,strong)UIImageView * starImageView1;
@property(nonatomic,strong)UIImageView * starImageView2;
@property(nonatomic,strong)UIImageView * starImageView3;

@end
@implementation CartoonView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        [self addSubview:self.bgImageView];
        [self addSubview:self.circleImageView];
        [self addSubview:self.printerImageView];
        [self addSubview:self.photoImageView];
        [self addSubview:self.enchanterImageView];
        [self addSubview:self.starImageView1];
        [self addSubview:self.starImageView2];
        [self addSubview:self.starImageView3];
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _printerImageView.frame=CGRectMake(0, 0, MatchWidth(296), MatchWidth(257));
            _printerImageView.center=self.center;
            
            CGFloat H=MatchHeight(210);
            
            _enchanterImageView.frame=CGRectMake(MatchWidth(134), H, MatchWidth(148), MatchHeight(183));
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    return self;
}

-(UIImageView*)bgImageView
{
    if (_bgImageView==nil) {
        _bgImageView=[[UIImageView alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bg_wait" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        _bgImageView.image=image;
        _bgImageView.frame=self.bounds;
    }
    return _bgImageView;
}

-(UIImageView*)circleImageView
{
    if (_circleImageView==nil) {
        _circleImageView=[[UIImageView alloc]init];
        CGFloat W=MatchWidth(354);
        _circleImageView.frame=CGRectMake(0, 0, W, W);
        _circleImageView.center=self.center;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bg" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        _circleImageView.image=image;
    }
    return _circleImageView;
}
//打印机
-(UIImageView*)printerImageView
{
    if (_printerImageView==nil) {
        _printerImageView=[[UIImageView alloc]init];
        _printerImageView.frame=CGRectMake(-self.frame.size.width/2, self.frame.size.height/2-MatchWidth(257)/2, MatchWidth(296), MatchWidth(257));
        NSString *path = [[NSBundle mainBundle] pathForResource:@"img_printer" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        _printerImageView.image=image;
    }
    return _printerImageView;
}

//魔法师
-(UIImageView*)enchanterImageView
{
    if (_enchanterImageView==nil) {
        NSArray * myImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"enchanter_default"],[UIImage imageNamed:@"enchanter_handsup"], nil];
        _enchanterImageView=[[UIImageView alloc]init];
        CGFloat H=MatchHeight(210);
        _enchanterImageView.frame=CGRectMake(-MatchWidth(134), H, MatchWidth(148), MatchHeight(183));
        _enchanterImageView.animationImages=myImages;
        _enchanterImageView.animationDuration=1;
        _enchanterImageView.animationRepeatCount=0;
        [_enchanterImageView startAnimating];
        
    }
    return _enchanterImageView;
}
-(UIImageView*)starImageView1
{
    if (_starImageView1==nil) {
        _starImageView1=[[UIImageView alloc]init];
        _starImageView1.frame=CGRectMake(MatchWidth(35), MatchHeight(215), MatchWidth(303), MatchHeight(119));
        _starImageView1.image=[UIImage imageNamed:@"biling1"];
        [_starImageView1.layer addAnimation:[self opacityForever_Animation:0.5] forKey:nil];
        
    }
    return _starImageView1;
}
-(UIImageView*)starImageView2
{
    if (_starImageView2==nil) {
        _starImageView2=[[UIImageView alloc]init];
        _starImageView2.frame=CGRectMake(MatchWidth(70), MatchHeight(218), MatchWidth(320), MatchHeight(70));
        _starImageView2.image=[UIImage imageNamed:@"biling2"];
        
        WS(weakSelf);
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [_starImageView2.layer addAnimation:[weakSelf opacityForever_Animation:0.5] forKey:nil];
            
        });
        
        
    }
    return _starImageView2;
}
-(UIImageView*)starImageView3
{
    if (_starImageView3==nil) {
        _starImageView3=[[UIImageView alloc]init];
        _starImageView3.frame=CGRectMake(MatchWidth(38), MatchHeight(260), MatchWidth(314), MatchHeight(41));
        _starImageView3.image=[UIImage imageNamed:@"biling3"];
        
        WS(weakSelf);
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [_starImageView3.layer addAnimation:[weakSelf opacityForever_Animation:0.5] forKey:nil];
            
        });
    }
    return _starImageView3;
}


#pragma mark === 永久闪烁的动画 ======
-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.2f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //没有的话是均匀的动画。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}


//照片
-(UIImageView*)photoImageView
{
    if (_photoImageView==nil) {
        _photoImageView=[[UIImageView alloc]init];
        _photoImageView.frame=self.frame;
        
    }
    return _photoImageView;
}

//照片弹簧动画
-(void)photoAnimation
{
    //    CGRectMake(k_SF_SCREEN_WIDTH/2-75, 50, 150, 150*(4/3.0))
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.photoImageView.frame = CGRectMake(SCREENWIDTH/2-75, SCREENHEIGHT/2-150*(4/3.0)/2, 150, 150*(4/3.0));
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.photoImageView.frame =CGRectMake(SCREENWIDTH/2-75, 50, 150, 150*(4/3.0));
                
            } completion:^(BOOL finished) {
                
                
                
            }];
        }
    }];
}



@end
