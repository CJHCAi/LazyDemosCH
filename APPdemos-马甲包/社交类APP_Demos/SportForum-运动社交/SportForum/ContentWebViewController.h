//
//  ContentWebViewController.h
//  SportForum
//
//  Created by liyuan on 3/19/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ContentWebViewController : BaseViewController<UIWebViewDelegate>

@property(nonatomic, strong) ArticlesObject* articlesObject;

@end
