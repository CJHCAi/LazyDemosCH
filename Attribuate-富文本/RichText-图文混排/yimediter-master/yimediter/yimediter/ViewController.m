//
//  ViewController.m
//  yimediter
//
//  Created by ybz on 2017/11/17.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "ViewController.h"

#import "YIMEditerTextView.h"
#import "WebViewController.h"

@interface ViewController ()

@property (strong, nonatomic) YIMEditerTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"to html" style:UIBarButtonItemStyleDone target:self action:@selector(clickTest:)];
    
    
    YIMEditerTextView *textView = [[YIMEditerTextView alloc]init];
    
    [self.view addSubview:textView];
    
    textView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[textView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,textView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[textView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.view,textView)]];
    self.textView = textView;
}
-(void)clickTest:(id)sender{
    WebViewController *webVc = [[WebViewController alloc]init];
    webVc.htmlString = [self.textView outPutHtmlString];
    [self.navigationController pushViewController:webVc animated:true];
}


#pragma -mark delegates



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
