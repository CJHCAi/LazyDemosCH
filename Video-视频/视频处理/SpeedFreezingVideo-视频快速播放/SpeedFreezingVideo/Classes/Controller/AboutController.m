//
//  AboutController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/9/24.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "AboutController.h"

#define APP_ID @"1158640223"

@interface AboutController ()
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIView *copyrightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signViewCenterYConstraint;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *adaptiveConstraints;
@property (assign, nonatomic) BOOL isAnimating;
@end

@implementation AboutController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self modifyNavigationBar];
    [self screenAdaptive];
    [self signAnim];
}

- (void)screenAdaptive {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat adaptiveRatio= 1;
    if (screenHeight == 480) {//i4
        adaptiveRatio = 0.6f;
    } else if (screenHeight == 568) {//i5
        adaptiveRatio = 0.7f;
    } else if (screenHeight == 667){//6
        adaptiveRatio = 0.9f;
    }
    for (NSLayoutConstraint *constraint in _adaptiveConstraints) {
        constraint.constant *= adaptiveRatio;
    }
}

- (void)modifyNavigationBar {
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
     UIBarButtonItem *rightTopButton = [[UIBarButtonItem alloc] initWithTitle:@"评价" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightTopButton)];
    self.navigationItem.rightBarButtonItem = rightTopButton;
}

- (void)signAnim {
    self.isAnimating = YES;
    CGRect signViewFromFrame = _signView.frame;
    CGRect signViewToFrame = signViewFromFrame;
    signViewToFrame.origin.y -= 50;
    
    _copyrightView.alpha = 0;
    _signView.alpha = 1;
    [UIView animateWithDuration:3.f animations:^{
        _signView.alpha = 0;
        _signViewCenterYConstraint.constant -= 50;
        [_signView setFrame:signViewToFrame];
    } completion:^(BOOL finished) {
        _copyrightView.alpha = 1;
        _signViewCenterYConstraint.constant += 50;
        [_signView setFrame:signViewFromFrame];
        self.isAnimating = NO;
    }];
}

- (void)clickRightTopButton {
    NSString *urlString = [NSString stringWithFormat:
     @"itms-apps://itunes.apple.com/app/id%@", APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_isAnimating) {
        [self signAnim];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
