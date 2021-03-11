//
//  SaleViewController.m
//  QHPay
//
//  Created by liqunfei on 16/3/22.
//  Copyright © 2016年 chenlizhu. All rights reserved.
//

#import "SaleViewController.h"
#import "WaveView.h"


@interface SaleViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *ViewHs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vDistance;
@property (strong,nonatomic) NSMutableArray *views;
@property (strong,nonatomic) UIScrollView *scroll;

@end

@implementation SaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.views = [NSMutableArray array];
    [self buildUI];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.views.count) {
        for (WaveView *w in self.views) {
            [w addAnimate];
        }
    }
}


- (NSArray *)dataArr {
    if (!_dataArr) {
        
        _dataArr = [NSArray arrayWithObjects:@{@"percent":@"10%",@"money":@"1000",@"range":@"0-10w"},@{@"percent":@"20%",@"money":@"2000",@"range":@"10-20w"},@{@"percent":@"30%",@"money":@"3000",@"range":@"20-30w"},@{@"percent":@"40%",@"money":@"4000",@"range":@"30-40w"},@{@"percent":@"50%",@"money":@"5000",@"range":@"40-50w"}, nil];
    }
    return _dataArr;
}

- (void)buildUI {
    for (NSLayoutConstraint *viewH in self.ViewHs) {
        viewH.constant = 0.5f;
    }
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(MAINSCREEN_BOUNDS.size.width / 4 - 15*SCREEN_RATIO, 20, MAINSCROLLVIEW_WIDTH, 180*SCREEN_RATIO)];
    self.scroll.clipsToBounds = NO;
    self.scroll.pagingEnabled = YES;
    self.scroll.contentSize = CGSizeMake(MAINSCROLLVIEW_WIDTH * self.dataArr.count, 180*SCREEN_RATIO);
    self.scroll.delegate = self;
    self.scroll.showsHorizontalScrollIndicator = NO;
    [self.backView addSubview:self.scroll];
    self.backViewH.constant = 280 * SCREEN_RATIO;
    self.vDistance.constant = 60 * SCREEN_RATIO;
    [self.view setBackgroundColor:RGBA(219, 220, 221, 1.0f)];
    for (int i = 0; i < self.dataArr.count; i++) {
        WaveView *wave =[[WaveView alloc] initWithFrame:CGRectMake(MAINSCROLLVIEW_WIDTH / 2 - 180*SCREEN_RATIO/2 + i * MAINSCROLLVIEW_WIDTH, 0, 180*SCREEN_RATIO, 180*SCREEN_RATIO)];
        wave.percent = [self.dataArr[i] objectForKey:@"percent"];
        wave.money = [self.dataArr[i] objectForKey:@"money"];
        wave.tag = 100+i;
        CGFloat rotat = (MAINSCREEN_BOUNDS.size.width - 60) / (self.dataArr.count - 1);
        [wave buildUI];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30 + i * rotat - 5, 280 * SCREEN_RATIO - 60 * SCREEN_RATIO - 5, 10, 10)];
        view.layer.cornerRadius = 5.0f;
        view.tag = 1000 + i;
        [self.backView addSubview:view];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self.dataArr[i] objectForKey:@"range"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button setTitleColor:RGBA(191, 191, 191, 1.0) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        if (i == 0) {
            button.selected = YES;
            view.backgroundColor = [UIColor redColor];
            wave.alpha = 1.0f;
            wave.transform = CGAffineTransformIdentity;
        }
        else {
            button.selected = NO;
            view.backgroundColor = RGBA(220, 220, 220, 1.0);
            wave.alpha = 0.6f;
            wave.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(30 + i * rotat - 25, 280 * SCREEN_RATIO - 60 * SCREEN_RATIO + 15, 50, 20);
        button.tag = 10000 + i;
        
        [self.backView addSubview:button];
        [self.scroll addSubview:wave];
        [self.views addObject:wave];
    }
}

- (void)buttonAction:(UIButton *)sender {
    for (int i = 0; i < self.views.count; i++) {
        UIView *view = [self.backView viewWithTag:1000+i];
        UIView *view1 = self.views[i];
        if ((sender.tag - 10000) == i) {
            sender.selected = YES;
            [self.scroll setContentOffset:CGPointMake(i * self.scroll.bounds.size.width, 0) animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                view1.alpha = 1.0f;
                view1.transform = CGAffineTransformMakeScale(1.0, 1.0);
                view.backgroundColor = [UIColor redColor];
            }];
        }
        else {
            UIButton *button = [self.backView viewWithTag:10000 + i];
            button.selected = NO;
            [UIView animateWithDuration:0.3 animations:^{
                view1.alpha = 0.6f;
                view1.transform = CGAffineTransformMakeScale(0.8, 0.8);
                view.backgroundColor = RGBA(220, 220, 220, 1.0);
            }];
        }
    }
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    for (int i = 0 ; i < self.views.count; i++) {
        UIView *view = self.views[i];
        if (view.alpha == 1.0) {
            if ((int)((* targetContentOffset).x - i * MAINSCROLLVIEW_WIDTH) > 0) {
                if (i != self.views.count - 1) {
                    UIView *view1 = self.views[i+1];
                    UIView *view2 = [self.backView viewWithTag:1001 + i];
                    UIView *view3 = [self.backView viewWithTag:1000 + i];
                    UIButton *button1 = [self.backView viewWithTag:10001 + i];
                    UIButton *button2 = [self.backView viewWithTag:10000 + i];
                    [UIView animateWithDuration:0.3 animations:^{
                        view.alpha = 0.6;
                        button1.selected = YES;
                        button2.selected = NO;
                        view2.backgroundColor = [UIColor redColor];
                        view3.backgroundColor = RGBA(220, 220, 220, 1.0);
                        view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                        view1.alpha = 1.0f;
                        view1.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                    break;
                }
            }
            else if ((int)((* targetContentOffset).x - i * MAINSCROLLVIEW_WIDTH  < 0)) {
                if (i != 0) {
                    UIView *view1 = self.views[i-1];
                    UIView *view2 = [self.backView viewWithTag:999 + i];
                    UIView *view3 = [self.backView viewWithTag:1000 + i];
                    UIButton *button1 = [self.backView viewWithTag:9999 + i];
                    UIButton *button2 = [self.backView viewWithTag:10000 + i];
                    [UIView animateWithDuration:0.3 animations:^{
                        view.alpha = 0.6;
                        button1.selected = YES;
                        button2.selected = NO;
                        view2.backgroundColor = [UIColor redColor];
                        view3.backgroundColor = RGBA(220, 220, 220, 1.0);
                        view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                        view1.alpha = 1.0f;
                        view1.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                    break;
                }
            }
        }
    }
}



@end
