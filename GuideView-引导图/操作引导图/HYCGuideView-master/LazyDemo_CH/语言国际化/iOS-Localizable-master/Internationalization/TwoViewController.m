//
//  TwoViewController.m
//  Internationalization
//
//  Created by Qiulong-CQ on 16/12/2.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconImage.newImage = @"50.png";
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
