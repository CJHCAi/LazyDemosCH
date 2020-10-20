//
//  AppDelegate.m
//  语言国际化
//
//  Created by ylh on 2019/12/12.
//  Copyright © 2019 ch. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIView *lunchView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController * VC = [[ViewController alloc] init];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    
//  _lunchView = [[NSBundle mainBundle ] loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
//        _lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
//         [self.window addSubview:_lunchView];
//
//        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 300)];
//        imageV.backgroundColor = [UIColor redColor];
//         NSString *str = @"http://www.jerehedu.com/images/temp/logo.gif";
//    //       [imageV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default1.jpg"]];
//
//            [_lunchView addSubview:imageV];
//
//          [self.window bringSubviewToFront:_lunchView];
//
//
//
//            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];

    return YES;
}

-(void)removeLun{

    [_lunchView removeFromSuperview];

}

#


@end
