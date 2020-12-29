//
//  HKCouponController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCouponController.h"
#import "HKCouponSubVc.h"
#import "HKCollageVC.h"
@interface HKCouponController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIView *topV;
@property (nonatomic, strong)NSMutableArray *btnArr;
@property (nonatomic, strong)UIScrollView * rootScollView;


@end

@implementation HKCouponController

//-(NSMutableArray *)btnArr {
//    if (!_btnArr) {
//        _btnArr =[[NSMutableArray alloc] init];
//    }
//    return _btnArr;
//}
//-(instancetype)init {
//    self =[super init];
//    if (self) {
//        self.sx_disableInteractivePop = YES;
//    }
//    return  self;
//}
//-(void)initNav {
//   
//}
//
//
//
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self initNav];
//    [self creatSubViewControllers];
//    [self.view addSubview:self.bottomMoreView];
//}
//-(void)creatSubViewControllers {
//
//    self.topV = topV;
//    [self.view addSubview:topV];
//
//    [self.view addSubview:self.rootScollView];
//
//}
//-(UIScrollView *)rootScollView {
//    if (!_rootScollView) {
//        _rootScollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topV.frame),kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight -CGRectGetHeight(self.topV.frame)-50)];
//        _rootScollView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
//        _rootScollView.delegate = self;
//        _rootScollView.scrollEnabled = NO;
//        _rootScollView.showsHorizontalScrollIndicator = NO;
//        for (int i= 0; i<self.btnArr.count; i++) {
//            HKCouponSubVc * vc  =[[HKCouponSubVc alloc] init];
//            if (i==0) {
//                vc.view.backgroundColor =[UIColor redColor];
//                vc.state = 1;
//            }else if (i==1){
//                vc.view.backgroundColor =[UIColor blueColor];
//                vc.state = 4;
//
//            }else if (i==2){
//                vc.view.backgroundColor  =[UIColor greenColor];
//                vc.state =3;
//            }
//            vc.view.frame =CGRectMake(i*kScreenWidth,0,kScreenWidth,CGRectGetHeight(_rootScollView.frame));
//            [_rootScollView addSubview:vc.view];
//            [self addChildViewController:vc];
//        }
//        [_rootScollView setContentSize:CGSizeMake(self.btnArr.count *kScreenWidth,CGRectGetHeight(_rootScollView.frame))];
//    }
//    return _rootScollView;
//}
//
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSInteger index = scrollView.contentOffset.x /kScreenWidth;
//    UIButton  * b = [self.btnArr objectAtIndex:index];
//    for (UIButton * btn in self.btnArr) {
//        [btn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
//    }
//     [b setTitleColor:RGBA(239,89,60,1) forState:UIControlStateNormal];
//}

@end
