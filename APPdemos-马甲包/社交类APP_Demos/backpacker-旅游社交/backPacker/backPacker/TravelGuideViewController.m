//
//  TravelGuideViewController.m
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-10.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "TravelGuideViewController.h"

@interface TravelGuideViewController ()

@end

@implementation TravelGuideViewController

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
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:5.0/255.0 green:111.0/255.0 blue:209.0/255.0 alpha:1.0]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
