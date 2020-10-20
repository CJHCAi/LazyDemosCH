//
//  CHCommentView.m
//  仿抖音
//
//  Created by 七啸网络 on 2018/5/18.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "CHCommentView.h"

@implementation CHCommentView
-(instancetype)initWithFrame:(CGRect)frame{
  
    if (self==[super initWithFrame:frame]) {
        
    }
    return self;
}

#pragma mark - 滑动动效
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_delegate respondsToSelector:@selector(CommentViewTouchBegin:)]) {
        [_delegate CommentViewTouchBegin:touches];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_delegate respondsToSelector:@selector(CommentViewTouchMove:)]) {
        [_delegate CommentViewTouchMove:touches];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([_delegate respondsToSelector:@selector(CommentViewTouchEnd:)]) {
        [_delegate CommentViewTouchEnd:touches];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

@end
