//
//  ViewController.m
//  AnimationButton
//
//  Created by sischen on 2017/11/25.
//  Copyright © 2017年 pcbdoor.com. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+CCFavoriteAnimation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.86];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(60, 60, 150, 150)];
    btn.ccIsUnchosenStyleStroke = YES;
    btn.ccIsFavoriteAnimationEnabled = YES;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.ccIsFavorite = YES;
    });

}

-(void)btnClicked:(UIButton *)btn{
    btn.ccIsFavorite = !btn.ccIsFavorite;
}


@end
