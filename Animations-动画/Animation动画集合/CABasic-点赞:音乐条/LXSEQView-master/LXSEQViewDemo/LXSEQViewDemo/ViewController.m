//
//  ViewController.m
//  LXSEQViewDemo
//
//  Created by 李新星 on 15/12/16.
//  Copyright © 2015年 xx-li. All rights reserved.
//

#import "ViewController.h"
#import "LXSEQView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet LXSEQView *seqView1;
@property (weak, nonatomic) IBOutlet LXSEQView *seqView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seqView1.pillarColor = [UIColor redColor];
    self.seqView1.pillarWidth = 2;
    
    self.seqView2.pillarColor = [UIColor orangeColor];
    self.seqView2.pillarWidth = 4;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.seqView1 startAnimation];
    [self.seqView2 startAnimation];
}

@end
