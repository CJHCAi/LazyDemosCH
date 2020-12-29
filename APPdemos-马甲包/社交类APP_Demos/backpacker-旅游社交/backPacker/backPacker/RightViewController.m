//
//  RightViewController.m
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-2.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitAccount:(id)sender {
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    [saveDefaults setValue:@"0" forKey:@"hasLogin"];
}
@end
