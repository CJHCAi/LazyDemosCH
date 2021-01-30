//
//  ViewController.m
//  demo1
//
//  Created by apple2 on 2018/6/20.
//  Copyright © 2018年 Guoao. All rights reserved.
//

#import "ViewController.h"
#import "ZCAnimmalButton.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<HeadImgViewBtnDelegate>
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic,strong) UIView *bgView ;
//@property (nonatomic, strong) ZCAnimmalButton *button;
//@property (nonatomic, strong) ZCAnimmalButton *button1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, 300)];
    self.bgView.backgroundColor = [UIColor orangeColor];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, 300)];
        bgImgView.image = [UIImage imageNamed:@"1"];
    bgImgView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:bgImgView];
    
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 600, 100, 72)];
    _iconImageView.image = [UIImage imageNamed:@"2"];
    _iconImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_iconImageView];
    [self initAnimationButton];
}
-(void)initAnimationButton//存放NSString数组
{
    
    for (int j=0; j<20; j++)
    {
        ZCAnimmalButton *button2 = [[ZCAnimmalButton alloc] initWithFrame:[self randomRect:j] andEndPoint:CGPointMake(self.iconImageView.center.x, self.iconImageView.center.y-self.iconImageView.frame.size.height/2)];
        [button2 setImage:[UIImage imageNamed:@"timg.png"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = j;
        NSTimeInterval animationDuration = 0.50f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
        
        [self.bgView addSubview:button2];
        [UIView commitAnimations];
    }
}
    
    
//    _button = [[ZCAnimmalButton alloc] initWithFrame:CGRectMake(100, 100, 20, 20) andEndPoint:self.iconImageView.center];
//    [_button setImage:[UIImage imageNamed:@"timg.png"] forState:UIControlStateNormal];
//    [self.view addSubview:_button];
//    _button1 = [[ZCAnimmalButton alloc] initWithFrame:CGRectMake(200, 100, 20, 20) andEndPoint:self.iconImageView.center];
//    [_button1 setImage:[UIImage imageNamed:@"timg.png"] forState:UIControlStateNormal];
//    [self.view addSubview:_button1];
//
    //    HHShootButton *shootBtn = [[HHShootButton alloc] initWithFrame:CGRectMake(10, 300, 80, 80) andEndPoint:self.iconImageView.center];
    //    [shootBtn setImage:[UIImage imageNamed:@"icon_xin"] forState:UIControlStateNormal];
    //    shootBtn.setting.animationType = ShootButtonAnimationTypeLine;
    //    [self.view addSubview:shootBtn];

//-(void)buttonClickBut{
//    
//    
//    
//}
-(void)buttonClick:(UIButton *)senter{
    
    NSLog(@"目前打印得是%ld",senter.tag);
}
-(CGRect)randomRect:(NSInteger)count
{
    BOOL isIntersect=NO;
    int x = arc4random() % (int)SCREEN_WIDTH;
    int y =  arc4random() % (int)300;

    CGRect buttonFrame= CGRectMake(x, y, self.iconImageView.frame.size.width, self.iconImageView.frame.size.height);
    do {
        int i=0;
        if ((buttonFrame.origin.x+buttonFrame.size.width)>SCREEN_WIDTH||(buttonFrame.origin.y+buttonFrame.size.height)>300)
        {
            isIntersect=YES;
        }else
        {
            isIntersect=NO;
            for (id obj in self.view.subviews)
            {
                if ([obj isKindOfClass:[ZCAnimmalButton class]])
                {
                    i++;
                    ZCAnimmalButton * mybutton = (ZCAnimmalButton*)obj;
                    if (CGRectIntersectsRect(buttonFrame,mybutton.frame))
                    {
                        isIntersect=YES;
                        break;
                    }
                }
                if (i==count)
                {
                    isIntersect=NO;
                }
            }
        }
        if (isIntersect)
        {
            x = arc4random() % (int)SCREEN_WIDTH;
            y = arc4random() % (int)300;
            buttonFrame= CGRectMake(x, y,self.iconImageView.frame.size.width, self.iconImageView.frame.size.height);
        }
    } while (isIntersect);
    return buttonFrame;
}


@end
