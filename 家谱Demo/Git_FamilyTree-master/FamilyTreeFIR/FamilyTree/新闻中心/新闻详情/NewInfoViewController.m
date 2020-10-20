//
//  NewInfoViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "NewInfoViewController.h"
#import "NewInfoModel.h"

@interface NewInfoViewController ()<UIWebViewDelegate>
/** 新闻详细模型*/
@property (nonatomic, strong) NewInfoModel *newsInfoModel;
/** 背景滚动视图*/
@property (nonatomic, strong) UIScrollView *backSV;
/** 网络视图*/
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation NewInfoViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    //[self initUI];
    [self getData];
    
}

-(void)getData{
    NSDictionary *logDic = @{@"ArId":@(self.arId)};
    WK(weakSelf)
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeGetNewsDetail success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"----------%@",[NSString jsonDicWithDic:jsonDic[@"data"]]);
        if (succe) {
            weakSelf.newsInfoModel = [NewInfoModel modelWithJSON:jsonDic[@"data"]];
            [weakSelf initUI];
        }
    } failure:^(NSError *error) {
        
    }];

}

-(void)initUI{
    self.view.backgroundColor = LH_RGBCOLOR(236, 236, 236);
    NSString *str = [self.newsInfoModel.ArContent stringByReplacingOccurrencesOfString:@"/http" withString:@"http"];
    //限定图片大小不超过屏幕宽
    NSString *str1 = [NSString stringWithFormat:@"<head><style>img{max-width:%lfpx !important;}</style></head>%@",Screen_width-20,str];
    [self.webView loadHTMLString:str1 baseURL:nil];
    [self.view addSubview:self.webView];
}

#pragma mark - lazyLoad
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
        //消除上下拉黑边
        for (id subview in _webView.subviews){
            if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
                ((UIScrollView *)subview).bounces = NO;
            }
        }
        for (UIView* subView in [_webView subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView* shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        [shadowView setHidden:YES];
                    }
                }
            }
        }
    }
    return _webView;
}

@end
