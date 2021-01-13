//
//  NFDisclaimerVC.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFDisclaimerVC.h"

@interface NFDisclaimerVC ()
{
    UITextView *_disclaimerView;
}
@end

@implementation NFDisclaimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackNavItem];
    [self setUpSubviews];
}
- (void)setUpSubviews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _disclaimerView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64)];
    _disclaimerView.selectable = NO;
    [_disclaimerView setTextContainerInset:UIEdgeInsetsMake(20, 10, 5, 10)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:YC_Base_TitleFont,
                                 NSParagraphStyleAttributeName:style,
                                 NSForegroundColorAttributeName:YC_Base_TitleColor
                                 };
    
    NSString *desStr = [NSString stringWithFormat:@"    %@部分内容来自用户，属个人行为，不代表%@立场，如有侵权，%@不因此承担任何法律责任。如有发现%@存在任何侵权行为，请及时联系，我们会尽快处理。欢迎广大用户监督。\n\n联系方式:\n邮箱:1468407663@qq.com",kAppName,kAppName,kAppName,kAppName];
    _disclaimerView.attributedText = [[NSAttributedString alloc] initWithString:desStr attributes:attributes];
    
    [self.view addSubview:_disclaimerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
