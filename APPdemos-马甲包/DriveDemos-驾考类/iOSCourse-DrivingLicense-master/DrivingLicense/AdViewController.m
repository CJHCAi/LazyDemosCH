//
//  AdViewController.m
//  DrivingLicense
//
//  Created by #incloud on 17/2/14.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "AdViewController.h"
#import "JOYConnect.h"

@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [JOYConnect showBan:self adSize:E_SIZE_414x70 showX:0 showY:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
