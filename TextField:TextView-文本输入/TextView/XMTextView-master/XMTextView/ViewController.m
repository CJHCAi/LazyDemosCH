//
//  ViewController.m
//  XMTextView
//
//  Created by XM on 2018/6/29.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "ViewController.h"
#import "XMTextView.h"
#import "UITextView+XMExtension.h"
//__weak block 的宏定义
#define WEAKSELF typeof(self) __weak weakSelf = self;

/** 是否是iphoneX设备 */
#define IS_PhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define NavFrame (IS_PhoneX?CGRectMake(0, 0, WIDTH, 88):CGRectMake(0, 0, WIDTH, 64))
#define SCROLLVIEW_CONTENTSIZE (HEIGHT - NavFrame.size.height + 1)

// 宽高
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"XMTextView";
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentInset = UIEdgeInsetsMake(NavFrame.size.height, 0, 0, 0);
    [self.view addSubview:scrollView];
    
    XMTextView *tv = [[XMTextView alloc] initWithFrame:CGRectMake(16, 10, self.view.frame.size.width-2*16, 200)];
    tv.textFont = [UIFont systemFontOfSize:20];
    [scrollView addSubview:tv];
    
    WEAKSELF
    tv.textViewListening = ^(NSString *textViewStr) {
        NSLog(@"tv监听输入的内容：%@",textViewStr);
//        weakSelf.
    };
    
    XMTextView *tv2 = [[XMTextView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(tv.frame)+20, self.view.frame.size.width-2*16, 200)];
    tv2.placeholder = @"自定义placeholder";
    tv2.placeholderColor = [UIColor blueColor];
    tv2.borderLineColor = [UIColor redColor];
    tv2.textColor = [UIColor greenColor];
    tv2.textFont = [UIFont systemFontOfSize:18];
    tv2.textMaxNum = 1000;
    tv2.maxNumState = XMMaxNumStateDiminishing;
    [scrollView addSubview:tv2];
    tv2.textViewListening = ^(NSString *textViewStr) {
        NSLog(@"tv2监听输入的内容：%@",textViewStr);
    };
    
    UITextView *tv3 = [[UITextView alloc] init];
    tv3.frame = CGRectMake(16, CGRectGetMaxY(tv2.frame)+20, self.view.frame.size.width-2*16, 200);
    tv3.placeholder = @"UITextView可以直接使用placeholder和placeholderColor属性";
    tv3.placeholderColor = [UIColor purpleColor];
    tv3.textColor = [UIColor redColor];
    tv3.font = [UIFont systemFontOfSize:20];
    [scrollView addSubview:tv3];
    
    scrollView.contentSize = CGSizeMake(WIDTH, 1000);
}

#pragma  mark - 滚动scrollView 键盘退下
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    // 取消键盘
    [self.view endEditing:YES];
    
}


@end
