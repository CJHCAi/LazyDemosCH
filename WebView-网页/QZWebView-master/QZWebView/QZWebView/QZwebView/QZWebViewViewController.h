//
//  QZWebViewViewController.h
//  QZWebView
//
//  Created by 曲终叶落 on 2017/7/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZWebViewViewController : UIViewController

/**
 通过网页链接初始化
 @param url 链接
 @return return value description
 */
- (instancetype)initWithURL:(NSString *)url;


/**
 通过本地文件初始化
 @param filePath 本地文件位置
 @return return value description
 */
- (instancetype)initWithFilePath:(NSString *)filePath;

@property (nonatomic, assign) BOOL hideNav;


@end
