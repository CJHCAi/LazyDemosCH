//
//  YXWBaseViewController.m
//  StarAlarm
//
//  Created by dllo on 16/3/30.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWBaseViewController.h"

@interface YXWBaseViewController ()

@property (nonatomic, strong) UIImageView *customBackImageView;
@property (nonatomic, assign) BOOL *isFirstWall;

@end

@implementation YXWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self setCustomBackImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNotification:) name:@"image" object:nil];
    
    [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
    self.customBackImageView.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"image"]];
}

- (void)setCustomBackImageView {
    self.customBackImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.view addSubview:self.customBackImageView];
    [self.view sendSubviewToBack:self.customBackImageView];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstWall"]) {
        self.customBackImageView.image = [UIImage imageNamed:@"BiZhi01"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"image" object:@"BiZhi01"];
        //存本地
        [[NSUserDefaults standardUserDefaults] setObject:@"BiZhi01" forKey:@"image"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstWall"];
    } else {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNotification:) name:@"image" object:nil];
    
    [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
    self.customBackImageView.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"image"]];
    }
}

#pragma mark - 通知换壁纸方法
-(void)ChangeNotification:(NSNotification *)message {
    if ([UIImage imageWithContentsOfFile:message.object]) {
        self.customBackImageView.image = [UIImage imageWithContentsOfFile:message.object];
    } else if ([UIImage imageNamed:message.object]) {
        self.customBackImageView.image = [UIImage imageNamed:message.object];
    }
    
    NSLog(@"zzz%@",message.object);
}


@end
