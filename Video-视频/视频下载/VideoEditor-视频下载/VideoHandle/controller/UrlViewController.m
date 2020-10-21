//
//  DownloadViewController.m
//  VideoHandle
//
//  Created by JSB - Leidong on 17/7/6.
//  Copyright © 2017年 JSB - leidong. All rights reserved.
//

#import "UrlViewController.h"
#import "DownloadWebView.h"
#import "DownloadViewController.h"

@interface UrlViewController () <UITextViewDelegate>
{
    UILabel *_placeholderLabel;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation UrlViewController
//
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _textView.layer.cornerRadius = 4.0f;
    
    _downloadBtn.layer.cornerRadius = 4.0f;
    
    //给textview自定义placeholder
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, _textView.bounds.size.width, 20)];
    _placeholderLabel.font = [UIFont systemFontOfSize:16.0];
    _placeholderLabel.enabled = NO;//lable必须设置为不可用
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    [_textView addSubview:_placeholderLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_scrollView addGestureRecognizer:tap];
    
    [self customNaviItem];
    
    [self createUI];
}
//
-(void)viewWillAppear:(BOOL)animated{

    //获取剪贴板内容并匹配出url，并将内容放到textView中
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    _textView.text = [self urlValidation:pasteboard.string];
    
    if ([_textView.text isEqualToString:@""]) {
        
        _placeholderLabel.text = @"请将视频地址粘贴到这里";
    }
}
//定制navigationItem
-(void)customNaviItem{
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 160, 44)];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.text = @"视频下载";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:18.0];
    self.navigationItem.titleView = titleLab;
    
    //自定义返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftBtn.frame = CGRectMake(0, 0, 50, 44);
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -14, 0, 0);
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [leftBtn setImage:[UIImage imageNamed:@"p_top_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    //
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    rightBtn.frame = CGRectMake(0, 0, 66, 44);
    [rightBtn setTitleColor:COLOR(255, 193, 7, 1) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(myDownload) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [rightBtn setTitle:@"我的下载" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = item2;
}
/**
 * 网址正则验证
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为匹配之后的字符串
 */
- (NSString *)urlValidation:(NSString *)string {
    
    if (string) {
        
        NSError *error;
        //正则
        NSString *regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        
        NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        
        for (NSTextCheckingResult *match in arrayOfAllMatches){
            
            NSString *substringForMatch = [string substringWithRange:match.range];
            
            return substringForMatch;
        }
    }

    return @"";
}
//下载须知
-(void)createUI{
    //
    UILabel *lab1 = [UILabel new];
    lab1.text = @"如何复制链接？";
    lab1.font = [UIFont systemFontOfSize:15];
    lab1.textColor = COLOR(71, 71, 71, 1);
    [_scrollView addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView.mas_top).mas_offset(20);
        make.left.mas_equalTo(_scrollView.mas_left).mas_offset(31);
        make.width.mas_equalTo(SCREENWIDTH - 31 - 12);
    }];
    UILabel *lab2 = [UILabel new];
    lab2.text = @"在短视频app中选中自己心仪的视频，点击分享选择复制链接即可。";
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textColor = COLOR(133, 133, 133, 1);
    [_scrollView addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab1.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(lab1);
        make.width.mas_equalTo(lab1);
    }];
    UIView *dot1 = [UIView new];
    dot1.backgroundColor = COLOR(255, 137, 137, 1);
    dot1.layer.cornerRadius = 3.0f;
    [_scrollView addSubview:dot1];
    [dot1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lab1);
        make.right.mas_equalTo(lab1.mas_left).mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    //
    UILabel *lab3 = [UILabel new];
    lab3.text = @"如何下载？";
    lab3.font = [UIFont systemFontOfSize:15];
    lab3.textColor = COLOR(71, 71, 71, 1);
    [_scrollView addSubview:lab3];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab2.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(lab1);
        make.width.mas_equalTo(lab1);
    }];
    UILabel *lab4 = [UILabel new];
    lab4.text = @"在上方输入框中粘贴刚刚复制好的链接，点击去下载即可进入到下载页面，点击底部下载按钮即可下载视频。";
    lab4.font = [UIFont systemFontOfSize:13];
    lab4.textColor = COLOR(133, 133, 133, 1);
    [_scrollView addSubview:lab4];
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab3.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(lab1);
        make.width.mas_equalTo(lab1);
    }];
    UILabel *lab5 = [UILabel new];
    lab5.text = @"特别提示：部分视频需要先播放后才能下载。";
    lab5.font = [UIFont systemFontOfSize:13];
    lab5.textColor = COLOR(255, 137, 137, 1);
    [_scrollView addSubview:lab5];
    [lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab4.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(lab1);
        make.width.mas_equalTo(lab1);
    }];
    UIView *dot2 = [UIView new];
    dot2.backgroundColor = COLOR(255, 137, 137, 1);
    dot2.layer.cornerRadius = 3.0f;
    [_scrollView addSubview:dot2];
    [dot2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lab3);
        make.right.mas_equalTo(lab3.mas_left).mas_offset(-10);
        make.size.mas_equalTo(dot1);
    }];
    
    //
    UILabel *lab6 = [UILabel new];
    lab6.text = @"下载后的视频去哪了？";
    lab6.font = [UIFont systemFontOfSize:15];
    lab6.textColor = COLOR(71, 71, 71, 1);
    [_scrollView addSubview:lab6];
    [lab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab5.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(lab1);
        make.width.mas_equalTo(lab1);
    }];
    UILabel *lab7 = [UILabel new];
    lab7.text = @"点击我的下载即可查看下载过的视频。";
    lab7.font = [UIFont systemFontOfSize:13];
    lab7.textColor = COLOR(133, 133, 133, 1);
    [_scrollView addSubview:lab7];
    [lab7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab6.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(lab1);
        make.width.mas_equalTo(lab1);
    }];
    UIView *dot3 = [UIView new];
    dot3.backgroundColor = COLOR(255, 137, 137, 1);
    dot3.layer.cornerRadius = 3.0f;
    [_scrollView addSubview:dot3];
    [dot3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lab6);
        make.right.mas_equalTo(lab6.mas_left).mas_offset(-10);
        make.size.mas_equalTo(dot1);
    }];
    
    //
    UILabel *lab8 = [UILabel new];
    lab8.text = @"目前支持哪些短视频app的视频下载呢？";
    lab8.font = [UIFont systemFontOfSize:15];
    lab8.textColor = COLOR(71, 71, 71, 1);
    [_scrollView addSubview:lab8];
    [lab8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab7.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(lab1);
        make.width.mas_equalTo(lab1);
    }];
    UILabel *lab9 = [UILabel new];
    lab9.text = @"主要支持：快手、秒拍、火山小视频、抖音。";
    lab9.font = [UIFont systemFontOfSize:13];
    lab9.textColor = COLOR(133, 133, 133, 1);
    [_scrollView addSubview:lab9];
    [lab9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab8.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(lab1);
        make.width.mas_equalTo(lab1);
    }];
    UIView *dot4 = [UIView new];
    dot4.backgroundColor = COLOR(255, 137, 137, 1);
    dot4.layer.cornerRadius = 3.0f;
    [_scrollView addSubview:dot4];
    [dot4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lab8);
        make.right.mas_equalTo(lab8.mas_left).mas_offset(-10);
        make.size.mas_equalTo(dot1);
    }];
    
    //
//    UILabel *lab10 = [UILabel new];
//    lab10.text = @"视频教程";
//    lab10.font = [UIFont systemFontOfSize:15];
//    lab10.textColor = COLOR(71, 71, 71, 1);
//    [_scrollView addSubview:lab10];
//    [lab10 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(lab9.mas_bottom).mas_offset(20);
//        make.left.mas_equalTo(lab1);
//        make.width.mas_equalTo(lab1);
//    }];
//    UILabel *lab11 = [UILabel new];
//    lab11.text = @"http://";
//    lab11.font = [UIFont systemFontOfSize:13];
//    lab11.textColor = COLOR(133, 133, 133, 1);
//    [_scrollView addSubview:lab11];
//    [lab11 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(lab10.mas_bottom).mas_offset(8);
//        make.left.mas_equalTo(lab1);
//        make.width.mas_equalTo(lab1);
//    }];
//    UIView *dot5 = [UIView new];
//    dot5.backgroundColor = COLOR(255, 137, 137, 1);
//    dot5.layer.cornerRadius = 3.0f;
//    [_scrollView addSubview:dot5];
//    [dot5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(lab10);
//        make.right.mas_equalTo(lab10.mas_left).mas_offset(-10);
//        make.size.mas_equalTo(dot1);
//    }];
    
    lab1.numberOfLines = 0;
    lab2.numberOfLines = 0;
    lab3.numberOfLines = 0;
    lab4.numberOfLines = 0;
    lab5.numberOfLines = 0;
    lab6.numberOfLines = 0;
    lab7.numberOfLines = 0;
    lab8.numberOfLines = 0;
    lab9.numberOfLines = 0;
//    lab10.numberOfLines = 0;
//    lab11.numberOfLines = 0;
    
    if (SCREENWIDTH == 320) {
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, 350);
    }
}


#pragma mark - UITextViewDelegate
#pragma mark -
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        _placeholderLabel.text = @"请将视频地址粘贴到这里";
    } else {
        
        _placeholderLabel.text = @"";
    }
}
//按下回车收起键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        [_textView resignFirstResponder];
    }
    
    return YES;
}


#pragma mark - 各种事件
#pragma mark -
//返回
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//我的下载
-(void)myDownload{

    DownloadViewController *ctl = [DownloadViewController new];
    
    [self.navigationController pushViewController:ctl animated:YES];
}
//
- (IBAction)downloadAction:(UIButton *)sender {
    
    sender.backgroundColor = COLOR(16, 142, 233, 1);
    
    if (![_textView.text isEqualToString:@""]) {
        
        DownloadWebView *webCtl = [DownloadWebView new];
        
        webCtl.url = _textView.text;
        
        [self.navigationController pushViewController:webCtl animated:YES];
    }else{
    
        HUDTEXT(@"请输入视频网址", self.view);
    }
}
//
- (IBAction)touchDown:(UIButton *)sender {
    
    sender.backgroundColor = COLOR(18, 132, 214, 1);
}
//
- (IBAction)touchUpOut:(UIButton *)sender {
    
    sender.backgroundColor = COLOR(16, 142, 233, 1);
}
//
-(void)tap:(UITapGestureRecognizer *)tap{

    [_textView resignFirstResponder];
}


@end
