//
//  ViewController.m
//  HTMLDescription
//
//  Created by 刘继新 on 2017/9/12.
//  Copyright © 2017年 TopsTech. All rights reserved.
//

#import "ViewController.h"
#import "HTMLDescription.h"
#import "URLCardView.h"
#import <SafariServices/SafariServices.h>
#import "ComposeTextParser.h"

@interface ViewController ()<ComposeTextParserDelegate, CAAnimationDelegate>

@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) URLCardView *cardView;
@property (nonatomic, strong) ComposeTextParser *textParser;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"抓取网页简介";
    self.cardView = [[URLCardView alloc]init];
    [self.view addSubview:self.cardView];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCard)]];
    self.cardView.alpha = 0;
    
    self.textParser =  [[ComposeTextParser alloc]init];
    self.textParser.delegate = self;
    
    self.textView = [[YYTextView alloc]initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, 100)];
    self.textView.font = [UIFont systemFontOfSize:18];
    self.textView.textParser = self.textParser;
    self.textView.placeholderText = @"输入网址";
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.textView.layer.borderWidth = 0.5;
    [self.view addSubview:self.textView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"粘贴测试网址" forState:0];
    [button setTintColor:[UIColor blueColor]];
    button.frame = CGRectMake(20, 180, 100, 40);
    [button addTarget:self action:@selector(paste:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)loadHTML:(NSString *)url {
    NSURL *htmlURL = [NSURL URLWithString:url];
    [HTMLDescription captureHTMLDescriptionWithURL:htmlURL complete:^(HTMLModel *data, NSError *error) {
        if (error || data.title == nil) {
            NSLog(@"error:%@", error.localizedDescription);
            [UIView animateWithDuration:0.2 animations:^{
                self.cardView.alpha = 0;
            }];
        } else {
            [self.cardView setHTMLData:data];
            [UIView animateWithDuration:0.2 animations:^{
                self.cardView.alpha = 1;
            }];
        }
    }];
}

- (void)clickCard {
    NSURL *url = [NSURL URLWithString:self.textParser.parserURL];
    SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL: url];
    [self presentViewController:safari animated:YES completion:nil];
}

- (void)paste:(UIButton *)but {
    NSString *text = @"全新iPhone。哈哈哈哈哈哈好期待 https://mp.weixin.qq.com/s/M-nGqyj8ILYfxnE5goYQsQ";
    self.textView.text = text;
}

- (void)composeTextParser:(ComposeTextParser *)parser discoverURL:(NSString *)url {
    NSLog(@"URL=\n%@\n", url);
    [self loadHTML:url];
}
@end
