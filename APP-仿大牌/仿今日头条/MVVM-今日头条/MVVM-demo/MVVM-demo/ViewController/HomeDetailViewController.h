//
//  HomeDetailViewController.h
//  MVVM-demo
//
//  Created by shen_gh on 16/4/13.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeDetailViewController : UIViewController

@property (nonatomic,strong) NSString *navTitle;//导航栏标题
@property (nonatomic,strong) NSString *urlStr;//用webView加载详情

@end
