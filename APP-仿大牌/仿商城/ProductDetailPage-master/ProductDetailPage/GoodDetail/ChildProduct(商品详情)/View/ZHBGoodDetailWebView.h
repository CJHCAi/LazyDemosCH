//
//  ZHBGoodDetailWebView.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/21.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

typedef NS_ENUM(NSUInteger, GoodDetailWebChooseType) {
    GoodDetailWebChooseTypeGoodDesc, // 描述
    GoodDetailWebChooseTypeGoodStandard, // 规格
};

#import <UIKit/UIKit.h>

@interface ZHBGoodDetailWebView : UIView

@property (strong, nonatomic) UIWebView *infoWebView; // webView

@property (nonatomic, copy, readonly) NSString *goodDescURL; // 商品描述
@property (nonatomic, copy, readonly) NSString *goodStandardURL; // 规格参数

@property (nonatomic, strong) UILabel *webViewHeaderMsg; // header提示msg

- (void)configureDescURL:(NSString *)descURL andStandardURL:(NSString *)standardURL;
+ (instancetype)GoodDetailWebView;

- (void)setHeaderHidden:(BOOL)isHidden;

@end
