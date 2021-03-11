//
//  Cell.h
//  ShowMoreText
//
//  Created by yaoshuai on 2017/1/20.
//  Copyright © 2017年 ys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Model;

@interface Cell : UITableViewCell

/**
  模型
 */
@property(nonatomic, strong) Model *model;

/**
 Block
 */
@property(nonatomic, copy) void(^showMoreBlock)(UITableViewCell *currentCell);

/**
 默认高度

 @param model 模型
 @return 默认高度
 */
+ (CGFloat)defaultHeight:(Model *)model;

/**
 展开高度

 @param model 模型
 @return 展开高度
 */
+ (CGFloat)moreHeight:(Model *)model;

@end
