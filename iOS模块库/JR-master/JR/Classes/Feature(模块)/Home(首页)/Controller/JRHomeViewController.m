//
//  JRHomeViewController.m
//  JR
//
//  Created by Zj on 17/8/19.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRHomeViewController.h"
#import "JRAdViewController.h"
#import "JRGymInfoView.h"
#import "JRZoomCycleImgView.h"
#import "JRFitnessStatusView.h"
#import "JRGymClassTableView.h"
#import "Lottie.h"

@interface JRHomeViewController ()<JRGymClassTableViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JRGymInfoView *gymInfoView;
@property (nonatomic, strong) JRZoomCycleImgView *zoomCycleImgView;
@property (nonatomic, strong) JRFitnessStatusView *fitnessStatusView;
@property (nonatomic, strong) JRGymClassTableView *gymClassTableView;
@property (nonatomic, strong) UILabel *statusTitle;
@property (nonatomic, strong) UILabel *classTitle;
@property (nonatomic, strong) UIView *launchMask;
@property (nonatomic, strong) LOTAnimationView *launchAnimation;

@end

@implementation JRHomeViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = JRHexColor(0xf5fafa);
    
    [self setupScrollView];
    
    [self setupGymInfoView];
    
    [self setupZoomCycleImgView];
    
    [self setupFitnessStatusView];
    
    [self setupGymClassTableView];
    
    if (self.isShowLaunchAnimation) {
        [self setupLaunchMask];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_launchMask && _launchAnimation) {
        WeakObj(self);
        [_launchAnimation playWithCompletion:^(BOOL animationFinished) {
            
            [UIView animateWithDuration:0.3 animations:^{
                selfWeak.launchMask.alpha = 0;
            } completion:^(BOOL finished) {
                [selfWeak.launchAnimation removeFromSuperview];
                selfWeak.launchAnimation = nil;
                [selfWeak.launchMask removeFromSuperview];
                selfWeak.launchMask = nil;
            }];
        }];
    }
}


#pragma mark - private
- (void)setupLaunchMask{
    _launchMask = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [JRKeyWindow addSubview:_launchMask];
    
    _launchAnimation = [LOTAnimationView animationNamed:@"data"];
    _launchAnimation.cacheEnable = NO;
    _launchAnimation.frame = self.view.bounds;
    _launchAnimation.contentMode = UIViewContentModeScaleToFill;
    _launchAnimation.animationSpeed = 1.2;
    
    [_launchMask addSubview:_launchAnimation];
}


- (void)setupScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 20, 0);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(JRScreenWidth, JRGymInfoViewHeight + JRZoomCycleImgViewHeight + JRHomeTitleHeight * 2 + JRFitnessStatusViewHeight + JRGymClassCellHeight * 3 + 14 * JRPadding);
    [self.view addSubview:_scrollView];
}


- (void)setupGymInfoView{
    _gymInfoView = [[JRGymInfoView alloc] initWithFrame:CGRectMake(0, 0, JRScreenWidth, JRGymInfoViewHeight)];
    
    [_scrollView addSubview:_gymInfoView];
}


- (void)setupZoomCycleImgView{
    
    _zoomCycleImgView = [[JRZoomCycleImgView alloc] initWithFrame:CGRectMake(0, _gymInfoView.bottom + 3 * JRPadding, JRScreenWidth, JRZoomCycleImgViewHeight)];
    _zoomCycleImgView.picArray = @[[UIImage imageNamed:@"banner1"], [UIImage imageNamed:@"banner2"]];
    
    [_scrollView addSubview:_zoomCycleImgView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(JRPadding, _zoomCycleImgView.bottom + 2 * JRPadding, JRScreenWidth - 2 * JRPadding, 1)];
    line.backgroundColor = [JRBlackColor colorWithAlphaComponent:0.05];

    [_scrollView addSubview:line];
}


- (void)setupFitnessStatusView{
    _statusTitle = [UILabel labelWithFrame:CGRectMake(JRPadding, _zoomCycleImgView.bottom + 3.5 * JRPadding, JRScreenWidth - 2 * JRPadding, JRHomeTitleHeight) text:@"健身情况" color:JRCommonTextColor font:JRCommonFont(JRCommonTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [_scrollView addSubview:_statusTitle];
    
    _fitnessStatusView = [[JRFitnessStatusView alloc] initWithFrame:CGRectMake(0, _statusTitle.bottom + JRPadding, JRScreenWidth, JRFitnessStatusViewHeight)];
    
    [_scrollView addSubview:_fitnessStatusView];
}


- (void)setupGymClassTableView{
    _classTitle = [UILabel labelWithFrame:CGRectMake(JRPadding, _fitnessStatusView.bottom + 3.5 * JRPadding, JRScreenWidth - 2 * JRPadding, JRHomeTitleHeight) text:@"精品团课" color:JRCommonTextColor font:JRCommonFont(JRCommonTextFontSize) textAlignment:NSTextAlignmentLeft];
    
    [_scrollView addSubview:_classTitle];
    
    _gymClassTableView = [[JRGymClassTableView alloc] initWithFrame:CGRectMake(0, _classTitle.bottom + JRPadding, JRScreenWidth, JRGymClassCellHeight * 3 + JRPadding * 3) style:UITableViewStylePlain];
    _gymClassTableView.JRdelegate=self;
    [_scrollView addSubview:_gymClassTableView];
}


-(void)JRGymClassTableViewdidSelectedRowWithRow:(NSInteger)row{
    JRAdViewController * adVC=[JRAdViewController new];
    [self.navigationController pushViewController:adVC animated:YES];
}
@end
