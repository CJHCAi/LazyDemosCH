//
//  FirstTabViewController.m
//  StatusBarHeight
//
//  Created by kuanchih on 2014/7/16.
//  Copyright (c) 2014年 Jhicoll. All rights reserved.
//

#import "FirstTabViewController.h"

@interface FirstTabViewController ()

@end

@implementation FirstTabViewController

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
    // start from 0
//    self.navigationController.navigationBar.translucent = NO;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"A Title";
    titleLabel.backgroundColor = [UIColor purpleColor];
    
    UIButton *clickButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 64, 80, 40)];
    clickButton.titleLabel.text = @"Click it!";
    clickButton.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:clickButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
