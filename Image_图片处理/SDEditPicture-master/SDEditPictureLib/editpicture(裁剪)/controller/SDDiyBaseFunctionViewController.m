//
//  SDDiyBaseFunctionViewController.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/24.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDDiyBaseFunctionViewController.h"

@interface SDDiyBaseFunctionViewController ()

@end

@implementation SDDiyBaseFunctionViewController
- (instancetype)initWithFinishBlock:(SDDiyImageFinishBlock)finishBlock
{
    self = [super init];
    if (self) {
        _diyFinishBlock = finishBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelAction
{
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}

- (void)onSureAction
{

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
