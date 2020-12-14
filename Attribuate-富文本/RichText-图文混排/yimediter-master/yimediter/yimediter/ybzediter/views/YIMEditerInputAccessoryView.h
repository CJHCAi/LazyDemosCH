//
//  YIMEditerInputAccessoryView.h
//  yimediter
//
//  Created by ybz on 2017/11/17.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIMEditerAccessoryMenuItem.h"

@class YIMEditerInputAccessoryView;

@protocol YIMEditerInputAccessoryViewDelegate <NSObject>

/**
 点击Item时执行
 返回值是否选中到该item
 */
-(BOOL)YIMEditerInputAccessoryView:(YIMEditerInputAccessoryView*)accessoryView clickItemAtIndex:(NSInteger)index;

@end


/**
 键盘上面的菜单视图
 */
@interface YIMEditerInputAccessoryView : UIView

@property(nonatomic,strong)NSArray<YIMEditerAccessoryMenuItem*>* items;
@property(nonatomic,weak)id<YIMEditerInputAccessoryViewDelegate> delegate;

@end
