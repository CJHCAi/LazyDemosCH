//
//  ViewController.m
//  HYCGuideView
//
//  Created by hyc on 2018/1/25.
//  Copyright © 2018年 hyc. All rights reserved.
//

#import "ViewController.h"
#import "HYCGuideView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.redColor;
    CGRect frame = CGRectMake(0, 200,self.view.frame.size.width , self.view.frame.size.height - 200);
    [self.view addSubview:[[HYCGuideView alloc]initWithaddGuideViewOnWindowImageObject:
                           @[@{
                                 @"image":@"aaa",
                                 @"frame":[NSValue valueWithCGRect:frame],
                                 @"color":[[UIColor blackColor] colorWithAlphaComponent:0.8]
                                 },
                             @{
                                 @"image":@"bbb"
                                 }
                             ] isDEBUG:YES]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
