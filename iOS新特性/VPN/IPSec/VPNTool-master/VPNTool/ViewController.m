//
//  ViewController.m
//  VPNTool
//
//  Created by Valentin Cherepyanko on 18/11/14.
//  Copyright (c) 2014 Valentin Cherepyanko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[VPNConnector instance] loadConfig];
    
}


- (IBAction)connectButtonTapped:(id)sender {
    [[VPNConnector instance] connect];
}

@end
