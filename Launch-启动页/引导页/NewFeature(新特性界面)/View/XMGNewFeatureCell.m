//
//  XMGNewFeatureCell.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/30.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGNewFeatureCell.h"

#import "XMGSaveTool.h"
#import "XMGTabBarController.h"

@interface XMGNewFeatureCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *startButton;


@end

@implementation XMGNewFeatureCell

- (UIButton *)startButton
{
    if (!_startButton) {
        // 如果使用苹果提供的类方法创建对象，苹果会帮我们管理
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_startButton setBackgroundImage:[UIImage imageNamed:@"guideStart"] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        _startButton.centetX = self.width*0.5;
        _startButton.centetY = self.height * 0.9;
        _startButton.width = 150;
        _startButton.height =30;
        _startButton.backgroundColor=[UIColor orangeColor];
        [self.contentView addSubview:_startButton];

    }
    return _startButton;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView = imageV;
        [self.contentView addSubview:imageV];
    }
    
    return _imageView;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)setUpIndexPath:(NSIndexPath *)indexPath count:(NSInteger)pagesCount
{
    if (indexPath.row == pagesCount-1) {
        // 最后一行
        // 添加立即体验按钮
        self.startButton.hidden = NO;
        
    }else{
        self.startButton.hidden = YES;
    }
    
}

// 点击立即体验按钮
- (void)start
{
    // 跳转到核心界面,push,modal,切换跟控制器的方法
    XMGKeyWindow.rootViewController = [[XMGTabBarController alloc] init];
    CATransition *anim = [CATransition animation];
    anim.duration = 0.5;
    anim.type = @"rippleffect";
    [XMGKeyWindow.layer addAnimation:anim forKey:nil];
}

@end
