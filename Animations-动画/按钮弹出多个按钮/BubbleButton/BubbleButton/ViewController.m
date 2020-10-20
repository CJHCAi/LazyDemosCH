//
//  ViewController.m
//  BubbleButton
//
//  Created by lisonglin on 15/05/2017.
//  Copyright © 2017 lisonglin. All rights reserved.
//

#import "ViewController.h"
#import "LSLCoverView.h"
#import "LSLCoverPlusView.h"

static CGFloat const kDefaultAnimationDuration = 0.2f;
static CGFloat const kDefaultOriginBtnWidth = 40.0;
static CGFloat const kDefaultOriginBtnHeight = kDefaultOriginBtnWidth;

@interface ViewController ()<LSLCoverViewDelegate,LSLCoverPlusViewDelegate>

@property(nonatomic, strong) LSLCoverView * coverView;

@property(nonatomic, assign,getter=isShow) BOOL show;

@property(nonatomic, weak) UIButton * floatingBtn;


@end

@implementation ViewController


- (LSLCoverView *)coverView
{
    if (!_coverView) {
        _coverView = [[LSLCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.delegate = self;
    }
    return _coverView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.show = NO;
    
    LSLCoverPlusView * vm = [[LSLCoverPlusView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    vm.delegate = self;
    
    [self.view addSubview:vm];
    
    
    //initial
//    [self initUserInterface];
    
}

- (void)coverPlusView:(LSLCoverPlusView *)coverView didClickAtIndex:(NSInteger)index
{
    NSLog(@"%ld",index);
}






#pragma mark -- initial
- (void)initUserInterface
{
    UIButton * floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingBtn = floatingBtn;
    floatingBtn.frame = CGRectMake(self.view.bounds.size.width / 2 + 40, self.view.bounds.size.height - 150, kDefaultOriginBtnWidth, kDefaultOriginBtnHeight);
    floatingBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:floatingBtn];
    [self.view bringSubviewToFront:floatingBtn];
    [floatingBtn addTarget:self action:@selector(floatingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    floatingBtn.layer.cornerRadius = kDefaultOriginBtnWidth / 2;
    [floatingBtn setTitle:@"L" forState:UIControlStateNormal];
}



#pragma mark -- Button Click
- (void)floatingBtnClick
{
    self.show = !self.show;
    
    if (self.isShow) {//如果显示,逆时针旋转40度
        
        [self.view addSubview:self.coverView];
        
        [self.view bringSubviewToFront:self.floatingBtn];
        
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            self.floatingBtn.transform = CGAffineTransformMakeRotation(-M_PI_4 * 3);
            
        }];

    }else { //移除coverView 按钮旋转回开始的位置
        [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
            self.floatingBtn.transform = CGAffineTransformMakeRotation(0);

        }];

    }
    
    self.coverView.show = self.show;
    
}


#pragma mark -- LSLCoverViewDelegate
- (void)coverView:(LSLCoverView *)coverView didClickBtnAtIndex:(NSInteger)index dismiss:(BOOL)dismiss
{
    self.show = dismiss;
    
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        self.floatingBtn.transform = CGAffineTransformMakeRotation(0);
        
    }];

}





@end
