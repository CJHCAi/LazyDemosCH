//
//  WelcomeViewController.m
//  Welcome
//
//  Created by Miaolegemi on 15/12/18.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIViewController+SmartScale.h"//屏幕适配

@interface WelcomeViewController ()

//创建存放所有文字label的数组
@property(nonatomic,retain)NSMutableArray *labelArray;

@property(nonatomic,retain)UILabel *renLabel;
@property(nonatomic,retain)UILabel *shengLabel;
@property(nonatomic,retain)UILabel *ruoLabel;
@property(nonatomic,retain)UILabel *zhiLabel;
@property(nonatomic,retain)UILabel *ruLabel;
@property(nonatomic,retain)UILabel *chuLabel;
@property(nonatomic,retain)UILabel *jian0Label;

@property(nonatomic,retain)UILabel *henLabel;
@property(nonatomic,retain)UILabel *gaoLabel;
@property(nonatomic,retain)UILabel *xingLabel;
@property(nonatomic,retain)UILabel *yuLabel;
@property(nonatomic,retain)UILabel *jianLabel;
@property(nonatomic,retain)UILabel *ni2Label;
@property(nonatomic,retain)UILabel *zaiLabel;
@property(nonatomic,retain)UILabel *zheLabel;
@property(nonatomic,retain)UILabel *meiLabel;
@property(nonatomic,retain)UILabel *hao2Label;
@property(nonatomic,retain)UILabel *deLabel;
@property(nonatomic,retain)UILabel *shiLabel;
@property(nonatomic,retain)UILabel *guangLabel;
@property(nonatomic,retain)UILabel *LiLabel;
//RGB
@property(nonatomic,assign)NSInteger r;
@property(nonatomic,assign)NSInteger g;
@property(nonatomic,assign)NSInteger b;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //用for循环创建所有文字label控件
    //NSArray *titles = @[@"人",@"生",@"若",@"只",@"如",@"初",@"见"];
    //NSArray *array = [NSArray arrayWithObjects:@"1",@"-1", nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //控件初始化
    self.renLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%780, arc4random()%400, 30, 30)];
    _renLabel.text = @"人";
    _renLabel.textColor = [UIColor grayColor];
    //_renLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _renLabel.textAlignment = NSTextAlignmentCenter;
    _renLabel.alpha = 0;
    _renLabel.font = [UIFont systemFontOfSize:20];
    self.shengLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%500, arc4random()%800, 30, 30)];
    _shengLabel.text = @"生";
    _shengLabel.textColor = [UIColor grayColor];
    //_shengLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _shengLabel.textAlignment = NSTextAlignmentCenter;
    _shengLabel.alpha = 0;
    _shengLabel.font = [UIFont systemFontOfSize:20];
    self.ruoLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%450, arc4random()%820, 30, 30)];
    _ruoLabel.alpha = 0;
    _ruoLabel.text = @"若";
    _ruoLabel.textColor = [UIColor grayColor];
    //_ruoLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _ruoLabel.textAlignment = NSTextAlignmentCenter;
    _ruoLabel.font = [UIFont systemFontOfSize:20];
    self.zhiLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%520, arc4random()%852, 30, 30)];
    _zhiLabel.alpha = 0;
    _zhiLabel.text = @"只";
    _zhiLabel.textColor = [UIColor grayColor];
    //_zhiLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _zhiLabel.textAlignment = NSTextAlignmentCenter;
    _zhiLabel.font = [UIFont systemFontOfSize:20];
    self.ruLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%521, arc4random()%845, 30, 30)];
    _ruLabel.text = @"如";
    _ruLabel.textColor = [UIColor grayColor];
    //_ruLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    _ruLabel.textAlignment = NSTextAlignmentCenter;
    _ruLabel.alpha = 0;
    _ruLabel.font = [UIFont systemFontOfSize:20];
    self.chuLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%675, arc4random()%854, 30, 30)];
    _chuLabel.text = @"初";
    _chuLabel.textColor = [UIColor grayColor];
    _chuLabel.textAlignment = NSTextAlignmentCenter;
    _chuLabel.font = [UIFont systemFontOfSize:20];
    _chuLabel.alpha = 0;
    self.jian0Label = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%854, arc4random()%892, 30, 30)];
    _jian0Label.text = @"见";
    _jian0Label.textColor = [UIColor grayColor];
    _jian0Label.textAlignment = NSTextAlignmentCenter;
    _jian0Label.font = [UIFont systemFontOfSize:20];
    _jian0Label.alpha = 0;
    
    [self.view addSubview:_renLabel];
    [self.view addSubview:_shengLabel];
    [self.view addSubview:_ruoLabel];
    [self.view addSubview:_zhiLabel];
    [self.view addSubview:_ruLabel];
    [self.view addSubview:_chuLabel];
    [self.view addSubview:_jian0Label];
    
    self.henLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%500+500, arc4random()%800, 30, 30)];
    _henLabel.text = @"很";
    _henLabel.textAlignment = NSTextAlignmentCenter;
    _henLabel.font = [UIFont systemFontOfSize:20];
    _henLabel.alpha = 0;
    _henLabel.textColor = [UIColor grayColor];
    self.gaoLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%510, arc4random()%900, 30, 30)];
    _gaoLabel.text = @"高";
    _gaoLabel.textAlignment = NSTextAlignmentCenter;
    _gaoLabel.font = [UIFont systemFontOfSize:20];
    _gaoLabel.alpha = 0;
    _gaoLabel.textColor = [UIColor grayColor];
    self.xingLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%600, arc4random()%850, 30, 30)];
    _xingLabel.text = @"兴";
    _xingLabel.textAlignment = NSTextAlignmentCenter;
    _xingLabel.font = [UIFont systemFontOfSize:20];
    _xingLabel.alpha = 0;
    _xingLabel.textColor = [UIColor grayColor];
    self.yuLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%450, arc4random()%860, 40, 40)];
    _yuLabel.text = @"遇";
    _yuLabel.textAlignment = NSTextAlignmentCenter;
    _yuLabel.font = [UIFont boldSystemFontOfSize:30];
    _yuLabel.alpha = 0;
    self.jianLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%550, arc4random()%1000, 40, 40)];
    _jianLabel.text = @"见";
    _jianLabel.textAlignment = NSTextAlignmentCenter;
    _jianLabel.font = [UIFont boldSystemFontOfSize:30];
    _jianLabel.alpha = 0;
    self.ni2Label = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%600, arc4random()%925, 30, 30)];
    _ni2Label.text = @"你";
    _ni2Label.textAlignment = NSTextAlignmentCenter;
    _ni2Label.font = [UIFont systemFontOfSize:20];
    _ni2Label.alpha = 0;
    _ni2Label.textColor = [UIColor grayColor];
    self.zaiLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%700, arc4random()%700, 30, 30)];
    _zaiLabel.text = @"在";
    _zaiLabel.textAlignment = NSTextAlignmentCenter;
    _zaiLabel.font = [UIFont systemFontOfSize:20];
    _zaiLabel.alpha = 0;
    _zaiLabel.textColor = [UIColor grayColor];
    self.zheLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%543, arc4random()%777, 30, 30)];
    _zheLabel.text = @"这";
    _zheLabel.textAlignment = NSTextAlignmentCenter;
    _zheLabel.font = [UIFont systemFontOfSize:20];
    _zheLabel.alpha = 0;
    _zheLabel.textColor = [UIColor grayColor];
    self.meiLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%651, arc4random()%689, 40, 40)];
    _meiLabel.text = @"美";
    _meiLabel.textAlignment = NSTextAlignmentCenter;
    _meiLabel.font = [UIFont boldSystemFontOfSize:30];
    _meiLabel.alpha = 0;
    self.hao2Label = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%788, arc4random()%142, 40, 40)];
    _hao2Label.text = @"好";
    _hao2Label.textAlignment = NSTextAlignmentCenter;
    _hao2Label.font = [UIFont boldSystemFontOfSize:30];
    _hao2Label.alpha = 0;
    self.deLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%651, arc4random()%985, 30, 30)];
    _deLabel.textAlignment = NSTextAlignmentCenter;
    _deLabel.font = [UIFont systemFontOfSize:20];
    _deLabel.text = @"的";
    _deLabel.alpha = 0;
    _deLabel.textColor = [UIColor grayColor];
    self.shiLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%556, arc4random()%987, 40, 40)];
    _shiLabel.text = @"时";
    _shiLabel.textAlignment = NSTextAlignmentCenter;
    _shiLabel.font = [UIFont boldSystemFontOfSize:30];
    _shiLabel.alpha = 0;
    self.guangLabel = [[UILabel alloc]initWithFrame:CGRectMake1(arc4random()%845, arc4random()%1520, 40, 40)];
    _guangLabel.text = @"光";
    _guangLabel.textAlignment = NSTextAlignmentCenter;
    _guangLabel.font = [UIFont boldSystemFontOfSize:30];
    _guangLabel.alpha = 0;
    self.LiLabel = [[UILabel alloc] initWithFrame:CGRectMake1(arc4random()%475, arc4random()%999, 30, 30)];
    _LiLabel.text = @"里";
    _LiLabel.textAlignment = NSTextAlignmentCenter;
    _LiLabel.font = [UIFont systemFontOfSize:20];
    _LiLabel.alpha = 0;
    _LiLabel.textColor = [UIColor grayColor];
    
    
    [self.view addSubview:_henLabel];
    [self.view addSubview:_gaoLabel];
    [self.view addSubview:_xingLabel];
    [self.view addSubview:_yuLabel];
    [self.view addSubview:_jianLabel];
    [self.view addSubview:_ni2Label];
    [self.view addSubview:_zaiLabel];
    [self.view addSubview:_zheLabel];
    [self.view addSubview:_meiLabel];
    [self.view addSubview:_hao2Label];
    [self.view addSubview:_deLabel];
    [self.view addSubview:_shiLabel];
    [self.view addSubview:_guangLabel];
    [self.view addSubview:_LiLabel];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    //出现
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.renLabel.frame = CGRectMake1((WIDTH-30)/2, (HEIGHT-30*7-10*6)/2, 30, 30);
        [_renLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:2.2 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.shengLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.renLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
        [_shengLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:2.4 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.ruoLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.shengLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
        [_ruoLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];

    [UIView animateWithDuration:2.6 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.zhiLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.ruoLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
        [_zhiLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:2.8 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.ruLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.zhiLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
        [_ruLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.chuLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.ruLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
        [_chuLabel setAlpha:1];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:3.2 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.jian0Label.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.chuLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
        [_jian0Label setAlpha:1];
    } completion:^(BOOL finished) {
        //消失
        [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.renLabel.frame = CGRectMake1((WIDTH-30)/2, (HEIGHT-30*7-10*6)/2, 30, 30);
            [_renLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.shengLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.renLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
            [_shengLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.ruoLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.shengLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
            [_ruoLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.8 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.zhiLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.ruoLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
            [_zhiLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.9 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.ruLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.zhiLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
            [_ruLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.8 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.chuLabel.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.ruLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
            [_chuLabel setAlpha:0];
        } completion:^(BOOL finished) {
        }];
        
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.jian0Label.frame = CGRectMake(CGRectGetMinX(self.renLabel.frame), CGRectGetMaxY(self.chuLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
            [_jian0Label setAlpha:0];
        } completion:^(BOOL finished) {
            
            //出现2 一
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.yuLabel.frame = CGRectMake1((WIDTH-40*3-10*2)/2, (HEIGHT-40*2-10)/2, 40, 40);
                [_yuLabel setAlpha:1];
                //self.yuLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.jianLabel.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame), CGRectGetMaxY(self.yuLabel.frame)+10*SCALE_Y, 40*SCALE_X, 40*SCALE_Y);
                [_jianLabel setAlpha:1];
                //self.jianLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:2.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.ni2Label.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame)+5*SCALE_X, CGRectGetMaxY(self.jianLabel.frame)+10*SCALE_X, 30*SCALE_X, 30*SCALE_Y);
                [_ni2Label setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.xingLabel.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame)+5*SCALE_X, CGRectGetMinY(self.yuLabel.frame)-(10+30)*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
                [_xingLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.gaoLabel.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame)+5*SCALE_X, CGRectGetMinY(self.yuLabel.frame)-(10*2+30*2)*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
                [_gaoLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.henLabel.frame = CGRectMake(CGRectGetMinX(self.yuLabel.frame)+5*SCALE_X, CGRectGetMinY(self.yuLabel.frame)-(10*3+30*3)*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
                [_henLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            //二
            [UIView animateWithDuration:2.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.meiLabel.frame = CGRectMake1((WIDTH-40*3-10*2)/2+40+10, (HEIGHT-40*2-10)/2, 40, 40);
                [_meiLabel setAlpha:1];
                //self.meiLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.hao2Label.frame = CGRectMake(CGRectGetMinX(self.meiLabel.frame), CGRectGetMaxY(self.meiLabel.frame)+10*SCALE_Y, 40*SCALE_X, 40*SCALE_Y);
                [_hao2Label setAlpha:1];
                //self.hao2Label.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.2 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.deLabel.frame = CGRectMake(CGRectGetMinX(self.meiLabel.frame)+5*SCALE_X, CGRectGetMaxY(self.hao2Label.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
                [_deLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.zheLabel.frame = CGRectMake(CGRectGetMinX(self.meiLabel.frame)+5*SCALE_X, CGRectGetMinY(self.meiLabel.frame)-(10+30)*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
                [_zheLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.zaiLabel.frame = CGRectMake(CGRectGetMinX(self.meiLabel.frame)+5*SCALE_X, CGRectGetMinY(self.meiLabel.frame)-(10*2+30*2)*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
                [_zaiLabel setAlpha:1];
            } completion:^(BOOL finished) {
            }];
            
            //三
            [UIView animateWithDuration:2.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.shiLabel.frame = CGRectMake1((WIDTH-40*3-10*2)/2+(40+10)*2, (HEIGHT-40*2-10)/2, 40, 40);
                [_shiLabel setAlpha:1];
                //self.shiLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.guangLabel.frame = CGRectMake(CGRectGetMinX(self.shiLabel.frame), CGRectGetMaxY(self.shiLabel.frame)+10*SCALE_Y, 40*SCALE_X, 40*SCALE_Y);
                [_guangLabel setAlpha:1];
                //self.guangLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            } completion:^(BOOL finished) {
            }];
            
            [UIView animateWithDuration:3.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.LiLabel.frame = CGRectMake(CGRectGetMinX(self.shiLabel.frame)+5*SCALE_X, CGRectGetMaxY(self.guangLabel.frame)+10*SCALE_Y, 30*SCALE_X, 30*SCALE_Y);
                [_LiLabel setAlpha:1];
            } completion:^(BOOL finished) {
                
                
        
                //撤退 一
                [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.yuLabel.frame = CGRectMake1(arc4random()%100, arc4random()%854, 40, 40);
                    [_yuLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:1.1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.jianLabel.frame = CGRectMake1(arc4random()%850, arc4random()%685, 40, 40);
                    [_jianLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:1.2 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.ni2Label.frame = CGRectMake1(arc4random()%865, arc4random()%952, 30, 30);
                    [_ni2Label setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:1.1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.xingLabel.frame = CGRectMake1(arc4random()%653, arc4random()%952, 30, 30);
                    [_xingLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.gaoLabel.frame = CGRectMake1(arc4random()%821, arc4random()%652, 30, 30);
                    [_gaoLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.henLabel.frame = CGRectMake1(arc4random()%751, arc4random()%982, 30, 30);
                    [_henLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                //撤退二
                [UIView animateWithDuration:1.3 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.meiLabel.frame = CGRectMake1(arc4random()%641, arc4random()%751, 40, 40);
                    [_meiLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:1.4 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.hao2Label.frame = CGRectMake1(arc4random()%666, arc4random()%982, 40, 40);
                    [_hao2Label setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:1.2 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.deLabel.frame = CGRectMake1(arc4random()%682, arc4random()%982, 30, 30);
                    [_deLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:1.1 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.zheLabel.frame = CGRectMake1(arc4random()%982, arc4random()%981, 30, 30);
                    [_zheLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:1.2 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.zaiLabel.frame = CGRectMake1(arc4random()%652, arc4random()%984, 30, 30);
                    [_zaiLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                //撤退三
                [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.shiLabel.frame = CGRectMake1(arc4random()%842, arc4random()%691, 40, 40);
                    [_shiLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.guangLabel.frame = CGRectMake(CGRectGetMinX(self.shiLabel.frame), CGRectGetMaxY(self.shiLabel.frame)+10*SCALE_Y, 40*SCALE_X, 40*SCALE_Y);
                    [_guangLabel setAlpha:0];
                } completion:^(BOOL finished) {
                }];
                
                [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.LiLabel.frame = CGRectMake1(arc4random()%845, arc4random()%982, 40, 40);
                    [_LiLabel setAlpha:0];
                } completion:^(BOOL finished) {
                    
                    
                }];

            }];
            
        }];
    }];
    
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
