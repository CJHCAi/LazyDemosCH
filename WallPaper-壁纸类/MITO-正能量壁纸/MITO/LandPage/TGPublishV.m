//
//  TGPublishV.m
//  baisibudejie
//
//  Created by targetcloud on 2017/5/20.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

#import "TGPublishV.h"
#import "LJSearchViewController.h"
#import "LJClassifyViewController.h"
#import "TGPostWordSecondVC.h"
#import "LJMultiViewController.h"
#import "TGPostWordThiredVC.h"
#import "LJTableRootViewController.h"
#import "LJObjectsViewController.h"
#import "TGFastBtn.h"
#import "TGNavigationVC.h"
#import <POP.h>

static CGFloat const AnimationDelay = 0.1;
static CGFloat const SpringFactor = 10;

@interface TGPublishV ()
@property (nonatomic, strong) NSMutableArray *controllers;
@end

@implementation TGPublishV

- (void)awakeFromNib {
    [super awakeFromNib];
    RootV.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    NSArray *titles = @[@"搜索",@"分类",@"综合"];//,@"照相"
    NSArray *images = @[@"publish-link",@"publish-picture",@"publish-review"];//,@"publish-audio"
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    NSInteger maxCols = 3;
    CGFloat buttonStratX = 1 * Margin;
    CGFloat buttonXMargin = (ScreenW - 2 * buttonStratX - maxCols * buttonW) / (maxCols - 1);
    CGFloat buttonYMargin = Margin;
    CGFloat buttonStratY = (ScreenH - 2 * buttonH) * 0.5;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        TGFastBtn *button = [TGFastBtn buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger row = i / maxCols;
        NSInteger col = i % maxCols;
        CGFloat buttonX = buttonStratX + col * (buttonW + buttonXMargin);
        CGFloat buttonEndY = buttonStratY + row * (buttonH + buttonYMargin);
        CGFloat buttonBeginY = buttonEndY - ScreenH;
        [self addSubview:button];
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.springSpeed = SpringFactor;
        anim.springBounciness = SpringFactor;
        anim.beginTime = CACurrentMediaTime() + AnimationDelay * i;
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        [button pop_addAnimation:anim forKey:nil];
    }
    
    UIImageView *titleImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
    titleImageV.y = ScreenH * 0.15 - ScreenH;
    [self addSubview:titleImageV];
    CGFloat centerX = ScreenW * 0.5;
    CGFloat titleStartY = titleImageV.y;
    CGFloat titleEndY = ScreenH * 0.15;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    [titleImageV pop_addAnimation:anim forKey:nil];
    anim.springSpeed = SpringFactor;
    anim.springBounciness = SpringFactor;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, titleStartY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, titleEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * AnimationDelay;
    
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        RootV.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
    }];
    _controllers = [NSMutableArray array];
    
    [self setViewControllers];
    
}

- (void)cancelWithCompletionBlock:(void(^)())completionBlock{
    RootV.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    NSInteger beginI = 1;
    for (NSInteger i = beginI; i < self.subviews.count; i++) {
        UIView *currentView = self.subviews[i];
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat endY = currentView.y + ScreenH;
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(currentView.centerX, endY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginI) * AnimationDelay;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [currentView pop_addAnimation:anim forKey:nil];
        if (i == self.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                RootV.userInteractionEnabled =YES;
                self.userInteractionEnabled = YES;
                [self removeFromSuperview];
                !completionBlock ? : completionBlock();
            }];
        }
    }
}

- (void)btnClick:(TGFastBtn *)button{
    [self cancelWithCompletionBlock:^{
        
        switch (button.tag) {
            case 0:
            {
                LJSearchViewController *postWordVc = [[LJSearchViewController alloc] init];
                TGNavigationVC *nav = [[TGNavigationVC alloc]initWithRootViewController:postWordVc];
                UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                [root presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 1:
            {
                LJClassifyViewController *postWordVc = [[LJClassifyViewController alloc] init];
                TGNavigationVC *nav = [[TGNavigationVC alloc]initWithRootViewController:postWordVc];
                UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                [root presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 2:
            {
                LJMultiViewController *postWordVc = [[LJMultiViewController alloc]initWithSubTitles:@[@"最热",@"最新",@"分享榜",@"高清",@"热搜",@"套图",@"性感"] addControllers:_controllers];
                TGNavigationVC *nav = [[TGNavigationVC alloc]initWithRootViewController:postWordVc];
                UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                [root presentViewController:nav animated:YES completion:nil];
            }
                break;
            case 3:
            {
                TGPostWordThiredVC *postWordVc = [[TGPostWordThiredVC alloc] init];
                TGNavigationVC *nav = [[TGNavigationVC alloc]initWithRootViewController:postWordVc];
                UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                [root presentViewController:nav animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelWithCompletionBlock:nil];
}

#pragma mark 创建viewControllers
- (void)setViewControllers {
    NSArray *viewControllesStr = @[@"LJHotViewController",@"LJFreshViewController",@"LJShareViewController",@"LJDistinctViewController",@"LJFindViewController",@"LJPictureViewController",@"LJSexyViewController"];
    for (int index = 0; index < viewControllesStr.count; index ++) {
        Class class = NSClassFromString(viewControllesStr[index]);
        if (index == 5 || index == 6) {
            LJTableRootViewController *tableVC = [[class alloc] init];
            tableVC.urlStr = @"http://360web.shoujiduoduo.com/wallpaper/wplist.php?user=868637010417434&prod=WallpaperDuoduo2.3.6.0&isrc=WallpaperDuoduo2.3.6.0_360ch.apk&type=getlist&listid=%ld&st=no&pg=%ld&pc=20&mac=802275a25111&dev=K-Touch%%253ET6%%253EK-Touch%%2BT6&vc=2360";
            tableVC.viewControllerType = index;
            [_controllers addObject:tableVC];
        }else {
            LJObjectsViewController *object = [[class alloc] init];
            object.urlStr = @"http://360web.shoujiduoduo.com/wallpaper/wplist.php?user=868637010417434&prod=WallpaperDuoduo2.3.6.0&isrc=WallpaperDuoduo2.3.6.0_360ch.apk&type=getlist&listid=%ld&st=no&pg=%ld&pc=20&mac=802275a25111&dev=K-Touch%%253ET6%%253EK-Touch%%2BT6&vc=2360";
            object.viewControllerType = index;
            object.isFromClassify = NO;
            object.isFromSearch = NO;
            [_controllers addObject:object];
        }
        
    }
}

@end
