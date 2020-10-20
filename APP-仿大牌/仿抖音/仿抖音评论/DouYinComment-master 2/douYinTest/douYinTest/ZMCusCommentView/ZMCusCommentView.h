//
//  ZMCusCommentView.h
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//  评论view

#import <UIKit/UIKit.h>

@interface ZMCusCommentView : UIView

@end

@interface ZMCusCommentManager : NSObject
// 单例创建
+ (instancetype)shareManager;
// 展示方法
- (void)showCommentWithSourceId:(NSString *)sourceId;
@end
