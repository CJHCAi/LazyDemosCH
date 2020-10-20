//
//  WGBViewController.m
//  WGBCommonAlertSheetView
//
//  Created by Wangguibin on 09/03/2019.
//  Copyright (c) 2019 Wangguibin. All rights reserved.
//

#import "WGBViewController.h"
#import "WGBCommonAlertSheetView.h"

@interface WGBViewController ()

@end

@implementation WGBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGRect bounds = UIScreen.mainScreen.bounds;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 500) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
    
    WGBCommonAlertSheetView *sheet = [[WGBCommonAlertSheetView alloc] initWithFrame:UIScreen.mainScreen.bounds containerView:tableView];
    sheet.isNeedBlur = arc4random()%2;
    sheet.blurStyle = arc4random()%2+1;
    sheet.touchDismiss = YES;
    [sheet show];
    
    [sheet setShowCompletionBlock:^{
        NSLog(@"视图弹出来了");
    }];
    
    [sheet setDismissCompletionBlock:^{
        NSLog(@"视图消失了");
    }];
}

@end
