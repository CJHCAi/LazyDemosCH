//
//  ZHBGoodDetailWebView.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/21.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBGoodDetailWebView.h"
#define END_DRAG_SHOW_HEIGHT    60.0f       // 结束拖拽最大值时的显示
@interface ZHBGoodDetailWebView ()

@property (nonatomic, copy, readwrite) NSString *goodDescURL; // 商品描述
@property (nonatomic, copy, readwrite) NSString *goodStandardURL; // 规格参数

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *goodDescButton;
@property (nonatomic, strong) UIButton *goodStandardButton;
@property (nonatomic, strong) UIView *pinklineView;
@end

@implementation ZHBGoodDetailWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupContentView];
        [self setupContentConstraints];
        // 效果按ui
//        @weakify(self);
//        self.infoWebView.scrollView.mj_header = [APXRefreshGifHeader headerWithRefreshingBlock:^{
//            @strongify(self);
//            [self.infoWebView.scrollView.mj_header endRefreshing];
//        }];
    }
    return self;
}

- (void)setupContentView
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.goodDescButton];
    [self.headerView addSubview:self.goodStandardButton];
    [self.headerView addSubview:self.pinklineView];
    
    [self addSubview:self.infoWebView];
}
- (void)setupContentConstraints
{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.top.mas_equalTo(self);
        make.width.mas_equalTo(212);
        make.height.mas_equalTo(40);
    }];
    
    [self.goodDescButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.headerView);
        make.leading.mas_equalTo(self.headerView).offset(6);
        make.width.mas_equalTo(60);
    }];
    [self.goodStandardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(self.headerView);
        make.trailing.mas_equalTo(self.headerView).offset(-6);
        make.width.mas_equalTo(60);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = [UIColor colorWithName:kF1F2F6Color];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.mas_equalTo(self);
        make.bottom.mas_equalTo(self.headerView);
        make.height.mas_equalTo(0.5);
    }];
    
    
    [self.infoWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
}


#pragma mark - public
+ (instancetype)GoodDetailWebView
{
    return [[ZHBGoodDetailWebView alloc] init];
}

- (void)setHeaderHidden:(BOOL)isHidden
{
//    self.infoWebView.scrollView.mj_header.hidden = isHidden;
}

- (void)configureDescURL:(NSString *)descURL andStandardURL:(NSString *)standardURL
{
    self.goodDescURL = descURL;
    self.goodStandardURL = standardURL;
    // 首页打开加载描述
    [self goodDescBtnClick:nil];
}

#pragma mark - private
- (void)goodDescBtnClick:(id)sender
{
    
#ifdef APPANALYTICS
    [[APXAnalytics sharedInstance] logEvent:kAnalyticsEvent_PD_GD parameters:nil];
#endif
    
    [self.infoWebView loadRequest:[self URLRequestFromStr:self.goodDescURL]];
//    [self.goodDescButton setTitleColor:redSwitchColor forState:UIControlStateNormal];
    [self.goodStandardButton setTitleColor:ColorWithHex(0x555555) forState:UIControlStateNormal];
    
    // 首次进入此方法,goodDescButton未初始化frame
    if (self.goodDescButton.centerX != 0) {
        self.pinklineView.centerX = self.goodDescButton.centerX;
    }
}
- (void)goodStandardBtnClick:(id)sender
{
#ifdef APPANALYTICS
    [[APXAnalytics sharedInstance] logEvent:kAnalyticsEvent_PD_STAND parameters:nil];
#endif
    
    [self.infoWebView loadRequest:[self URLRequestFromStr:self.goodStandardURL]];
//    [self.goodStandardButton setTitleColor:redSwitchColor forState:UIControlStateNormal];
    [self.goodDescButton setTitleColor:ColorWithHex(0x555555) forState:UIControlStateNormal];

    self.pinklineView.centerX = self.goodStandardButton.centerX;
}
- (NSURLRequest *)URLRequestFromStr:(NSString *)URLString
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
}


#pragma mark - lazy load
- (UILabel *)webViewHeaderMsg
{
    if (!_webViewHeaderMsg) {
        _webViewHeaderMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, END_DRAG_SHOW_HEIGHT - 20, kScreenWidth, 20)];
        _webViewHeaderMsg.textColor = ColorWithHex(0x6A6A6A);
        [_webViewHeaderMsg setFont:[UIFont systemFontOfSize:15]];
        _webViewHeaderMsg.textAlignment = NSTextAlignmentCenter;
        [self.infoWebView addSubview:_webViewHeaderMsg];
    }
    return _webViewHeaderMsg;
}

- (UIView *)pinklineView
{
    if (!_pinklineView) {
        _pinklineView = [[UIView alloc] initWithFrame:CGRectMake(3, 38, 66, 2)];
//        _pinklineView.backgroundColor = redSwitchColor;
    }
    return _pinklineView;
}
- (UIWebView *)infoWebView
{
    if (!_infoWebView) {
        _infoWebView = [[UIWebView alloc] init];
        _infoWebView.backgroundColor = ColorWithHex(0xf5f5f5);
    }
    return _infoWebView;
}
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
- (UIButton *)goodDescButton
{
    if (!_goodDescButton) {
        _goodDescButton = [[UIButton alloc] init];
        [_goodDescButton setTitle:@"商品描述" forState:UIControlStateNormal];
        [_goodDescButton setTitleColor:ColorWithHex(0x555555) forState:UIControlStateNormal];
        [_goodDescButton addTarget:self action:@selector(goodDescBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _goodDescButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _goodDescButton;
}
- (UIButton *)goodStandardButton
{
    if (!_goodStandardButton) {
        _goodStandardButton = [[UIButton alloc] init];
        [_goodStandardButton setTitle:@"规格参数" forState:UIControlStateNormal];
        [_goodStandardButton setTitleColor:ColorWithHex(0x555555) forState:UIControlStateNormal];
        [_goodStandardButton addTarget:self action:@selector(goodStandardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _goodStandardButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _goodStandardButton;
}



@end
