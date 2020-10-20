//
//  ViewController.m
//  TLMemuButton
//
//  Created by tianlei on 16/6/29.
//  Copyright © 2016年 tianlei. All rights reserved.
//

#import "ViewController.h"
#import "TLMenuButtonView.h"

#define kWidth  [[UIApplication sharedApplication] keyWindow].bounds.size.width  
#define kHeight [[UIApplication sharedApplication] keyWindow].bounds.size.height

@interface ViewController ()
{
    BOOL _ISShowMenuButton;
}

@property (nonatomic, strong) TLMenuButtonView *tlMenuView ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ISShowMenuButton = NO;
   
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-67, self.view.bounds.size.height-107, 55, 55)];
    button.layer.cornerRadius = 27.5;
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    TLMenuButtonView *tlMenuView =[TLMenuButtonView standardMenuView];
    tlMenuView.centerPoint = button.center;
    __weak typeof(self) weakSelf = self;
    tlMenuView.clickAddButton = ^(NSInteger tag, UIColor *color){
        weakSelf.view.backgroundColor = color;
        _ISShowMenuButton = YES;
        [weakSelf clickAddButton:button];
    };
    _tlMenuView = tlMenuView;
}

- (void)clickAddButton:(UIButton *)sender{
    
    if (!_ISShowMenuButton) {
        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransform rotate = CGAffineTransformMakeRotation( M_PI / 4 );
            [sender setTransform:rotate];
        }];
        [_tlMenuView showItems];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            CGAffineTransform rotate = CGAffineTransformMakeRotation( 0 );
            [sender setTransform:rotate];
        }];
        [_tlMenuView dismiss];
    }
    _ISShowMenuButton = !_ISShowMenuButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
