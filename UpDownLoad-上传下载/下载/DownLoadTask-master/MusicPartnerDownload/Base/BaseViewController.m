//
//  BaseViewController.m
//  MusicPartnerDownload
//
//  GitHub:https://github.com/szweee
//  Blog:  http://www.szweee.com
//
//  Created by 索泽文 on 16/2/10.
//  Copyright © 2016年 索泽文. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = GLOBLE_BACKGROUND_COLOR;
}


-(void)showTip:(NSString *)tip{
    [[[UIAlertView alloc ] initWithTitle:@""
                                 message:tip
                                delegate:nil
                       cancelButtonTitle:@"确定"
                       otherButtonTitles:nil, nil]  show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
