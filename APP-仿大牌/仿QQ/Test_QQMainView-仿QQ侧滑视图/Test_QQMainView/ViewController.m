//
//  ViewController.m
//  Test_QQMainView
//
//  Created by jaybin on 15/4/20.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "LeftViewController.h"
#import "DetailViewController.h"
#import "CommonTools.h"

@interface ViewController (){
    //动画参数
    float distance;
    float FullDistance;
    float Proportion;
    
    CGPoint centerOfLeftViewAtBeginning;
    float proportionOfLeftView;
    float distanceOfLeftView;
    
    //视图
    UINavigationController *homeViewNavi;
    MainViewController *mainView;
    LeftViewController *leftView;
    UIView *backView;
    
    UITapGestureRecognizer *tapGuesture;
    
    BOOL leftViewShow;
    BOOL rightViewShow;
    BOOL homeViewShow;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backImage setImage:[UIImage imageNamed:@"back"]];
    [self.view addSubview:backImage];
    
    
    //初始化变量
    [self initVariables];
    
    //左视图
    leftView = [[LeftViewController alloc] init];
    leftView.view.center = CGPointMake(leftView.view.center.x - 50, leftView.view.center.y);
    leftView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    
    __weak id tmp0 = self;
    leftView.cellSelectedBolck = ^(NSString *desc){
        [tmp0 pushToSubView:desc];
        [tmp0 showHomeView];
    };
    centerOfLeftViewAtBeginning = leftView.view.center;
    [self.view addSubview:leftView.view];
    
    // 增加黑色遮罩层，实现视差特效
    backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    
    //主视图
    mainView = [[MainViewController alloc] init];
    mainView.view.frame = self.view.frame;
    
    __weak id tmp1 = self;
    mainView.barButtonBlock = ^(BarButtonClickType type){
        switch (type) {
            case ELeftButtonClicked:
                [tmp1 showLeftView];
                break;
            case ERightButtonClicked:
                [tmp1 showRightView];
                break;
                
            default:
                break;
        }
    };
    
    homeViewNavi = [[UINavigationController alloc] initWithRootViewController:mainView];
    [self.view addSubview:homeViewNavi.view];
    
    //处理主视图左右滑动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dealMainViewPan:)];
    [mainView.view addGestureRecognizer:panGesture];
    
    //处理主视图点击还原位置手势
    tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealMainViewTap:)];
    
}

/**
 *  初始化变量
 */
- (void)initVariables{
    distance = 0.0;
    FullDistance = 0.78;
    Proportion = 0.77;
    
    proportionOfLeftView = 1.0;
    distanceOfLeftView = 50.0;
    
    if (SCREEM_WIDTH > 320) {
        proportionOfLeftView = SCREEM_WIDTH / 320;
        distanceOfLeftView += (SCREEM_WIDTH - 320) * FullDistance / 2;
    }
}

/**
 *  处理主视图左右滑动手势
 */
- (void)dealMainViewPan:(id)recognizer{
    
    UIPanGestureRecognizer *panReconizer = (UIPanGestureRecognizer *)recognizer;
    
    float X_distance = 0.0f;
    float trueProportion  = 0.0f;
    X_distance = distance + [panReconizer translationInView:self.view].x;
    trueProportion = X_distance / (SCREEM_WIDTH*FullDistance);
    
    // 如果 UIPanGestureRecognizer 结束，则激活自动停靠
    if (panReconizer.state == UIGestureRecognizerStateEnded) {
        
        if (X_distance > SCREEM_WIDTH * (Proportion / 3)){
            [self showLeftView];
        } else if (X_distance < SCREEM_WIDTH * -(Proportion / 3)) {
            [self showRightView];
        } else {
            [self showHomeView];
        }
        
        return;
    }
    
    // 计算缩放比例
    float proportion = homeViewNavi.view.frame.origin.x >= 0 ? -1 : 1;
    proportion *= X_distance / SCREEM_WIDTH;
    proportion *= 1 - Proportion;
    proportion /= FullDistance + Proportion/2 - 0.5;
    proportion += 1;
    if (proportion <= Proportion) { // 若比例已经达到最小，则不再继续动画
        return;
    }
    // 执行视差特效
    backView.alpha = (proportion - Proportion) / (1 - Proportion);
    
    //处理主视图平行移动
    homeViewNavi.view.center = CGPointMake(self.view.center.x + X_distance, self.view.center.y);
    homeViewNavi.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    
    
    if(homeViewNavi.view.frame.origin.x <= 0){
        leftView.view.alpha = 0.0;
    }
    // 执行左视图动画
    float pro = 0.8 + (proportionOfLeftView - 0.8) * trueProportion;
    leftView.view.center = CGPointMake(centerOfLeftViewAtBeginning.x + distanceOfLeftView * trueProportion, leftView.view.center.y );
    leftView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, pro, pro);
}

/**
 *  左右视图显示的时候，点击主视图，恢复主视图位置
 */
- (void)dealMainViewTap:(id)recognizer{
    [self showHomeView];
}

- (void)pushToSubView:(NSString *)desc{
    [mainView pushToSubView:desc];
}


- (void)showLeftView{
    distance = self.view.center.x * (FullDistance*2 + Proportion - 1);
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        homeViewNavi.view.center = CGPointMake(self.view.center.x + distance, self.view.center.y);
        homeViewNavi.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, Proportion, Proportion);
        
        leftView.view.center = CGPointMake(centerOfLeftViewAtBeginning.x + distanceOfLeftView, leftView.view.center.y);
        leftView.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportionOfLeftView, proportionOfLeftView);
        
        backView.alpha = 0.0;
        leftView.view.alpha = 1.0;
        
    } completion:(void (^)(BOOL finished))^{
        [mainView.view addGestureRecognizer:tapGuesture];
    }];
}

- (void)showRightView{
    distance = self.view.center.x * -(FullDistance*2 + Proportion - 1);
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        homeViewNavi.view.center = CGPointMake(self.view.center.x + distance, self.view.center.y);
        homeViewNavi.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, Proportion, Proportion);
        
        backView.alpha = 0.0;
        leftView.view.alpha = 0.0;
        
    } completion:(void (^)(BOOL finished))^{
        [mainView.view addGestureRecognizer:tapGuesture];
    }];
}

- (void)showHomeView{
    distance = 0.0;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        homeViewNavi.view.center = CGPointMake(self.view.center.x + distance, self.view.center.y);
        homeViewNavi.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        
        backView.alpha = 1.0;
        leftView.view.alpha = 1.0;
        
    } completion:(void (^)(BOOL finished))^{
        [mainView.view removeGestureRecognizer:tapGuesture];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
