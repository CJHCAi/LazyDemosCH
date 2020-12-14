//
//  ARSearchFooter.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARSearchFooter : UIView

@property (nonatomic, strong) NSArray *keywords;                // 推荐搜索词
@property (nonatomic, copy) void (^searchCallBack)(NSUInteger); // 点击按钮的搜索回调
@property (nonatomic, copy) void (^changeKeyWord)(NSUInteger);  // 点击最后一个按钮，换搜索词回调

@end
