//
//  CXViewController.m
//  CXShearchBar
//
//  Created by caixiang305621856 on 04/26/2019.
//  Copyright (c) 2019 caixiang305621856. All rights reserved.
//

#import "CXViewController.h"
#import "CXSearchViewController.h"

@interface CXViewController ()

@end

@implementation CXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)didClick:(id)sender {
    CXSearchViewController *searchViewController = [[CXSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
