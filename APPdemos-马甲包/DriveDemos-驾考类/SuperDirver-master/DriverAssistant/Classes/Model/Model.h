//
//  Model.h
//  ShowMoreText
//
//  Created by yaoshuai on 2017/1/20.
//  Copyright © 2017年 ys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

/**
 标题
 */
@property(nonatomic, strong) NSString *title;

/**
 内容
 */
@property(nonatomic, strong) NSString *content;

/**
 是否处于展开状态，默认NO
 */
@property(nonatomic, assign) BOOL isShowMoreText;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
