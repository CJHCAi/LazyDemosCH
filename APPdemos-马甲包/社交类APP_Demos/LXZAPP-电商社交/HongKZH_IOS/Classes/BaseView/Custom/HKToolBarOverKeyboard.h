//
//  HKToolBarOverKeyboard.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKToolBarOverKeyboard : UIView

/**
 设置数量 必选
 */
@property (nonatomic,strong) NSArray<NSString *> *itemsWithImageNames;

/**
 初始化

 @param frame toolbar的大小和位置，内置高度
 @param imageNames imageNames 图片的名字 给多少图片就创建多少items
 @return HKToolBarOverKeyboard
 */
+ (id)initWithFrame:(CGRect)frame itemImageNames:(NSArray <NSString *> *)imageNames inView:(UIView *)view;
/**
 点击按钮回调
 索引从左到右依次为0....
 */
@property (nonatomic,copy) void (^clickItemCallback)(NSInteger index);

@end
