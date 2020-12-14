//
//  YTSearchBar.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTSearchBar : UISearchBar

@property (nonatomic, copy) void (^searchBarShouldBeginEditingBlock)(); // 点击回调
@property (nonatomic, copy) void (^searchBarTextDidChangedBlock)();     // 编辑回调
@property (nonatomic, copy) void (^searchBarDidSearchBlock)();          // 编辑回调

+ (YTSearchBar *)searchBarWithPlaceholder:(NSString *)placeholder;
@end
