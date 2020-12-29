//
//  HKTitleViewSearchViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "BackSearchNabarView.h"
@interface HKTitleViewSearchViewController : HK_BaseView<BackSearchNabarViewDelegate>
@property (nonatomic, strong)BackSearchNabarView *nabarView;
@end
