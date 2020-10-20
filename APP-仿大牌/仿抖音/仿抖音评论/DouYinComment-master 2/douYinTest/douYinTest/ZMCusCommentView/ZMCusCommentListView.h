//
//  ZMCusCommentListView.h
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//  评论列表view

#import <UIKit/UIKit.h>
#define ZMCusCommentViewTopHeight 101
#define ZMCusComentBottomViewHeight 55
@interface ZMCusCommentListView : UIView

@property (nonatomic, copy) void(^closeBtnBlock)(void);
@property (nonatomic, copy) void(^tapBtnBlock)(void);
@end
