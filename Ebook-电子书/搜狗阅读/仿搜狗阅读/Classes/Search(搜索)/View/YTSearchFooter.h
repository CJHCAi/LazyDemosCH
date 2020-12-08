//
//  YTSearchFooter.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTSearchFooter : UIView

@property (nonatomic, strong) NSArray *keywords;                // 推荐搜索词
@property (nonatomic, copy) void (^searchCallBack)(NSUInteger); // 点击按钮的搜索回调
@property (nonatomic, copy) void (^changeKeyWord)(NSUInteger);  // 点击最后一个按钮，换搜索词回调
@end
